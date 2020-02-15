CREATE TABLE TNDS_T_TOKKEN_EXAM
(
SEQ1_NO                      VARCHAR2 (46) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (14) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
IDENT_CD                     VARCHAR2 (3),
CD                           VARCHAR2 (17),
VAL_ORG                      NUMBER   (10,3),
VAL                          NUMBER   (10,3),
UNIT                         NVARCHAR2(10),
SVL_LWR                      NUMBER   (10,3),
SVL_LWR_UNIT                 NVARCHAR2(10),
SVL_UPR                      NUMBER   (10,3),
SVL_UPR_UNIT                 NVARCHAR2(10),
VALUE_CD_ORG                 VARCHAR2 (1),
VALUE_CD                     VARCHAR2 (1),
DOCTOR_NAME                  VARCHAR2 (1),
VAL_FREE                     VARCHAR2 (1),
NUL_FLV_VAL                  VARCHAR2 (2),
EINE_DIV                     VARCHAR2 (5),
MVSL_DIV                     VARCHAR2 (1),
MEE_NENDO                    VARCHAR2 (4),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
