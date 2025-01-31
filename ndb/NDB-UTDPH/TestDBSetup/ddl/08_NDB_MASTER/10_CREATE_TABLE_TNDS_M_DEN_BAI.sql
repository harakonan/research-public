CREATE TABLE TNDS_M_DEN_BAI
(
CHG_DIV                      VARCHAR2 (1),
GRP_NO                       VARCHAR2 (4) NOT NULL ENABLE,
BAI_ADD_CD                   VARCHAR2 (5) NOT NULL ENABLE,
BAI_PRAC_ACT_CD              VARCHAR2 (9),
BAI_PRAC_ACT_NAME            NVARCHAR2(100),
BAI_ADD_IDENT                VARCHAR2 (2),
CHG_YMD                      VARCHAR2 (8),
ABO_YMD                      VARCHAR2 (8),
RESERVE_01                   NUMBER   (3,0),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_DEN_BAI_PK PRIMARY KEY (MST_GEN,GRP_NO,BAI_ADD_CD) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
