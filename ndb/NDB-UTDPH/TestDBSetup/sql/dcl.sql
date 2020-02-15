
create tablespace NDB_USERS1 datafile '/opt/oracle/oradata/NDBdummyCDB/NDBdummy/ndb_user01.dbf' size 1000M;
create user NDB identified by o2WZcfM79ktm default tablespace NDB_USERS1 temporary tablespace temp;
grant create sequence to NDB;
grant create session to NDB;
grant create table to NDB;
grant create view to NDB;
grant create materialized view to NDB;
grant create procedure to NDB;
grant create any directory to NDB;
alter user NDB quota unlimited on NDB_USERS1;
exit;
