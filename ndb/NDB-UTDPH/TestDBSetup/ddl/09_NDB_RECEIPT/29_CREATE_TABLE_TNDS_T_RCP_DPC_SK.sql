CREATE TABLE TNDS_T_RCP_DPC_SK
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_ACT_CD                  VARCHAR2 (9),
DIV_NO                       NVARCHAR2(10),
OPRTN_PLAN_YMD               VARCHAR2 (7),
RESERVE_01                   VARCHAR2 (1),
PRAC_DIV_CD                  VARCHAR2 (4),
PRAC_NAME                    NVARCHAR2(100),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
