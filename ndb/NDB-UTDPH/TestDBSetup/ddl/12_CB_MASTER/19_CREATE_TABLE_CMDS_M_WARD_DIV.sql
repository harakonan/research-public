CREATE TABLE "CMDS_M_WARD_DIV"
(
"WARD_DIV"                     VARCHAR2 (8) NOT NULL ENABLE,
"WARD_DIV_NAME"                NVARCHAR2(20),
    CONSTRAINT "CMDS_M_WARD_DIV_PK" PRIMARY KEY ("WARD_DIV") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;