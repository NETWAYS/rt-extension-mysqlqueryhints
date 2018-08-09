use strict;
use warnings;
package RT::Extension::MySQLQueryHints;

our $VERSION = '0.01';

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(parse_int);

=head2 parse_int($input);

Return an integer based on the input or -1 if conversion has failed

=cut

sub parse_int {
    my $input = shift;
    $input++; $input--;
    return sprintf('%d', $input);
}

=head1 NAME

RT-Extension-MySQLQueryHints - Add MySQL optimizer hints to RT queries

=head1 DESCRIPTION

Identify queries created by users and control resources.

This plugin adds mysql optimizer hints to the queries:

=head1 MYSQL SLOW QUERY LOG

=begin text

# mysqldumpslow -t 10

Count: 3  Time=0.00s (0s)  Lock=0.00s (0s)  Rows_sent=1.0 (3), Rows_examined=1.0 (3), rt_user[rt_user]@localhost
  SELECT /*+ MAX_EXECUTION_TIME(N) */ /*+ RESOURCE_GROUP(RT_User_14322) */ * FROM Tickets WHERE id = 'S' FOR UPDATE

Count: 35  Time=0.00s (0s)  Lock=0.00s (0s)  Rows_sent=1.9 (68), Rows_examined=1.4 (48), rt_user[rt_user]@localhost
  SELECT /*+ MAX_EXECUTION_TIME(N) */ /*+ RESOURCE_GROUP(RT_User_14322) */ main.* FROM Attributes main  WHERE
  (main.ObjectId = N) AND (main.ObjectType = 'S')  ORDER BY main.id ASC

=end text

=head1 RT VERSION

Works with RT 4.4.3.

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::MySQLQueryHints');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

=head2 C<$QueryHint_Group_Disable>

Resource groups are enabled per default. Set this to '1' to disable resource groups.

=head2 C<$QueryHint_Group_Prefix>

Prefix of the resource group. Default is C<RT_User_>.

=head2 C<$QueryHint_Group_Default>

If the query is not user initiated (cli, while login), this resource group is added. Default is C<RT_User_Default>

=head2 C<$QueryHint_Group_Use_User_Id>

Per default the user name is added to group prefix. Set this to '1' to add user id's instead.

=head2 C<$QueryHint_Max_Execution_Time>

Add MAX_EXECUTION_TIME(C<milliseconds>) optimizer hint. Value must be integer and represents milliseconds.

=head1 AUTHOR

NETWAYS GmbH <support@netways.de>

=head1 BUGS

All bugs should be reported on L<GitHub|https://github.com/NETWAYS/rt-extension-ticketactions>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH
This is free software, licensed under:
  The GNU General Public License, Version 2, June 1991

=cut

1;
