CREATE TABLE "CMDS_M_EXAM_PAY_INST"
(
"EXAM_PAY_INST"                VARCHAR2 (1) NOT NULL ENABLE,
"EXAM_PAY_INST_NAME"           NVARCHAR2(30),
    CONSTRAINT "CMDS_M_EXAM_PAY_INST_PK" PRIMARY KEY ("EXAM_PAY_INST") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
