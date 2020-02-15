CREATE TABLE TNDS_T_RCP_DPC_HH
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_YM_HH                   VARCHAR2 (5),
REQ_ADJST_DIV                VARCHAR2 (1),
SELF_OTHER_INSU_DIV          VARCHAR2 (1),
BURD_DIV                     VARCHAR2 (1),
HOSTZ_PRD_DIV                NUMBER   (1,0),
HOSTZ_PRD_DIV_SCORE          NUMBER   (6,0),
HOSTZ_PRD_DIV_DAYS           NUMBER   (2,0),
INCSN_SBTTL_SCORE            NUMBER   (7,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
