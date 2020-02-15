/*------------ 調剤個人別医療費ビュー ------------*/
CREATE VIEW CMDV_T_PHA_KOJIN_IRYOHI AS
  SELECT /*+ USE_HASH_AGGREGATION */
     RE.ID1N               AS ID1N                -- 01.ID1n
     , MN.PRAC_YM          AS PRAC_YM             -- 02.調剤年月
     , SUBSTR(M_JC.SEIREKI,5,2)  AS PRAC_M        -- 03.調剤月
     , CASE
         WHEN M_JC.SEIREKI IS NOT NULL THEN
             CASE
               WHEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) >= 1 AND TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) <= 3  THEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,1,4) - 1)
               WHEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) >= 4 AND TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) <= 12 THEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,1,4))
               ELSE NULL
             END
         ELSE NULL
       END                     AS PRAC_NENDO          -- 04.調剤年度
   , RE.SEX_DIV                AS SEX_DIV             -- 05.男女区分
   , M_SEX.SEX_DIV_NAME        AS SEX_DIV_NAME        -- 06.男女区分名称
   , MAX(HO.INSURER_NO)        AS INSURER_NO          -- 07.保険者番号（匿名化後）
   , SUM(HO.TOTAL_SCORE)       AS TOTAL_SCORE         -- 08.医療費（月合計）・点数
  FROM
  /* 調剤(MN) */
  TNDS_T_RCP_PHA_MN MN
  /* 調剤(RE) */
  INNER JOIN TNDS_T_RCP_PHA_RE RE
                  ON  (  MN.PRAC_YM = RE.PRAC_YM
                     AND MN.SEQ2_NO = RE.SEQ2_NO )
  /* 調剤(HO) */
  LEFT OUTER JOIN TNDS_T_RCP_PHA_HO HO
                  ON  ( MN.SEQ2_NO
                      = HO.SEQ2_NO
                  AND   MN.PRAC_YM
                      = HO.PRAC_YM )
  LEFT OUTER JOIN TNDS_T_TRANS_JC_YEAR M_JC      -- 和暦西暦変換テーブル
                  ON  ( MN.PRAC_YM
                      = M_JC.WAREKI )
  LEFT OUTER JOIN CMDS_M_SEX_DIV M_SEX           -- 男女区分マスター
                  ON  ( RE.SEX_DIV
                      = M_SEX.SEX_DIV )
  WHERE
    MN.KO_FLG IN (0,2)
  GROUP BY
     RE.ID1N
   , MN.PRAC_YM
   , M_JC.SEIREKI
   , M_SEX.SEX_DIV_NAME
   , RE.SEX_DIV
   , HO.INSURER_NO_AFT
WITH READ ONLY
;
