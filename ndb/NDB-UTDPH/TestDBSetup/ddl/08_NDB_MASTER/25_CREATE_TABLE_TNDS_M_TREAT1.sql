CREATE TABLE TNDS_M_TREAT1
(
INDEX_NO                     NUMBER   (5,0) NOT NULL ENABLE ,
MDC_CD                       VARCHAR2 (2),
CLS_CD                       VARCHAR2 (4),
CRSPD_CD                     VARCHAR2 (1),
TREAT1_FLG                   VARCHAR2 (1),
SURG_CMB_CNDTN               VARCHAR2 (7),
TREAT_ETC1_NAME              NVARCHAR2(50),
TREAT_ETC1_CD                NVARCHAR2(10),
TREAT_ETC2_NAME              NVARCHAR2(50),
TREAT_ETC2_CD                NVARCHAR2(10),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_TREAT1_PK PRIMARY KEY (MST_GEN,INDEX_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
