CREATE TABLE TNDS_T_RCP_PHA_ST
(
SEQ1_NO                      VARCHAR2 (10) NOT NULL ENABLE,
SEQ2_NO                      VARCHAR2 (51) NOT NULL ENABLE,
VLD_FLG                      NUMBER   (1,0),
KO_FLG                       NUMBER   (1,0),
REC_IDENT_INFO               VARCHAR2 (2),
PRSPT_YMD                    VARCHAR2 (7),
DSPNG_YMD                    VARCHAR2 (7),
PRSPT_RCPTN_TIME             NUMBER   (2,0),
DIV_NUM_TIME_DIRECTIONS      NUMBER   (2,0),
DIV_HO_TARGET_SCORE          NUMBER   (7,0),
SCORE_AFTER_DIV_HO           NUMBER   (7,0),
DIV01_TARGET_SCORE           NUMBER   (7,0),
SCORE_AFTER_DIV01            NUMBER   (7,0),
DIV02_TARGET_SCORE           NUMBER   (7,0),
SCORE_AFTER_DIV02            NUMBER   (7,0),
DIV03_TARGET_SCORE           NUMBER   (7,0),
SCORE_AFTER_DIV03            NUMBER   (7,0),
DIV04_TARGET_SCORE           NUMBER   (7,0),
SCORE_AFTER_DIV04            NUMBER   (7,0),
PRAC_YM                      VARCHAR2 (5),
INPUT_YM                     VARCHAR2 (6)
)
TABLESPACE NDB_USERS1
NOLOGGING
PARALLEL 30
;
