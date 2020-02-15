CREATE TABLE TNDS_T_RCP_PHA_KO
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
DEFRAYER_NO                  VARCHAR2 (8),
EX_GRATIA_PAY_DIV            VARCHAR2 (1),
PRSPT_RCPTN_TIMES            NUMBER   (2,0),
TOTAL_SCORE                  NUMBER   (8,0),
RESERVE_01                   VARCHAR2 (5),
PART_BURD                    NUMBER   (8,0),
RESERVE_02                   VARCHAR2 (6),
PUB_MONEY_PAY_PART_BURD      NUMBER   (6,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
