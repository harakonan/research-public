CREATE TABLE TNDS_T_RCP_DPC_GT
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_YM_GT                   VARCHAR2 (5),
REQ_ADJST_DIV                VARCHAR2 (1),
SELF_OTHER_INSU_DIV          VARCHAR2 (1),
BURD_DIV                     VARCHAR2 (1),
INCSN_SBTTL_SCORE_SUM        NUMBER   (7,0),
INCSN_EVALU_SCORE            NUMBER   (7,0),
ADJST_SCORE                  NUMBER   (7,0),
THIS_INCSN_TTL_SCORE         NUMBER   (8,0),
PRAC_IDENT                   VARCHAR2 (2),
CHANGE_YMD                   VARCHAR2 (7),
CHAR_DAT                     NVARCHAR2(20),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
