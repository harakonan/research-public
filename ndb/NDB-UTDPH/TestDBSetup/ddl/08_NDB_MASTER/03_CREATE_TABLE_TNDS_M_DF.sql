CREATE TABLE TNDS_M_DF
(
CHG_DIV                      VARCHAR2 (1),
MST_CLS                      VARCHAR2 (1),
DF_CD                        VARCHAR2 (6) NOT NULL ENABLE,
RESERVE_01                   NUMBER   (3,0),
DF_NAME                      NVARCHAR2(50),
CHG_YMD                      VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_DF_PK PRIMARY KEY (MST_GEN,DF_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
