CREATE VIEW CMDV_T_RCP_DEN_SS AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  PRAC_IDENT
 ,  BURD_DIV
 ,  PRAC_ACT_CD
 ,  PRAC_ACT_AMNT1_DAT
 ,  PRAC_ACT_AMNT2_DAT
 ,  ADD01_CD
 ,  ADD01_AMNT_DAT
 ,  ADD02_CD
 ,  ADD02_AMNT_DAT
 ,  ADD03_CD
 ,  ADD03_AMNT_DAT
 ,  ADD04_CD
 ,  ADD04_AMNT_DAT
 ,  ADD05_CD
 ,  ADD05_AMNT_DAT
 ,  ADD06_CD
 ,  ADD06_AMNT_DAT
 ,  ADD07_CD
 ,  ADD07_AMNT_DAT
 ,  ADD08_CD
 ,  ADD08_AMNT_DAT
 ,  ADD09_CD
 ,  ADD09_AMNT_DAT
 ,  ADD10_CD
 ,  ADD10_AMNT_DAT
 ,  ADD11_CD
 ,  ADD11_AMNT_DAT
 ,  ADD12_CD
 ,  ADD12_AMNT_DAT
 ,  ADD13_CD
 ,  ADD13_AMNT_DAT
 ,  ADD14_CD
 ,  ADD14_AMNT_DAT
 ,  ADD15_CD
 ,  ADD15_AMNT_DAT
 ,  ADD16_CD
 ,  ADD16_AMNT_DAT
 ,  ADD17_CD
 ,  ADD17_AMNT_DAT
 ,  ADD18_CD
 ,  ADD18_AMNT_DAT
 ,  ADD19_CD
 ,  ADD19_AMNT_DAT
 ,  ADD20_CD
 ,  ADD20_AMNT_DAT
 ,  ADD21_CD
 ,  ADD21_AMNT_DAT
 ,  ADD22_CD
 ,  ADD22_AMNT_DAT
 ,  ADD23_CD
 ,  ADD23_AMNT_DAT
 ,  ADD24_CD
 ,  ADD24_AMNT_DAT
 ,  ADD25_CD
 ,  ADD25_AMNT_DAT
 ,  ADD26_CD
 ,  ADD26_AMNT_DAT
 ,  ADD27_CD
 ,  ADD27_AMNT_DAT
 ,  ADD28_CD
 ,  ADD28_AMNT_DAT
 ,  ADD29_CD
 ,  ADD29_AMNT_DAT
 ,  ADD30_CD
 ,  ADD30_AMNT_DAT
 ,  ADD31_CD
 ,  ADD31_AMNT_DAT
 ,  ADD32_CD
 ,  ADD32_AMNT_DAT
 ,  ADD33_CD
 ,  ADD33_AMNT_DAT
 ,  ADD34_CD
 ,  ADD34_AMNT_DAT
 ,  ADD35_CD
 ,  ADD35_AMNT_DAT
 ,  SCORE
 ,  TIMES
 ,  DAYS01_INFO
 ,  DAYS02_INFO
 ,  DAYS03_INFO
 ,  DAYS04_INFO
 ,  DAYS05_INFO
 ,  DAYS06_INFO
 ,  DAYS07_INFO
 ,  DAYS08_INFO
 ,  DAYS09_INFO
 ,  DAYS10_INFO
 ,  DAYS11_INFO
 ,  DAYS12_INFO
 ,  DAYS13_INFO
 ,  DAYS14_INFO
 ,  DAYS15_INFO
 ,  DAYS16_INFO
 ,  DAYS17_INFO
 ,  DAYS18_INFO
 ,  DAYS19_INFO
 ,  DAYS20_INFO
 ,  DAYS21_INFO
 ,  DAYS22_INFO
 ,  DAYS23_INFO
 ,  DAYS24_INFO
 ,  DAYS25_INFO
 ,  DAYS26_INFO
 ,  DAYS27_INFO
 ,  DAYS28_INFO
 ,  DAYS29_INFO
 ,  DAYS30_INFO
 ,  DAYS31_INFO
 ,  AFT_SPLMT_PRAC_IDENT
 ,  SERL_NO
 ,  SERS_ODR
 ,  AFT_SPLMT_SCORE
 ,  AFT_SPLMT_SCORE_ERR
 ,  AFT_SPLMT_TIMES
 ,  AFT_SPLMT_TIMES_ERR
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_DEN_SS
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
