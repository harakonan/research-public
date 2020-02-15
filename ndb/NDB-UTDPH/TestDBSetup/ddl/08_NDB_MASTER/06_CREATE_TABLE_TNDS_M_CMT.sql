CREATE TABLE TNDS_M_CMT
(
CHG_DIV                      VARCHAR2 (1),
MST_CLS                      VARCHAR2 (1),
CMT_CD_DIV                   VARCHAR2 (1) NOT NULL ENABLE,
CMT_CD_PTRN                  VARCHAR2 (2) NOT NULL ENABLE,
CMT_CD_SERL_NO               VARCHAR2 (6) NOT NULL ENABLE,
CMT_TXT_KANJ_VLD_DIG         NUMBER   (2,0),
CMT_TXT_KANJ                 NVARCHAR2(32),
CMT_TXT_KANA_VLD_DIG         NUMBER   (2,0),
CMT_TXT_KANA                 NVARCHAR2(20),
REI01_COL_POS                NUMBER   (2,0),
REI01_DIG                    NUMBER   (2,0),
REI02_COL_POS                NUMBER   (2,0),
REI02_DIG                    NUMBER   (2,0),
REI03_COL_POS                NUMBER   (2,0),
REI03_DIG                    NUMBER   (2,0),
REI04_COL_POS                NUMBER   (2,0),
REI04_DIG                    NUMBER   (2,0),
KANJ_CHG_DIV                 VARCHAR2 (1),
KANA_CHG_DIV                 VARCHAR2 (1),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_CMT_PK PRIMARY KEY (MST_GEN,CMT_CD_DIV,CMT_CD_PTRN,CMT_CD_SERL_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
