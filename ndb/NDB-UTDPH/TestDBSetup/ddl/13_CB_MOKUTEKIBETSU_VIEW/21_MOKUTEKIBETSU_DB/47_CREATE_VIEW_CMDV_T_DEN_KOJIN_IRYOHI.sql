/*------------ 歯科個人別医療費ビュー ------------*/
CREATE VIEW CMDV_T_DEN_KOJIN_IRYOHI AS
  SELECT /*+ USE_HASH_AGGREGATION */
     RE.ID1N               AS ID1N                    -- 01.ID1n
     , MN.PRAC_YM          AS PRAC_YM                 -- 02.診療年月
     , SUBSTR(M_JC.SEIREKI,5,2)  AS PRAC_M            -- 03.診療月
     , CASE
         WHEN M_JC.SEIREKI IS NOT NULL THEN
             CASE
               WHEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) >= 1 AND TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) <= 3  THEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,1,4) - 1)
               WHEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) >= 4 AND TO_NUMBER(SUBSTR(M_JC.SEIREKI,5,2)) <= 12 THEN TO_NUMBER(SUBSTR(M_JC.SEIREKI,1,4))
               ELSE NULL
             END
         ELSE NULL
       END                     AS PRAC_NENDO          -- 04.診療年度
   , RE.SEX_DIV                AS SEX_DIV             -- 05.男女区分
   , M_SEX.SEX_DIV_NAME        AS SEX_DIV_NAME        -- 06.男女区分名称
   , MAX(HO.INSURER_NO)        AS INSURER_NO          -- 07.保険者番号（匿名化後）
   , SUM(HO.TOTAL_SCORE)       AS TOTAL_SCORE         -- 08.医療費（月合計）・点数
   , SUM(HO.PRAC_TRUE_DAYS)    AS PRAC_TRUE_DAYS      -- 09.診療実日数
  FROM
  /* 歯科(MN) */
  TNDS_T_RCP_DEN_MN MN
  /* 歯科(RE) */
  INNER JOIN TNDS_T_RCP_DEN_RE RE
                  ON  (  MN.PRAC_YM = RE.PRAC_YM
                     AND MN.SEQ2_NO = RE.SEQ2_NO )
  /* 歯科(HO) */
  LEFT OUTER JOIN TNDS_T_RCP_DEN_HO HO
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
