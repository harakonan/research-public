CREATE TABLE "CMDS_M_SEX"
(
"SEX"                          VARCHAR2 (3) NOT NULL ENABLE,
"SEX_NAME"                     NVARCHAR2(10),
    CONSTRAINT "CMDS_M_SEX_PK" PRIMARY KEY ("SEX") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
