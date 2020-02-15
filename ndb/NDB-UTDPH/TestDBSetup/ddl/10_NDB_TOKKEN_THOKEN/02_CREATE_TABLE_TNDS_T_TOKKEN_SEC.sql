CREATE TABLE TNDS_T_TOKKEN_SEC
(
SEQ1_NO                      VARCHAR2 (46) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (14) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
IDENT_CD                     VARCHAR2 (3),
SEC_CD                       VARCHAR2 (5),
MEE_NENDO                    VARCHAR2 (4),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
