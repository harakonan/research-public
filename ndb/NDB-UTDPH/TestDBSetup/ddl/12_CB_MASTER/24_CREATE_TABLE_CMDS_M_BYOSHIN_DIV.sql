CREATE TABLE "CMDS_M_BYOSHIN_DIV"
(
"BYOSHIN_DIV"                  VARCHAR2 (1) NOT NULL ENABLE,
"BYOSHIN_DIV_NAME"             NVARCHAR2(20),
    CONSTRAINT "CMDS_M_BYOSHIN_DIV_PK" PRIMARY KEY ("BYOSHIN_DIV") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
