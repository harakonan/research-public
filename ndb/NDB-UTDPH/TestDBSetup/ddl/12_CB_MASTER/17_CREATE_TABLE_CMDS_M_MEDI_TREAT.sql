CREATE TABLE "CMDS_M_MEDI_TREAT"
(
"MEDI_TREAT"                   VARCHAR2 (3) NOT NULL ENABLE,
"MEDI_TREAT_NAME"              NVARCHAR2(16),
    CONSTRAINT "CMDS_M_MEDI_TREAT_PK" PRIMARY KEY ("MEDI_TREAT") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
