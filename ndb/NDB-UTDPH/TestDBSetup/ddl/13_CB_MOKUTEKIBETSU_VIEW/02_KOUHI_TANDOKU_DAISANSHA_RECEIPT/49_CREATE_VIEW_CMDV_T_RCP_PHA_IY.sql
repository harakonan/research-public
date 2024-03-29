CREATE VIEW CMDV_T_RCP_PHA_IY AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  BURD_DIV
 ,  MEDICINE_CD
 ,  USE_AMNT
 ,  RESERVE_01
 ,  RESERVE_02
 ,  MIX_DIV_CD
 ,  MIX_DIV_BRNCH
 ,  CMPND_INAPR_DIV
 ,  DOSE
 ,  PRSPT_NO
 ,  PRSPT_SUB_NO
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_PHA_IY
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
