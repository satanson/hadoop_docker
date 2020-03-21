alter user 'root'@'localhost' identified by '123456';
flush privileges;
create user 'root'@'192.168.128.0/255.255.240.0';
# drop user 'root'@'192.168.128.0/255.255.240.0';
create user 'foobar'@'192.168.128.0/255.255.240.0';
# drop user 'foobar'@'192.168.128.0/255.255.240.0';
set password for 'root'@'192.168.128.0/255.255.240.0' = '123456';
set password for 'foobar'@'192.168.128.0/255.255.240.0' = '123456';
grant all on *.* to 'root'@'192.168.128.0/255.255.240.0';
# revoke insert, update on test.* from 'root'@'192.168.128.0/255.255.240.0';
grant all on *.* to 'foobar'@'192.168.128.0/255.255.240.0';
# revoke all on test.* from 'root'@'192.168.128.0/255.255.240.0';
flush privileges;
select user,host,authentication_string from mysql.user;
show grants;
