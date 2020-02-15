CREATE TABLE TNDS_T_RCP_DPC_KK
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
CHG_DEPT_YON                 VARCHAR2 (1),
EXCPT_PUB_WARD_MOVE_YON      VARCHAR2 (1),
PLAN_EMGCY_HOSTZ_DIV         VARCHAR2 (1),
LAST_DSCHG_YMD               VARCHAR2 (7),
LAST_SAME_SKWD_HOSTZ_YON     VARCHAR2 (1),
HOSTZ_AGE                    NUMBER   (3,0),
BIRTH_WT                     NUMBER   (4,0),
JCS                          VARCHAR2 (3),
RESERVE_01                   VARCHAR2 (1),
BURN_IDX                     NUMBER   (4,1),
SEVERITY                     NVARCHAR2(50),
GAF                          VARCHAR2 (3),
HOSTZ_MONTH_AGE              VARCHAR2 (2),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
