CREATE TABLE TNDS_M_AGE_BIRTH_WT
(
MDC_CD                       VARCHAR2 (2) NOT NULL ENABLE,
CLS_CD                       VARCHAR2 (4) NOT NULL ENABLE,
CNDTN_DIV                    VARCHAR2 (1) NOT NULL ENABLE,
CNDTN_NAME                   NVARCHAR2(10),
CNDTN1_MORE                  VARCHAR2 (4),
CNDTN1_LESS                  VARCHAR2 (4),
CNDTN1_VAL                   VARCHAR2 (1),
CNDTN2_MORE                  VARCHAR2 (4),
CNDTN2_LESS                  VARCHAR2 (4),
CNDTN2_VAL                   VARCHAR2 (1),
CNDTN3_MORE                  VARCHAR2 (4),
CNDTN3_LESS                  VARCHAR2 (4),
CNDTN3_VAL                   VARCHAR2 (1),
CNDTN4_MORE                  VARCHAR2 (4),
CNDTN4_LESS                  VARCHAR2 (4),
CNDTN4_VAL                   VARCHAR2 (1),
CNDTN5_MORE                  VARCHAR2 (4),
CNDTN5_LESS                  VARCHAR2 (4),
CNDTN5_VAL                   VARCHAR2 (1),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_AGE_BIRTH_WT_PK PRIMARY KEY (MST_GEN,MDC_CD,CLS_CD,CNDTN_DIV) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
