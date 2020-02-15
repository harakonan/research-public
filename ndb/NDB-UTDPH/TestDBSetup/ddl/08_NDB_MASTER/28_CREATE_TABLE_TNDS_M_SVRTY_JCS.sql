CREATE TABLE TNDS_M_SVRTY_JCS
(
MDC_CD                       VARCHAR2 (2) NOT NULL ENABLE,
CLS_CD                       VARCHAR2 (4) NOT NULL ENABLE,
CNDTN_DIV                    VARCHAR2 (2) NOT NULL ENABLE,
CNDTN_NAME                   NVARCHAR2(3),
CNDTN1_MORE                  NUMBER   (3,0),
CNDTN1_LESS                  NUMBER   (3,0),
CNDTN1_VAL                   NUMBER   (1,0),
CNDTN2_MORE                  NUMBER   (3,0),
CNDTN2_LESS                  NUMBER   (3,0),
CNDTN2_VAL                   NUMBER   (1,0),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_SVRTY_JCS_PK PRIMARY KEY (MST_GEN,MDC_CD,CLS_CD,CNDTN_DIV) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
