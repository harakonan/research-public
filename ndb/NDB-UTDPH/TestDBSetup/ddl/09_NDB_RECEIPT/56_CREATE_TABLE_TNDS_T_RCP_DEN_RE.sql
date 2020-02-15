CREATE TABLE TNDS_T_RCP_DEN_RE
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
HOSTZ_YMD                    VARCHAR2 (7),
CNSLT_STR_YMD                VARCHAR2 (7),
OUTCM_DIV                    VARCHAR2 (1),
WARD_DIV                     VARCHAR2 (8),
STAND_BURD_DIV               VARCHAR2 (1),
RCPT_IMPTT_NOTI              VARCHAR2 (10),
RESERVE_01                   VARCHAR2 (4),
REQ_INFO1                    VARCHAR2 (2),
RESERVE_02                   VARCHAR2 (2),
NON_HSPTL_VISIT_REQ          VARCHAR2 (2),
SRCH_NO                      VARCHAR2 (30),
REC_CNDTN_YM_NO              VARCHAR2 (5),
REQ_INFO2                    NVARCHAR2(40),
RESERVE_03                   VARCHAR2 (2),
RESERVE_04                   VARCHAR2 (3),
RESERVE_05                   VARCHAR2 (3),
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
