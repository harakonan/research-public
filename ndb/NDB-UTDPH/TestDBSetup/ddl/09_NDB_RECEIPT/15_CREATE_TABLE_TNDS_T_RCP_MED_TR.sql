CREATE TABLE TNDS_T_RCP_MED_TR
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
RCP_NO                       NUMBER   (6,0),
DONOR_RCPT_CLS               VARCHAR2 (4),
PRAC_YM_TR                   VARCHAR2 (5),
ID3                          VARCHAR2 (64),
SEX_DIV                      VARCHAR2 (1),
BIRTH_YM                     VARCHAR2 (5),
NAME                         VARCHAR2 (3),
HOSTZ_YMD                    VARCHAR2 (7),
WARD_DIV                     VARCHAR2 (8),
RESERVE_01                   NUMBER   (1,0),
RCPT_IMPTT_NOTI              VARCHAR2 (10),
RESERVE_02                   NUMBER   (4,0),
DISCNT_SCR_UNIT_PRICE        NUMBER   (2,0),
RESERVE_03                   VARCHAR2 (1),
RESERVE_04                   VARCHAR2 (1),
RESERVE_05                   VARCHAR2 (2),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
