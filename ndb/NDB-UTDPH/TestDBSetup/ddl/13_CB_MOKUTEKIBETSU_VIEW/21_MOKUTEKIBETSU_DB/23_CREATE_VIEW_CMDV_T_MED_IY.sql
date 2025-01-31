CREATE VIEW CMDV_T_MED_IY AS
  SELECT /*+ USE_HASH_AGGREGATION */
    IY.SEQ2_NO
  , IY.SERL_NO
  , IY.AFT_SPLMT_PRAC_IDENT
  , SUM(IY.SCORE)             AS SCORE
  , SUM(IY.AFT_SPLMT_SCORE)   AS AFT_SPLMT_SCORE
  , SUM(IY.TIMES)             AS TIMES
  , SUM(IY.AFT_SPLMT_TIMES)   AS AFT_SPLMT_TIMES
  , SUM(IY.DAYS01_INFO)       AS DAYS01_INFO
  , SUM(IY.DAYS02_INFO)       AS DAYS02_INFO
  , SUM(IY.DAYS03_INFO)       AS DAYS03_INFO
  , SUM(IY.DAYS04_INFO)       AS DAYS04_INFO
  , SUM(IY.DAYS05_INFO)       AS DAYS05_INFO
  , SUM(IY.DAYS06_INFO)       AS DAYS06_INFO
  , SUM(IY.DAYS07_INFO)       AS DAYS07_INFO
  , SUM(IY.DAYS08_INFO)       AS DAYS08_INFO
  , SUM(IY.DAYS09_INFO)       AS DAYS09_INFO
  , SUM(IY.DAYS10_INFO)       AS DAYS10_INFO
  , SUM(IY.DAYS11_INFO)       AS DAYS11_INFO
  , SUM(IY.DAYS12_INFO)       AS DAYS12_INFO
  , SUM(IY.DAYS13_INFO)       AS DAYS13_INFO
  , SUM(IY.DAYS14_INFO)       AS DAYS14_INFO
  , SUM(IY.DAYS15_INFO)       AS DAYS15_INFO
  , SUM(IY.DAYS16_INFO)       AS DAYS16_INFO
  , SUM(IY.DAYS17_INFO)       AS DAYS17_INFO
  , SUM(IY.DAYS18_INFO)       AS DAYS18_INFO
  , SUM(IY.DAYS19_INFO)       AS DAYS19_INFO
  , SUM(IY.DAYS20_INFO)       AS DAYS20_INFO
  , SUM(IY.DAYS21_INFO)       AS DAYS21_INFO
  , SUM(IY.DAYS22_INFO)       AS DAYS22_INFO
  , SUM(IY.DAYS23_INFO)       AS DAYS23_INFO
  , SUM(IY.DAYS24_INFO)       AS DAYS24_INFO
  , SUM(IY.DAYS25_INFO)       AS DAYS25_INFO
  , SUM(IY.DAYS26_INFO)       AS DAYS26_INFO
  , SUM(IY.DAYS27_INFO)       AS DAYS27_INFO
  , SUM(IY.DAYS28_INFO)       AS DAYS28_INFO
  , SUM(IY.DAYS29_INFO)       AS DAYS29_INFO
  , SUM(IY.DAYS30_INFO)       AS DAYS30_INFO
  , SUM(IY.DAYS31_INFO)       AS DAYS31_INFO
  , IY.PRAC_YM                AS PRAC_YM
  FROM
    TNDS_T_RCP_MED_IY IY
  WHERE
    IY.KO_FLG IN (0,2)
  GROUP BY
    IY.SEQ2_NO
  , IY.SERL_NO
  , IY.AFT_SPLMT_PRAC_IDENT
  , IY.PRAC_YM
WITH READ ONLY
;
