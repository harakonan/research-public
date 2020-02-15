CREATE TABLE TNDS_M_POST_NO
(
ALL_LOC_GOV_CD               VARCHAR2 (5),
POST_NO_OLD                  VARCHAR2 (5),
POST_NO_ORG                  VARCHAR2 (7) NOT NULL ENABLE,
TDFK_KANA                    NVARCHAR2(76),
CKTS_KANA                    NVARCHAR2(76),
TYIK_KANA                    NVARCHAR2(76),
TDFK_KANJ                    NVARCHAR2(38),
CKTS_KANJ                    NVARCHAR2(38),
TYIK_KANJ                    NVARCHAR2(38),
TYIK_ONE_TYIK_DSP            VARCHAR2 (1),
TYIK_BANTI_ISSUE_DSP         VARCHAR2 (1),
TYIK_INCLD_CHOME_DSP         VARCHAR2 (1),
TYIK_ONE_POST_NO_DSP         VARCHAR2 (1),
UPD_DSP                      VARCHAR2 (1),
REASON_CHG                   VARCHAR2 (1),
POST_NO                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
OVERLAP_FLG                  NUMBER   (3,0) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_POST_NO_PK PRIMARY KEY (POST_NO_ORG,MST_GEN,OVERLAP_FLG) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
