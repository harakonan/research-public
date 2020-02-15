CREATE TABLE TNDS_M_DGC
(
INDEX_NO                     VARCHAR2 (5) NOT NULL ENABLE,
DGC_NO                       VARCHAR2 (14),
SKWD_NAME                    NVARCHAR2(80),
SURG_NAME                    NVARCHAR2(80),
TREAT_ETC1                   NVARCHAR2(10),
TREAT_ETC2                   NVARCHAR2(10),
SCND_SKWD                    NVARCHAR2(6),
SEVERITY                     NVARCHAR2(6),
HOSTZ_PRD_01                 NUMBER   (3,0),
HOSTZ_PRD_02                 NUMBER   (3,0),
HOSTZ_PRD_03                 NUMBER   (3,0),
SHP_DAYS_01                  NUMBER   (6,0),
SHP_DAYS_02                  NUMBER   (6,0),
SHP_DAYS_03                  NUMBER   (6,0),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_DGC_PK PRIMARY KEY (MST_GEN,INDEX_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
