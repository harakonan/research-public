CREATE VIEW CMDV_T_RCP_PHA_SH AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  NO
 ,  DSG_FRM_CD
 ,  DRCTN_USE_CD
 ,  SPCL_ISRCN
 ,  TOTAL
 ,  PUB_MONEY01
 ,  PUB_MONEY02
 ,  PUB_MONEY03
 ,  PUB_MONEY04
 ,  PRSPT_NO
 ,  PRSPT_SUB_NO
 ,  PRAC_YM
 ,  INPUT_YM
  FROM
    TNDS_T_RCP_PHA_SH
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
