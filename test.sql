create database if not exists test;
use test;
create table if not exists id_gen (id integer auto_increment primary key);
insert into id_gen values (),(),(),(),(),(),(),();
select * from id_gen;
