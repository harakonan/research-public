CREATE TABLE TNDS_T_RCP_DEN_HS
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRAC_STR_YMD                 VARCHAR2 (7),
OUTCM_DIV                    VARCHAR2 (1),
SKWD_NAME_DF                 VARCHAR2 (384),
SKWD_NAME_CD                 VARCHAR2 (7),
MODIF_CD                     VARCHAR2 (80),
SSPCT_DSS_FLG                NUMBER   (1,0),
SKWD_NAME                    NVARCHAR2(20),
COEX_SKWD_NUM                NUMBER   (1,0),
PATHL_TRANS                  VARCHAR2 (1),
MAIN_SKWD                    VARCHAR2 (2),
CMT_CD                       VARCHAR2 (9),
SPLMT_CMT                    NVARCHAR2(50),
SPLMT_CMT_DF                 VARCHAR2 (384),
MAIN_SKWD_DECIS_FLG          NUMBER   (1,0),
MAIN_SKWD_DECIS_ERR          VARCHAR2 (6),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
