CREATE TABLE TNDS_M_SURG_CD
(
INDEX_NO                     NUMBER   (4,0) NOT NULL ENABLE,
DIV_CD                       VARCHAR2 (2),
SURG_CD                      NVARCHAR2(10),
SURG_CD_NAME                 NVARCHAR2(256),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_SURG_CD_PK PRIMARY KEY (MST_GEN,INDEX_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
