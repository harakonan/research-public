CREATE TABLE TNDS_T_RCP_PHA_IY
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
BURD_DIV                     VARCHAR2 (1),
MEDICINE_CD                  VARCHAR2 (9),
USE_AMNT                     NUMBER   (10,5),
RESERVE_01                   NUMBER   (7,0),
RESERVE_02                   NUMBER   (1,0),
MIX_DIV_CD                   NUMBER   (1,0),
MIX_DIV_BRNCH                NUMBER   (1,0),
CMPND_INAPR_DIV              NUMBER   (1,0),
DOSE                         NUMBER   (10,5),
PRSPT_NO                     NUMBER   (5,0),
PRSPT_SUB_NO                 NUMBER   (5,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
