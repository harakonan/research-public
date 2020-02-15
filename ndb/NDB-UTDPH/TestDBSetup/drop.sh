# !bin/sh

SCRIPT_PATH="$ORACLE_HOME/../../ndb/NDB-UTDPH/TestDBSetup"

sqlplus NDB/o2WZcfM79ktm@//localhost:1521/NDBdummy @$SCRIPT_PATH/sql/ddl_drop.sql
