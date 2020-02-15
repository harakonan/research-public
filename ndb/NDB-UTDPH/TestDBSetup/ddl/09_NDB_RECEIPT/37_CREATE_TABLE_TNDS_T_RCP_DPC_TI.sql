CREATE TABLE TNDS_T_RCP_DPC_TI
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
ORGAN_DONAT_DIV              VARCHAR2 (1),
ORGAN_DONAT_MEDI_INST_DIV    VARCHAR2 (1),
TDFK                         VARCHAR2 (2),
SCORE_LIST                   VARCHAR2 (1),
MEDI_INST_CD_ORG             VARCHAR2 (7),
MEDI_INST_CD                 VARCHAR2 (7),
PRAC_DEPT_CD                 VARCHAR2 (2),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
