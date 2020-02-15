CREATE TABLE TNDS_T_THOKEN_FACE
(
SEQ1_NO                      VARCHAR2 (46) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (14) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
IDENT_CD                     VARCHAR2 (3),
CNSLT_TCKT_FACE_CLS          VARCHAR2 (1),
CNSLT_TCKT_RFRNC_NO          VARCHAR2 (11),
HGE_NENDO                    VARCHAR2 (4),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
