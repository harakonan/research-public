CREATE TABLE TNDS_T_MSTLINK
(
APPL_YM                      VARCHAR2 (6) NOT NULL ENABLE,
APPL_YM_W                    VARCHAR2 (5) NOT NULL ENABLE,
SKWD_MST_GEN                 VARCHAR2 (9),
MDDF_MST_GEN                 VARCHAR2 (9),
DF_MST_GEN                   VARCHAR2 (9),
MEDICINE_MST_GEN             VARCHAR2 (9),
SPCFC_DEV_MST_GEN            VARCHAR2 (9),
CMT_MST_GEN                  VARCHAR2 (9),
PRAC_ACT_MST_GEN             VARCHAR2 (9),
DEN_BASE_MST_GEN             VARCHAR2 (9),
DEN_ORAI_MST_GEN             VARCHAR2 (9),
DEN_BAI_MST_GEN              VARCHAR2 (9),
DEN_NAI_MST_GEN              VARCHAR2 (9),
DEN_MTRL_MST_GEN             VARCHAR2 (9),
DEN_CALC_MST_GEN             VARCHAR2 (9),
DEN_NOTC_MST_GEN             VARCHAR2 (9),
DEN_AGE_MST_GEN              VARCHAR2 (9),
DEN_RBL_MST_GEN              VARCHAR2 (9),
DEN_TRUE_DAYS_MST_GEN        VARCHAR2 (9),
DSPNG_ACT_MST_GEN            VARCHAR2 (9),
MDC_GEN                      VARCHAR2 (9),
CLS_GEN                      VARCHAR2 (9),
HOSTZ_GEN                    VARCHAR2 (9),
ICD_GEN                      VARCHAR2 (9),
AGE_BIRTH_WT_GEN             VARCHAR2 (9),
SURG_GEN                     VARCHAR2 (9),
TREAT1_GEN                   VARCHAR2 (9),
TREAT2_GEN                   VARCHAR2 (9),
SCND_SKWD_NAME_GEN           VARCHAR2 (9),
SVRTY_JCS_GEN                VARCHAR2 (9),
SVRTY_SURG_GEN               VARCHAR2 (9),
DGC_GEN                      VARCHAR2 (9),
TRNS_GEN                     VARCHAR2 (9),
SURG_CD_GEN                  VARCHAR2 (9),
TOKKEN_ITEM_MST_GEN          VARCHAR2 (9),
THOKEN_ITEM_MST_GEN          VARCHAR2 (9),
TOKKEN_THOKEN_MIC_MST_GEN    VARCHAR2 (9),
SPT_AMO_INS_EACH_OO_GEN      VARCHAR2 (9),
INSURER_NO_MST_GEN           VARCHAR2 (9),
MIC_MST_GEN                  VARCHAR2 (9),
POST_NO_MST_GEN              VARCHAR2 (9),
SCND_MEDI_AREA_MST_GEN       VARCHAR2 (9),
POP_PER_TDFK_GEN             VARCHAR2 (9),
POP_PER_SCND_MEDI_AREA_GEN   VARCHAR2 (9),
NAME_TOKKEN_THOKEN_MST_GEN   VARCHAR2 (9),
POP_CKTS_AGE_GEN             VARCHAR2 (9),
MIC_MST_FLG                  NUMBER   (1,0),
POP_PER_SCND_MEDI_AREA_FLG   NUMBER   (1,0),
    CONSTRAINT TNDS_T_MSTLINK_PK PRIMARY KEY (APPL_YM) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 96
;
