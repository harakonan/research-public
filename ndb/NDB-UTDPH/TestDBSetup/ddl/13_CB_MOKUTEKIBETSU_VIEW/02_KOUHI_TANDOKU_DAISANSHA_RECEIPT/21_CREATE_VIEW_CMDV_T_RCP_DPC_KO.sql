CREATE VIEW CMDV_T_RCP_DPC_KO AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  DEFRAYER_NO
 ,  EX_GRATIA_PAY_DIV
 ,  PRAC_TRUE_DAYS
 ,  TOTAL_SCORE
 ,  PUB_MONEY
 ,  RESERVE_01
 ,  PUB_MONEY_PAY_HOSTZ_BURD
 ,  RESERVE_02
 ,  TIMES
 ,  TOTAL_PRICE
 ,  STAND_BURD_PRICE
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_DPC_KO
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
