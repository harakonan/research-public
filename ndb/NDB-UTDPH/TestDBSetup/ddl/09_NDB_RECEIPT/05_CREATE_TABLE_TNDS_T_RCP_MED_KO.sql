CREATE TABLE TNDS_T_RCP_MED_KO
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
DEFRAYER_NO                  VARCHAR2 (8),
EX_GRATIA_PAY_DIV            VARCHAR2 (1),
PRAC_TRUE_DAYS               NUMBER   (2,0),
TOTAL_SCORE                  NUMBER   (8,0),
PUB_MONEY                    NUMBER   (8,0),
PUB_MONEY_PAY_OUTPT_BURD     NUMBER   (6,0),
PUB_MONEY_PAY_HOSTZ_BURD     NUMBER   (6,0),
RESERVE_01                   VARCHAR2 (5),
TIMES                        NUMBER   (2,0),
TOTAL_PRICE                  NUMBER   (8,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
