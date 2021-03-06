CREATE VIEW CMDV_T_RCP_DPC_GT AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  PRAC_YM_GT
 ,  REQ_ADJST_DIV
 ,  SELF_OTHER_INSU_DIV
 ,  BURD_DIV
 ,  INCSN_SBTTL_SCORE_SUM
 ,  INCSN_EVALU_SCORE
 ,  ADJST_SCORE
 ,  THIS_INCSN_TTL_SCORE
 ,  PRAC_IDENT
 ,  CHANGE_YMD
 ,  CHAR_DAT
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_DPC_GT
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
