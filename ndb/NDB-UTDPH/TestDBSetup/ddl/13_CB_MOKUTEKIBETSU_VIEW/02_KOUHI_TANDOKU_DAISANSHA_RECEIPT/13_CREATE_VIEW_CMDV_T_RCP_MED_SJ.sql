CREATE VIEW CMDV_T_RCP_MED_SJ AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  SYMP_MINU_DSCPT_DIV
 ,  SYMP_MINU_DSCPT_DAT
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_MED_SJ
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
