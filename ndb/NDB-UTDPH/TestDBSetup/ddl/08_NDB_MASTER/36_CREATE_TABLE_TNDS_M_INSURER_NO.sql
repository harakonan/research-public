CREATE TABLE TNDS_M_INSURER_NO
(
NAME                         NVARCHAR2(127),
NAME_KANA                    NVARCHAR2(127),
NUM_INS_SYS                  VARCHAR2 (3),
TDFK_CD                      VARCHAR2 (2),
INSURER_CD_ORG               VARCHAR2 (8),
INSURED_CD                   NVARCHAR2(1333),
BNFT_RATE_UNION_MEN          VARCHAR2 (1),
BNFT_RATE_FAMILY             VARCHAR2 (1),
POST_NO                      VARCHAR2 (8),
ADDRESS_1                    NVARCHAR2(127),
ADDRESS_2                    NVARCHAR2(127),
TEL_NO                       VARCHAR2 (12),
CHANGE_DAY                   VARCHAR2 (10),
CHANGE_FLG                   VARCHAR2 (1),
RESERVE_01                   NVARCHAR2(127),
INSURER_CD                   VARCHAR2 (8) NOT NULL ENABLE,
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_INSURER_NO_PK PRIMARY KEY (MST_GEN,INSURER_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
