CREATE TABLE TNDS_T_TRANS_JC_YEAR
(
SEIREKI                      VARCHAR2 (6) NOT NULL ENABLE,
SEIREKI_NAME                 NVARCHAR2(8),
WAREKI                       VARCHAR2 (5) NOT NULL ENABLE,
WAREKI_NAME                  NVARCHAR2(8),
    CONSTRAINT TNDS_T_TRANS_JC_YEAR_PK PRIMARY KEY (WAREKI) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
