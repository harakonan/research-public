CREATE TABLE "CMDS_M_BODY_PART"
(
"BODY_PART"                    VARCHAR2 (3) NOT NULL ENABLE,
"BODY_PART_NAME"               NVARCHAR2(8),
    CONSTRAINT "CMDS_M_BODY_PART_PK" PRIMARY KEY ("BODY_PART") USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
