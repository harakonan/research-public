CREATE TABLE TNDS_M_CLS
(
MDC_CD                       VARCHAR2 (2) NOT NULL ENABLE,
CLS_CD                       VARCHAR2 (4) NOT NULL ENABLE,
NAME                         NVARCHAR2(50),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_CLS_PK PRIMARY KEY (MST_GEN,MDC_CD,CLS_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
