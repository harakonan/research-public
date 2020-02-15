CREATE TABLE TNDS_M_NAME_TOKKEN_THOKEN
(
INDEX_NO                     VARCHAR2 (6),
CNDTN                        NVARCHAR2(2),
ITEM_CD                      VARCHAR2 (17) NOT NULL ENABLE,
ITEM_NAME                    NVARCHAR2(50),
VAL_DATA                     NUMBER   (10,3) NOT NULL ENABLE,
VAL_DATA_NAME                NVARCHAR2(20),
LWR_VAL                      NUMBER   (10,3),
UPR_VAL                      NUMBER   (10,3),
DATA_TYPE                    NVARCHAR2(6),
UNIT                         NVARCHAR2(6),
OUT_OF_STNDRD_RNG            NVARCHAR2(2),
CARRY_OUT_EXAM               NVARCHAR2(3),
EXAM_MTHD                    NVARCHAR2(40),
RESERVE_01                   NVARCHAR2(100),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
CLEANING_TYPE                NUMBER   (1,0),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_NAME_TOKKEN_THOKEN_PK PRIMARY KEY (ITEM_CD,VAL_DATA,MST_GEN) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
