use strict;
no warnings qw(redefine);
package RT::Handle;

use RT::Interface::Web;
use RT::Extension::MySQLQueryHints qw/parse_int/;

my $group_prefix    = RT->Config->Get('QueryHint_Group_Prefix') // 'RT_User_';
my $group_default   = RT->Config->Get('QueryHint_Group_Default') // 'RT_User_Default';
my $group_disable   = RT->Config->Get('QueryHint_Group_Disable') // '';
my $group_use_id    = RT->Config->Get('QueryHint_Group_Use_User_Id') // '';
my $execution_time  = RT->Config->Get('QueryHint_Max_Execution_Time') // '';

my $type = RT->Config->Get('DatabaseType');

sub SimpleQuery {
    my $self = shift;
    my $QueryString = shift;

    my $query_insert = '';

    if ($type eq 'mysql') {
        if ($execution_time) {
            $execution_time = parse_int($execution_time);
            if ($execution_time > 0) {
                $query_insert .= sprintf('/*+ MAX_EXECUTION_TIME(%d) */', $execution_time);
            }
        }

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

            $query_insert .= ' ' if ($query_insert);
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
