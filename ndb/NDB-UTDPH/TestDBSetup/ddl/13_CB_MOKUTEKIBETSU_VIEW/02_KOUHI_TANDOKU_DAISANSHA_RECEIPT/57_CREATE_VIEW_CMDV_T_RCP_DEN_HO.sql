CREATE VIEW CMDV_T_RCP_DEN_HO AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  INSURER_NO
 ,  PRAC_TRUE_DAYS
 ,  TOTAL_SCORE
 ,  TIMES
 ,  TOTAL_PRICE
 ,  REASON_DUTY
 ,  MEDI_INSU
 ,  RDCT_TAX_DIV
 ,  RDCT_RAT
 ,  RDCT_PRICE
 ,  SUBSTR(LPAD(INSURER_NO_AFT,8,'0') , 1 , 2) AS HOUBETSU_NO
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_DEN_HO
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;