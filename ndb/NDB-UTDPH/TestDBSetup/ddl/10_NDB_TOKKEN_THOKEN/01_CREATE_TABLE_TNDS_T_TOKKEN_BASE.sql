CREATE TABLE TNDS_T_TOKKEN_BASE
(
SEQ1_NO                      VARCHAR2 (46) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (14),
VLD_FLG                      NUMBER   (1,0),
IDENT_CD                     VARCHAR2 (3),
ID1                          VARCHAR2 (64),
ID1N                         VARCHAR2 (64),
ID2                          VARCHAR2 (64),
AGE                          NUMBER   (3,0),
TESTEE_POST_NO               VARCHAR2 (8),
TESTEE_SEX_CD                VARCHAR2 (1),
TESTEE_BIRTH_YM              VARCHAR2 (8),
CNSLT_TCKT_FACE_CLS          VARCHAR2 (1),
CNSLT_TCKT_RFRNC_NO          VARCHAR2 (11),
MEE_PRG_CLS                  VARCHAR2 (3),
MEE_YMD                      VARCHAR2 (8),
MEE_INST_NO_ORG              VARCHAR2 (10),
MEE_INST_NO                  VARCHAR2 (10),
INSURER_NO_ORG               VARCHAR2 (8),
INSURER_NO_AFT               VARCHAR2 (8),
INSURER_NO                   VARCHAR2 (8),
RPT_DIV                      VARCHAR2 (2),
QLFCT_DIV                    VARCHAR2 (1),
INPUT_YM                     VARCHAR2 (6),
AGE_HIER_CD1                 VARCHAR2 (3),
AGE_HIER_CD2                 VARCHAR2 (3),
LAST_BIRTH_AGE               NUMBER   (3,0),
LAST_BIRTH_AGE_HIER_CD1      VARCHAR2 (3),
LAST_BIRTH_AGE_HIER_CD2      VARCHAR2 (3),
MEE_NENDO                    VARCHAR2 (4),
    CONSTRAINT TNDS_T_TOKKEN_BASE_PK PRIMARY KEY (SEQ1_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
ALTER INDEX TNDS_T_TOKKEN_BASE_PK INVISIBLE;
