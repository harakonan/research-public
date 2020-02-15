CREATE TABLE TNDS_T_RCP_PHA_TO
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
BURD_DIV                     VARCHAR2 (1),
SPCFC_DEV_CD                 VARCHAR2 (9),
USE_AMNT                     NUMBER   (8,3),
UNIT_CD                      VARCHAR2 (3),
UNIT_PRICE                   NUMBER   (10,2),
SPCFC_DEV_NAME               NVARCHAR2(20),
PRSPT_NO                     NUMBER   (5,0),
PRSPT_SUB_NO                 NUMBER   (5,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
