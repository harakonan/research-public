CREATE TABLE TNDS_T_RCP_PHA_RE
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
AGE                          NUMBER   (3,0),
ID1                          VARCHAR2 (64),
ID1N                         VARCHAR2 (64),
ID2                          VARCHAR2 (64),
RCP_NO                       NUMBER   (6,0),
RCP_CLS                      VARCHAR2 (4),
PRAC_YM                      VARCHAR2 (5),
SEX_DIV                      VARCHAR2 (1),
BIRTH_YM                     VARCHAR2 (5),
PAY_RAT                      NUMBER   (3,0),
RCPT_IMPTT_NOTI              VARCHAR2 (10),
TDFK                         VARCHAR2 (2),
SCORE_LIST                   VARCHAR2 (1),
MEDI_INST_ORG                VARCHAR2 (7),
MEDI_INST                    VARCHAR2 (7),
RESERVE_01                   VARCHAR2 (1),
SRCH_NO                      VARCHAR2 (30),
REC_CNDTN_SPEC_YM_INFO       VARCHAR2 (5),
REQ_INFO                     NVARCHAR2(40),
PART_BURD_DIV                VARCHAR2 (1),
INPUT_YM                     VARCHAR2 (6),
AGE_HIER_CD1                 VARCHAR2 (3),
AGE_HIER_CD2                 VARCHAR2 (3),
LAST_BIRTH_AGE               NUMBER   (3,0),
LAST_BIRTH_AGE_HIER_CD1      VARCHAR2 (3),
LAST_BIRTH_AGE_HIER_CD2      VARCHAR2 (3)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
