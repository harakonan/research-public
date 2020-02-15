CREATE TABLE TNDS_T_RCP_PHA_SH
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
NO                           VARCHAR2 (2),
DSG_FRM_CD                   VARCHAR2 (1),
DRCTN_USE_CD                 VARCHAR2 (3),
SPCL_ISRCN                   NVARCHAR2(40),
TOTAL                        NUMBER   (7,0),
PUB_MONEY01                  NUMBER   (7,0),
PUB_MONEY02                  NUMBER   (7,0),
PUB_MONEY03                  NUMBER   (7,0),
PUB_MONEY04                  NUMBER   (7,0),
PRSPT_NO                     NUMBER   (5,0),
PRSPT_SUB_NO                 NUMBER   (5,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
