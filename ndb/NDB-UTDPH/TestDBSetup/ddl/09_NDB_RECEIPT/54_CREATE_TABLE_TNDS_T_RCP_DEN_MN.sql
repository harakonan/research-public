CREATE TABLE TNDS_T_RCP_DEN_MN
(
SEQ1_NO                      VARCHAR2 (10),
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
RCP_MNG_NO                   VARCHAR2 (16),
INSU_MEDI_INST_ADDR          NVARCHAR2(40),
RESERVE_01                   NUMBER   (30,0),
RESERVE_02                   NUMBER   (1,0),
RESERVE_03                   NUMBER   (1,0),
RESERVE_04                   NVARCHAR2(100),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6),
    CONSTRAINT TNDS_T_RCP_DEN_MN_PK PRIMARY KEY (SEQ2_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
ALTER INDEX TNDS_T_RCP_DEN_MN_PK INVISIBLE;
