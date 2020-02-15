# !bin/sh

SCRIPT_PATH="$HOME/Workspace/ndb/NDB-UTDPH/TestDBSetup"

sqlplus system/o2WZcfM79ktm@//localhost:1521/NDBdummy @$SCRIPT_PATH/sql/dcl.sql
