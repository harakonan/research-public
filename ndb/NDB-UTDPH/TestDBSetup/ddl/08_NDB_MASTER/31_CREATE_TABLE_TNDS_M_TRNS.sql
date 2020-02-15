CREATE TABLE TNDS_M_TRNS
(
INDEX_NO                     NUMBER   (6,0) NOT NULL ENABLE ,
COMP_SERL_NO                 VARCHAR2 (4),
DGC_NO                       VARCHAR2 (14),
INCL_FLG                     VARCHAR2 (1),
MDC                          VARCHAR2 (2),
MEDI_RSRC_USE_SKWD_NAME      VARCHAR2 (4),
HOSTZ_PPSE                   VARCHAR2 (2),
AGE_BIRTH_WT_AGE             VARCHAR2 (2),
AGE_BIRTH_WT_MON             VARCHAR2 (3),
AGE_BIRTH_WT_WT              VARCHAR2 (4),
AGE_BIRTH_WT_JCS             VARCHAR2 (4),
AGE_BIRTH_WT_BI              VARCHAR2 (3),
AGE_BIRTH_WT_GAF             VARCHAR2 (3),
SURG                         VARCHAR2 (2),
TREAT_ETC1                   VARCHAR2 (3),
TREAT_ETC2                   VARCHAR2 (3),
SCND_SKWD                    VARCHAR2 (3),
SVRTY_JCS                    VARCHAR2 (3),
SVRTY_OSBS                   VARCHAR2 (3),
SVRTY_INIT_REOPE             VARCHAR2 (3),
SVRTY_OEBE                   VARCHAR2 (3),
SVRTY_UBS                    VARCHAR2 (3),
SVRTY_RHBL                   VARCHAR2 (3),
SVRTY_SLGHTLY                VARCHAR2 (1),
CHG_DIV                      VARCHAR2 (1),
VALID_STR_YMD                VARCHAR2 (8),
VALID_END_YMD                VARCHAR2 (8),
UPD_YMD                      VARCHAR2 (8),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_TRNS_PK PRIMARY KEY (MST_GEN,INDEX_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
