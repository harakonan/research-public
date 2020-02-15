CREATE TABLE TNDS_M_DEN_NAI
(
CHG_DIV                      VARCHAR2 (1),
GRP_NO                       VARCHAR2 (4) NOT NULL ENABLE,
NAI_ADD_CD                   VARCHAR2 (5) NOT NULL ENABLE,
NAI_PRAC_ACT_CD              VARCHAR2 (9),
NAI_PRAC_ACT_NAME            NVARCHAR2(100),
NAI_ADD_IDENT                VARCHAR2 (2),
CHG_YMD                      VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
RESERVE_01                   NUMBER   (3,0),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_DEN_NAI_PK PRIMARY KEY (MST_GEN,GRP_NO,NAI_ADD_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
