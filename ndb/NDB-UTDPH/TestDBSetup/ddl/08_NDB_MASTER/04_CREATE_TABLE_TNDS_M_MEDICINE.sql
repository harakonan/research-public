CREATE TABLE TNDS_M_MEDICINE
(
CHG_DIV                      VARCHAR2 (1),
MST_CLS                      VARCHAR2 (1),
MEDICINE_CD                  VARCHAR2 (9) NOT NULL ENABLE,
MSN_KANJ_VLD_DIG             NUMBER   (2,0),
MSN_KANJ                     NVARCHAR2(32),
MSN_KANA_VLD_DIG             NUMBER   (2,0),
MSN_KANA                     NVARCHAR2(20),
UNIT_CD                      VARCHAR2 (3),
UNIT_KANJ_VLD_DIG            NUMBER   (1,0),
UNIT_KANJ                    NVARCHAR2(6),
NNP_PRICE_CLS                VARCHAR2 (1),
NNP_PRICE                    NUMBER   (9,2),
RESERVE_01                   NUMBER   (2,0),
NAR_POI_STI_PSY_DRUG         VARCHAR2 (1),
NEURO_AGENT                  VARCHAR2 (1),
BIOLG_PRPRT                  VARCHAR2 (1),
GENERIC                      VARCHAR2 (1),
RESERVE_02                   VARCHAR2 (1),
DEN_SPCFC_MDCN               VARCHAR2 (1),
CNTRT_MEDIA                  VARCHAR2 (1),
INJECT_CAPA_NUM              NUMBER   (5,0),
LST_MTD_IDENT                VARCHAR2 (1),
TRD_NAME_ASCT                VARCHAR2 (9),
OP_PRICE_CLS                 VARCHAR2 (1),
OP_PRICE                     NUMBER   (9,2),
KANJ_CHG_DIV                 VARCHAR2 (1),
KANA_CHG_DIV                 VARCHAR2 (1),
DSG_FRM                      VARCHAR2 (1),
RESERVE_03                   VARCHAR2 (49),
CHG_YMD                      VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
DRUG_PRICE_STD_CD            VARCHAR2 (12),
PBLCT_ODR_NO                 NUMBER   (9,0),
TRANS_MSRS_EXPIR_YMD         VARCHAR2 (8),
BASE_KANJ_NAME               NVARCHAR2(100),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_MEDICINE_PK PRIMARY KEY (MST_GEN,MEDICINE_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
