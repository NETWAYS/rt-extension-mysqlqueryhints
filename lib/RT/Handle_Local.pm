use strict;
no warnings qw(redefine);
package RT::Handle;

use RT::Interface::Web;

my $group_prefix    = RT->Config->Get('QueryHint_Group_Prefix') // 'RT_User_';
my $group_default   = RT->Config->Get('QueryHint_Group_Default') // 'RT_User_Default';
my $group_disable   = RT->Config->Get('QueryHint_Group_Disable') // '';
my $group_use_id    = RT->Config->Get('QueryHint_Group_UID') // '';

my $type = RT->Config->Get('DatabaseType');

sub SimpleQuery {
    my $self = shift;
    my $QueryString = shift;

    my $query_insert = '';

    if ($type eq 'mysql') {
        unless ($group_disable) {
            my $groupName = $group_default;

            if (exists $HTML::Mason::Commands::session{'CurrentUser'}) {
                my $current_user = $HTML::Mason::Commands::session{'CurrentUser'};

                if ($group_use_id) {
                    $groupName = $group_prefix . ucfirst($current_user->Id);
                }
                else {
                    $groupName = $group_prefix . ucfirst($current_user->Name);
                }

            }

            $query_insert .= sprintf('/*+ RESOURCE_GROUP(%s) */', $groupName);
        }

        if ($query_insert) {
            $QueryString =~ s/^(SELECT|INSERT|UPDATE|DELETE)/$1 $query_insert/i;
            # $RT::Logger->debug($QueryString);
        }
    }

    return $self->SUPER::SimpleQuery($QueryString, @_);
}

1;