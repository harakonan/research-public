# !bin/sh

SCRIPT_PATH="$ORACLE_HOME/../../ndb/NDB-UTDPH/TestDBSetup"

sqlplus system/o2WZcfM79ktm@//localhost:1521/NDBdummy @$SCRIPT_PATH/sql/dcl.sql

sqlplus NDB/o2WZcfM79ktm@//localhost:1521/NDBdummy @$SCRIPT_PATH/sql/ddl_create.sql

sqlplus NDB/o2WZcfM79ktm@//localhost:1521/NDBdummy @$SCRIPT_PATH/sql/dml.sql

sqlplus NDB/o2WZcfM79ktm@//localhost:1521/NDBdummy @$SCRIPT_PATH/ddl/12_CB_MASTER_VIEW/nengetsu/REFRESH/00_REFRESH_ALL.sql

