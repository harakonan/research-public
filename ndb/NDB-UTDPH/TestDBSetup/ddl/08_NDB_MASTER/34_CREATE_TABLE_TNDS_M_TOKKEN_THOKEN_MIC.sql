CREATE TABLE TNDS_M_TOKKEN_THOKEN_MIC
(
PRCS_YM_Y                    VARCHAR2 (4),
PRCS_YM_M                    VARCHAR2 (2),
CRCT_DIV                     VARCHAR2 (1),
SMEC_TDFK_NO                 VARCHAR2 (2) NOT NULL ENABLE,
DIV_NO                       VARCHAR2 (1) NOT NULL ENABLE,
MIDI_TSC_CD                  VARCHAR2 (2) NOT NULL ENABLE,
MIDI_INST_CD                 VARCHAR2 (4) NOT NULL ENABLE,
VFCT_NO                      VARCHAR2 (1) NOT NULL ENABLE,
INST_CLS                     VARCHAR2 (1),
ADDR_POST_NO                 VARCHAR2 (8),
ADDR                         NVARCHAR2(40),
HP_ADDR                      VARCHAR2 (80),
MNG_AGCY                     VARCHAR2 (2),
INPUT_YMD                    VARCHAR2 (8),
APPL_YM                      VARCHAR2 (6),
MST_GEN                      VARCHAR2 (9) NOT NULL ENABLE,
    CONSTRAINT TNDS_M_TOKKEN_THOKEN_MIC_PK PRIMARY KEY (MST_GEN,SMEC_TDFK_NO,DIV_NO,MIDI_TSC_CD,MIDI_INST_CD,VFCT_NO) USING INDEX
        TABLESPACE NDB_USERS1
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
