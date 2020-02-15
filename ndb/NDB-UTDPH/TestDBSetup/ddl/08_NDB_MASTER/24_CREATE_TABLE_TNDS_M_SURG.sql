CREATE TABLE TNDS_M_SURG
(
INDEX_NO                     NUMBER   (5,0) NOT NULL ENABLE ,
MDC_CD                       VARCHAR2 (2),
CLS_CD                       VARCHAR2 (4),
VAL                          VARCHAR2 (2),
SURG_FLG                     VARCHAR2 (2),
AGE_BIRTH_WT_VAL             VARCHAR2 (6),
CRSPD_CD                     VARCHAR2 (2),
SURG1_SCORE_LIST_NAME        NVARCHAR2(80),
SURG1_K_CD                   NVARCHAR2(10),
SURG2_SCORE_LIST_NAME        NVARCHAR2(60),
SURG2_K_CD                   NVARCHAR2(10),
SURG3_SCORE_LIST_NAME        NVARCHAR2(60),
SURG3_K_CD                   NVARCHAR2(10),
SURG4_SCORE_LIST_NAME        NVARCHAR2(60),
SURG4_K_CD                   NVARCHAR2(10),
SURG5_SCORE_LIST_NAME        NVARCHAR2(60),
SURG5_K_CD                   NVARCHAR2(10),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_SURG_PK PRIMARY KEY (MST_GEN,INDEX_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
