CREATE VIEW CMDV_T_THOKEN_ENTRY AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  IDENT_CD
 ,  FORM_CD_ORG
 ,  FORM_CD
 ,  OPRTN_YMD
 ,  EFRCR_CD
 ,  TRUST_INST_NO
 ,  HGE_NENDO
 ,  INPUT_YM
  FROM
    TNDS_T_THOKEN_ENTRY
WITH READ ONLY
;
