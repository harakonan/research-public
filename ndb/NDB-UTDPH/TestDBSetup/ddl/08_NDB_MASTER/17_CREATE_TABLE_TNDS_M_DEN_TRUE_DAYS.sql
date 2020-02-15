CREATE TABLE TNDS_M_DEN_TRUE_DAYS
(
CHG_DIV                      VARCHAR2 (1),
PRAC_ACT_CD                  VARCHAR2 (9) NOT NULL ENABLE,
NOTIF_NO_DIV                 VARCHAR2 (1),
NOTIF_NO_DIV_NO              VARCHAR2 (3),
NOTIF_NO_BRNC_NO             VARCHAR2 (2),
NOTIF_NO_ITEM_NO             VARCHAR2 (2),
ADD_CD                       VARCHAR2 (5),
PAN_STD_NAME                 NVARCHAR2(100),
PAN_RYK_NAME                 NVARCHAR2(32),
TRUE_DAYS                    VARCHAR2 (1),
DAYS_TIMES                   VARCHAR2 (1),
CHG_YMD                      VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
RESERVE_01                   NUMBER   (3,0),
INPUT_YMD                    NUMBER   (8,0),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_DEN_TRUE_DAYS_PK PRIMARY KEY (MST_GEN,PRAC_ACT_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
