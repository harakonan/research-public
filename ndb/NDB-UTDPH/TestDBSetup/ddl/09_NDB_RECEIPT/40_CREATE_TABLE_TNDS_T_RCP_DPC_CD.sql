CREATE TABLE TNDS_T_RCP_DPC_CD
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
OPRTN_YMD                    VARCHAR2 (7),
PRAC_IDENT                   VARCHAR2 (2),
ORDER_NO                     NUMBER   (4,0),
ACT_DETL_NO                  NUMBER   (3,0),
RCPT_COMP_SYS_REC            VARCHAR2 (9),
USE_AMNT                     NUMBER   (10,5),
QNT_DAT                      NUMBER   (8,0),
UNIT_CD                      VARCHAR2 (3),
TIMES                        NUMBER   (3,0),
SPCFC_DEV_NAME               NVARCHAR2(127),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
