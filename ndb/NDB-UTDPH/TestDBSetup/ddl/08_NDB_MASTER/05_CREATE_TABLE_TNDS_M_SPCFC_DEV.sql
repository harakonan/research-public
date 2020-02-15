CREATE TABLE TNDS_M_SPCFC_DEV
(
CHG_DIV                      VARCHAR2 (1),
MST_CLS                      VARCHAR2 (1),
SPCFC_DEV_CD                 VARCHAR2 (9) NOT NULL ENABLE,
SDSN_KANJ_VLD_DIG            NUMBER   (2,0),
SDSN_KANJ                    NVARCHAR2(32),
SDSN_KANA_VLD_DIG            NUMBER   (2,0),
SDSN_KANA                    NVARCHAR2(20),
UNIT_CD                      VARCHAR2 (3),
UNIT_KANJ_VLD_DIG            VARCHAR2 (1),
UNIT_KANJ                    NVARCHAR2(6),
NNP_PRICE_CLS                VARCHAR2 (1),
NNP_PRICE                    NUMBER   (12,2),
NAME_USE_IDENT               VARCHAR2 (1),
AGE_ADD_DIV                  VARCHAR2 (1),
LMT_AGE_LWR                  VARCHAR2 (2),
LMT_AGE_UPR                  VARCHAR2 (2),
OP_PRICE_CLS                 VARCHAR2 (1),
OP_PRICE                     NUMBER   (12,2),
KANJ_CHG_DIV                 VARCHAR2 (1),
KANA_CHG_DIV                 VARCHAR2 (1),
OXY_DIV                      VARCHAR2 (1),
SPCFC_DEV01_CLS              VARCHAR2 (1),
UPR_LMT_PRICE                VARCHAR2 (1),
UPR_LMT_SCORE                NUMBER   (7,0),
RESERVE_01                   VARCHAR2 (85),
PBLCT_ODR_NO                 VARCHAR2 (9),
ABO_NEW_ASCT                 VARCHAR2 (9),
CHG_YMD                      VARCHAR2 (8),
EXPIR_YMD                    VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
NTFY_NO_APP_NO               VARCHAR2 (2),
NTFY_NO_DIV_NO               VARCHAR2 (3),
DPC_APPL_DIV                 VARCHAR2 (1),
RESERVE_02                   VARCHAR2 (10),
RESERVE_03                   VARCHAR2 (10),
RESERVE_04                   VARCHAR2 (10),
BASE_KANJ_NAME               NVARCHAR2(150),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_SPCFC_DEV_PK PRIMARY KEY (MST_GEN,SPCFC_DEV_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
