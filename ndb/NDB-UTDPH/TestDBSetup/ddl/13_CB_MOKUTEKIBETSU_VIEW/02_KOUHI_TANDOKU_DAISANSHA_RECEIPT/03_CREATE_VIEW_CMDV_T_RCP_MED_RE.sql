CREATE VIEW CMDV_T_RCP_MED_RE AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  AGE
 ,  ID1
 ,  ID1N
 ,  ID2
 ,  RCP_NO
 ,  RCP_CLS
 ,  PRAC_YM
 ,  SEX_DIV
 ,  BIRTH_YM
 ,  PAY_RAT
 ,  HOSTZ_YMD
 ,  WARD_DIV
 ,  STAND_BURD_DIV
 ,  RCPT_IMPTT_NOTI
 ,  BED_CAPA_NUM
 ,  BED_CAPA_HIER_CODE
 ,  DISCNT_SCR_UNIT_PRICE
 ,  RESERVE_01
 ,  RESERVE_02
 ,  INDI_PRAC_DEPT
 ,  SRCH_NO
 ,  REC_CNDTN_SPEC_YM_INFO
 ,  REQ_INFO
 ,  PRAC1_NAME
 ,  PRAC1_BODY_PART
 ,  PRAC1_SEX
 ,  PRAC1_MEDI_TREAT
 ,  PRAC1_SPCFC_DISE
 ,  PRAC2_NAME
 ,  PRAC2_BODY_PART
 ,  PRAC2_SEX
 ,  PRAC2_MEDI_TREAT
 ,  PRAC2_SPCFC_DISE
 ,  PRAC3_NAME
 ,  PRAC3_BODY_PART
 ,  PRAC3_SEX
 ,  PRAC3_MEDI_TREAT
 ,  PRAC3_SPCFC_DISE
 ,  INPUT_YM
 ,  AGE_HIER_CD1
 ,  AGE_HIER_CD2
 ,  LAST_BIRTH_AGE
 ,  LAST_BIRTH_AGE_HIER_CD1
 ,  LAST_BIRTH_AGE_HIER_CD2
  FROM
    TNDS_T_RCP_MED_RE
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;