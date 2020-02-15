CREATE TABLE TNDS_T_RCP_DEN_KH
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
NHIO_PROP_INFO               NVARCHAR2(100)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
