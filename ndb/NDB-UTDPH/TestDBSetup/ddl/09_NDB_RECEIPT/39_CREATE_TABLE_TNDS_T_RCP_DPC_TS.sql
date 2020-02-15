CREATE TABLE TNDS_T_RCP_DPC_TS
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_TRUE_DAYS               NUMBER   (2,0),
TOTAL_SCORE                  NUMBER   (8,0),
TIMES                        NUMBER   (2,0),
TOTAL_PRICE                  NUMBER   (8,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
