CREATE VIEW CMDV_T_RCP_DEN_KH AS
  SELECT
    SEQ1_NO
 ,  SEQ2_NO
 ,  VLD_FLG
 ,  REC_IDENT_INFO
 ,  NHIO_PROP_INFO
  FROM
    TNDS_T_RCP_DEN_KH
  WHERE
    KO_FLG IN (0,2)
WITH READ ONLY
;
