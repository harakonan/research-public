CREATE TABLE TNDS_M_POP_CKTS_AGE
(
ORGA_CD                      VARCHAR2 (5) NOT NULL ENABLE,
TDFK_NAME                    NVARCHAR2(4),
CKTS_NAME                    NVARCHAR2(15),
SEX                          VARCHAR2 (1) NOT NULL ENABLE,
TTL_NUM                      NUMBER   (10,0),
AGE_0_4                      NUMBER   (8,0),
AGE_5_9                      NUMBER   (8,0),
AGE_10_14                    NUMBER   (8,0),
AGE_15_19                    NUMBER   (8,0),
AGE_20_24                    NUMBER   (8,0),
AGE_25_29                    NUMBER   (8,0),
AGE_30_34                    NUMBER   (8,0),
AGE_35_39                    NUMBER   (8,0),
AGE_40_44                    NUMBER   (8,0),
AGE_45_49                    NUMBER   (8,0),
AGE_50_54                    NUMBER   (8,0),
AGE_55_59                    NUMBER   (8,0),
AGE_60_64                    NUMBER   (8,0),
AGE_65_69                    NUMBER   (8,0),
AGE_70_74                    NUMBER   (8,0),
AGE_75_79                    NUMBER   (8,0),
AGE_80_OVER                  NUMBER   (8,0),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_POP_CKTS_AGE_PK PRIMARY KEY (ORGA_CD,SEX,MST_GEN) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
