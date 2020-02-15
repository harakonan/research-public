CREATE TABLE TNDS_T_THOKEN_ENTRY
(
SEQ1_NO                      VARCHAR2 (46) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (14) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
IDENT_CD                     VARCHAR2 (3),
FORM_CD_ORG                  VARCHAR2 (1),
FORM_CD                      VARCHAR2 (1),
OPRTN_YMD                    VARCHAR2 (8),
EFRCR_CD                     VARCHAR2 (1),
TRUST_INST_NO                VARCHAR2 (10),
HGE_NENDO                    VARCHAR2 (4),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
