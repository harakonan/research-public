CREATE TABLE TNDS_T_RCP_DPC_BU
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
DIAG_GRP_CLS_NO              VARCHAR2 (14),
THIS_HOSTZ_YMD               VARCHAR2 (7),
THIS_DSCHG_YMD               VARCHAR2 (7),
DPC_OUTCM_DIV                VARCHAR2 (1),
CAUSE_DEATH                  NVARCHAR2(50),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
