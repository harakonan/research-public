CREATE TABLE TNDS_T_RCP_DEN_CO
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_IDENT                   VARCHAR2 (2),
BURD_DIV                     VARCHAR2 (1),
CMT_CD                       VARCHAR2 (9),
CHAR_DAT                     NVARCHAR2(200),
CMT_DF                       VARCHAR2 (384),
RESERVE_01                   VARCHAR2 (1),
RESERVE_02                   VARCHAR2 (2),
RESERVE_03                   VARCHAR2 (3),
RESERVE_04                   VARCHAR2 (7),
RESERVE_05                   VARCHAR2 (7),
AFT_SPLMT_PRAC_IDENT         VARCHAR2 (2),
SERL_NO                      NUMBER   (5,0),
SERS_ODR                     NUMBER   (5,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
