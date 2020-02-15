CREATE TABLE TNDS_T_RCP_DPC_GA
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_YM_GA                   VARCHAR2 (5),
REQ_ADJST_DIV                VARCHAR2 (1),
STAY_OUT                     VARCHAR2 (31),
DIAG_GRP_CLS_NO              VARCHAR2 (14),
MEDI_INST_CFCNT              NUMBER   (5,4),
NEXT_HOSTZ_PLAN_YON          VARCHAR2 (1),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
