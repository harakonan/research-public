CREATE TABLE TNDS_M_MDDF
(
CHG_DIV                      VARCHAR2 (1),
MST_CLS                      VARCHAR2 (1),
MODIF_CD                     VARCHAR2 (4) NOT NULL ENABLE,
RESERVE_01                   NUMBER   (1,0),
RESERVE_02                   NUMBER   (3,0),
MODIF_NAME_DIG               NUMBER   (2,0),
MODIF_NAME                   NVARCHAR2(20),
RESERVE_03                   VARCHAR2 (24),
MODIF_NAME_KANA_DIG          NUMBER   (2,0),
MODIF_NAME_KANA              NVARCHAR2(30),
RESERVE_04                   VARCHAR2 (1),
CI_MODIF_NAME                VARCHAR2 (1),
CI_MODIF_NAME_KANA           VARCHAR2 (1),
LST_YMD                      VARCHAR2 (8),
CHG_YMD                      VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
MODIF_MNG_NO                 VARCHAR2 (8),
MODIF_EXCHG_CD               VARCHAR2 (9),
MODIF_DIV                    VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_MDDF_PK PRIMARY KEY (MST_GEN,MODIF_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
