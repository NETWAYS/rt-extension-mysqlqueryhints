use inc::Module::Install;

RTx     'RT-Extension-MySQLQueryHints';
license 'gpl_2';
repository 'https://github.com/NETWAYS/rt-extension-mysqlqueryhints';

requires_rt '4.2.0';
rt_too_new '4.6.0';

sign;
WriteAll;
