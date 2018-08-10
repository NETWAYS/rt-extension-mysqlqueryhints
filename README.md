# MySQL Query Hint Extension for RequestTracker

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Configuration](#configuration)

## About

This plugin adds [optimizer hints](https://dev.mysql.com/doc/refman/8.0/en/optimizer-hints.html) to every sql query:

**[Resource Groups](https://dev.mysql.com/doc/refman/8.0/en/optimizer-hints.html#optimizer-hints-resource-group)**

Resource groups can be used to manage workloads on mysql servers. Each query can utilize a specific number of CPU
or have different thread priority. The plugin add the executing RT user to the query. You can restrict resources
for users and log which user is executing queriey (searches) on the system

**[Execution Time](https://dev.mysql.com/doc/refman/8.0/en/optimizer-hints.html#optimizer-hints-execution-time)**

Adds ```MAX_EXECUTION_TIME``` to the query without global or user based configuration on the sql server.

### Example: Slow Query Log

```
# mysqldumpslow -t 10

Count: 3  Time=0.00s (0s)  Lock=0.00s (0s)  Rows_sent=1.0 (3), Rows_examined=1.0 (3), rt_user[rt_user]@localhost
  SELECT /*+ MAX_EXECUTION_TIME(N) */ /*+ RESOURCE_GROUP(RT_User_14322) */ * FROM Tickets WHERE id = 'S' FOR UPDATE
  
Count: 35  Time=0.00s (0s)  Lock=0.00s (0s)  Rows_sent=1.9 (68), Rows_examined=1.4 (48), rt_user[rt_user]@localhost
  SELECT /*+ MAX_EXECUTION_TIME(N) */ /*+ RESOURCE_GROUP(RT_User_14322) */ main.* FROM Attributes main  WHERE
  (main.ObjectId = N) AND (main.ObjectType = 'S')  ORDER BY main.id ASC
```

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH <[support@netways.de](mailto:support@netways.de)>.

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-extension-mysqlqueryhints/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.4.2
- RT with MySQL database

## Installation

Extract this extension to a temporary location.

Navigate into the source directory and install the extension.

```
perl Makefile.PL
make
make install
```

Clear your mason cache.

```
rm -rf /opt/rt4/var/mason_data/obj
```

Restart your web server.

```
systemctl restart httpd

systemctl restart apache2
```

## Configuration

**$QueryHint_Group_Disable**

Resource groups are enabled per default. Set this to '1' to disable
resource groups.

**$QueryHint_Group_Prefix**

Prefix of the resource group. Default is ```RT_User_```.

**$QueryHint_Group_Default**

If the query is not user initiated (cli, while login), this resource
group is added. Default is RT_User_Default

**$QueryHint_Group_Use_User_Id**

Per default the user name is added to group prefix. Set this to '1' to
add user id's instead.

**$QueryHint_Max_Execution_Time**

Add ```MAX_EXECUTION_TIME(milliseconds)``` optimizer hint. Value must be
integer and represents milliseconds.

### Example

```perl
Plugin('RT::Extension::MySQLQueryHints');
Set($QueryHint_Group_UID, 1);
Set($QueryHint_Max_Execution_Time, 1500);
```
