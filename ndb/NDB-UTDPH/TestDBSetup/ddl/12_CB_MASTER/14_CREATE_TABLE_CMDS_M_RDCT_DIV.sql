CREATE TABLE "CMDS_M_RDCT_DIV"
(
"RDCT_DIV"                     VARCHAR2 (1) NOT NULL ENABLE,
"RDCT_DIV_NAME"                NVARCHAR2(8),
    CONSTRAINT "CMDS_M_RDCT_DIV_PK" PRIMARY KEY ("RDCT_DIV") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;