CREATE TABLE TNDS_M_ICD
(
MDC_CD                       VARCHAR2 (2) NOT NULL ENABLE,
CLS_CD                       VARCHAR2 (4) NOT NULL ENABLE,
ICD_NAME                     NVARCHAR2(80),
ICD_CD                       VARCHAR2 (5) NOT NULL ENABLE,
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_ICD_PK PRIMARY KEY (MST_GEN,MDC_CD,CLS_CD,ICD_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
