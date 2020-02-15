CREATE TABLE TNDS_M_SPT_AMO_INS_EACH_OO
(
NUM_INS_NUM                  VARCHAR2 (2),
INSURER_CD_ORG               VARCHAR2 (8) NOT NULL ENABLE,
INSURER_NAME                 NVARCHAR2(127),
SME_TGT_NUM                  NUMBER   (10,0),
SME_CNSLT_NUM                NUMBER   (10,0),
JDG_TGT_NUM                  NUMBER   (10,0),
SME_CNSLT_RATE               NUMBER   (10,3),
GHS_PSTV_TGT_NUM             NUMBER   (10,0),
GHS_MTVT_TGT_NUM             NUMBER   (10,0),
GHS_TGT_NUM                  NUMBER   (10,0),
GHS_PSTV_CMPLT_NUM           NUMBER   (10,0),
GHS_MTVT_CMPLT_NUM           NUMBER   (10,0),
GHS_CMPLT_NUM                NUMBER   (10,0),
GHS_OPRTN_RATE               NUMBER   (10,3),
OLD_OLD_SPRT_PRICE           NUMBER   (15,0),
INSURER_CD                   VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_SPT_AMO_INS_EACH_OO_PK PRIMARY KEY (MST_GEN,INSURER_CD_ORG) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
