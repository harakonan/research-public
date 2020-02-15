CREATE TABLE TNDS_T_THOKEN_RESULT
(
SEQ1_NO                      VARCHAR2 (46) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (14) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
IDENT_CD                     VARCHAR2 (3),
CD                           VARCHAR2 (10),
CNTNT_ORG                    VARCHAR2 (1),
CNTNT                        VARCHAR2 (1),
OPRTN_YMD                    VARCHAR2 (8),
TIME_VAL                     NUMBER   (5,0),
TIME_UNIT                    NVARCHAR2(10),
VAL                          NUMBER   (10,3),
UNIT                         NVARCHAR2(10),
VALUE                        NVARCHAR2(128),
HGE_NENDO                    VARCHAR2 (4),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
