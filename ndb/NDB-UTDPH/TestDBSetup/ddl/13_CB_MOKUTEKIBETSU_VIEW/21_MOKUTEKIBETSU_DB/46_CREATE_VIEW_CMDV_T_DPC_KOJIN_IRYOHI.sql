/*------------ DPC個人別医療費ビュー ------------*/
CREATE VIEW CMDV_T_DPC_KOJIN_IRYOHI AS
  SELECT /*+ USE_HASH_AGGREGATION */
     RE.ID1N               AS ID1N                -- 01.ID1n
     , MN.PRAC_YM          AS PRAC_YM             -- 02.診療年月
     , SUBSTR(M_JC.SEIREKI,5,2)  AS PRAC_M        -- 03.診療月
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
   , MAX(HO.INSURER_NO)        AS INSURER_NO          -- 08.保険者番号（匿名化後）
   , MAX(TOKUTEI_SY.KANSHIKKAN_UMU)           AS KANSHIKKAN_UMU           -- 09.肝疾患有無
   , MAX(TOKUTEI_SY.KOUNYOSAN_KESSHOU_UMU)    AS KOUNYOSAN_KESSHOU_UMU    -- 10.高尿酸血症有無
   , MAX(TOKUTEI_SY.SHISHITSU_IJOU_UMU)       AS SHISHITSU_IJOU_UMU       -- 11.脂質異常有無
   , MAX(TOKUTEI_SY.KOUKETSUATSU_GAPPEI_UMU)  AS KOUKETSUATSU_GAPPEI_UMU  -- 12.高血圧性疾患及び合併症有無
   , MAX(TOKUTEI_SY.TOUNYO_GAPPEI_UMU)        AS TOUNYO_GAPPEI_UMU        -- 13.糖尿病及び合併症有無
   , MAX(TOKUTEI_SY.DOUMYAKUKOUKA_UMU)        AS DOUMYAKUKOUKA_UMU        -- 14.動脈硬化有無
   , MAX(TOKUTEI_SY.JINSHIKKAN_UMU)           AS JINSHIKKAN_UMU           -- 15.腎疾患有無
   , MAX(TOKUTEI_SY.NOUKEKKAN_SHIKKAN_UMU)    AS NOUKEKKAN_SHIKKAN_UMU    -- 16.脳血管疾患有無
   , MAX(TOKUTEI_SY.KYOKETSU_SHINSHIKKAN_UMU) AS KYOKETSU_SHINSHIKKAN_UMU -- 17.虚血性心疾患等有無
   , SUM(HO.TOTAL_SCORE)       AS TOTAL_SCORE         -- 19.医療費（月合計）・点数
   , SUM(HO.PRAC_TRUE_DAYS)    AS PRAC_TRUE_DAYS      -- 20.診療実日数
  FROM
  /* DPC(MN) */
  TNDS_T_RCP_DPC_MN MN
  /* DPC(RE) */
  INNER JOIN TNDS_T_RCP_DPC_RE RE
                  ON  (  MN.PRAC_YM = RE.PRAC_YM
                     AND MN.SEQ2_NO = RE.SEQ2_NO )
  /* DPC(HO) */
  LEFT OUTER JOIN TNDS_T_RCP_DPC_HO HO
                  ON  ( HO.TTL_FLG = 1
                   AND  MN.SEQ2_NO = HO.SEQ2_NO
                   AND  MN.PRAC_YM = HO.PRAC_YM )
  /* DPC特定傷病ビュー */
  LEFT OUTER JOIN 
  (
      SELECT /*+ USE_HASH_AGGREGATION */
      TOKUTEI_SY.SEQ2_NO                       AS SEQ2_NO                  -- 001.通番２
    , TOKUTEI_SY.PRAC_YM                       AS PRAC_YM                  -- 002.診療年月
    , MAX(TOKUTEI_SY.KANSHIKKAN_UMU)           AS KANSHIKKAN_UMU           -- 003.肝疾患有無
    , MAX(TOKUTEI_SY.KOUNYOSAN_KESSHOU_UMU)    AS KOUNYOSAN_KESSHOU_UMU    -- 004.高尿酸血症有無
    , MAX(TOKUTEI_SY.SHISHITSU_IJOU_UMU)       AS SHISHITSU_IJOU_UMU       -- 005.脂質異常有無
    , MAX(TOKUTEI_SY.KOUKETSUATSU_GAPPEI_UMU)  AS KOUKETSUATSU_GAPPEI_UMU  -- 006.高血圧性疾患及び合併症有無
    , MAX(TOKUTEI_SY.TOUNYO_GAPPEI_UMU)        AS TOUNYO_GAPPEI_UMU        -- 007.糖尿病及び合併症有無
    , MAX(TOKUTEI_SY.DOUMYAKUKOUKA_UMU)        AS DOUMYAKUKOUKA_UMU        -- 008.動脈硬化有無
    , MAX(TOKUTEI_SY.JINSHIKKAN_UMU)           AS JINSHIKKAN_UMU           -- 009.腎疾患有無
    , MAX(TOKUTEI_SY.NOUKEKKAN_SHIKKAN_UMU)    AS NOUKEKKAN_SHIKKAN_UMU    -- 010.脳血管疾患有無
    , MAX(TOKUTEI_SY.KYOKETSU_SHINSHIKKAN_UMU) AS KYOKETSU_SHINSHIKKAN_UMU -- 011.虚血性心疾患等有無
    FROM (
      SELECT
        MN.SEQ2_NO                     AS SEQ2_NO
      , MN.PRAC_YM                     AS PRAC_YM
      , CASE 
          WHEN SB.ICD10_CD LIKE 'K70%'
            OR SB.ICD10_CD =    'K760'  THEN 1
           ELSE 0
        END                            AS KANSHIKKAN_UMU            -- 003.肝疾患有無
      , CASE 
          WHEN SB.ICD10_CD =    'E790'
            OR SB.ICD10_CD =    'M103'  THEN 1
           ELSE 0
        END                            AS KOUNYOSAN_KESSHOU_UMU     -- 004.高尿酸血症有無
      , CASE 
          WHEN SB.ICD10_CD LIKE 'E78%'  THEN 1
           ELSE 0
        END                            AS SHISHITSU_IJOU_UMU        -- 005.脂質異常有無
      , CASE 
          WHEN SB.ICD10_CD LIKE 'I10%'
            OR SB.ICD10_CD LIKE 'I11%'
            OR SB.ICD10_CD LIKE 'I12%'
            OR SB.ICD10_CD LIKE 'I13%'  THEN 1
           ELSE 0
        END                            AS KOUKETSUATSU_GAPPEI_UMU   -- 006.高血圧性疾患及び合併症有無
      , CASE 
          WHEN SB.ICD10_CD LIKE 'E11%'
            OR SB.ICD10_CD LIKE 'E12%'
            OR SB.ICD10_CD LIKE 'E13%'
            OR SB.ICD10_CD LIKE 'E14%'  THEN 1
           ELSE 0
        END                            AS TOUNYO_GAPPEI_UMU         -- 007.糖尿病及び合併症有無
      , CASE 
          WHEN SB.ICD10_CD =    'E115'
            OR SB.ICD10_CD =    'E145'
            OR SB.ICD10_CD LIKE 'F01%'
            OR SB.ICD10_CD =    'G218'
            OR SB.ICD10_CD LIKE 'H34%'
            OR SB.ICD10_CD =    'I250'
            OR SB.ICD10_CD =    'I251'
            OR SB.ICD10_CD LIKE 'I65%'
            OR SB.ICD10_CD LIKE 'I66%'
            OR SB.ICD10_CD =    'I672'
            OR SB.ICD10_CD LIKE 'I70%'
            OR SB.ICD10_CD =    'I632'  THEN 1
           ELSE 0
        END                            AS DOUMYAKUKOUKA_UMU         -- 008.動脈硬化有無
      , CASE 
          WHEN SB.ICD10_CD LIKE 'I12%'
            OR SB.ICD10_CD LIKE 'I13%'
            OR SB.ICD10_CD LIKE 'I15%'
            OR SB.ICD10_CD =    'I701'
            OR SB.ICD10_CD =    'K767'  THEN 1
           ELSE 0
        END                            AS JINSHIKKAN_UMU            -- 009.腎疾患有無
      , CASE 
          WHEN SB.ICD10_CD LIKE 'I61%'
            OR SB.ICD10_CD =    'I691'
            OR SB.ICD10_CD LIKE 'I63%'
            OR SB.ICD10_CD =    'I693'  THEN 1
           ELSE 0
        END                            AS NOUKEKKAN_SHIKKAN_UMU     -- 010.脳血管疾患有無
      , CASE 
          WHEN SB.ICD10_CD LIKE 'I20%'
            OR SB.ICD10_CD LIKE 'I21%'
            OR SB.ICD10_CD LIKE 'I22%'
            OR SB.ICD10_CD LIKE 'I23%'
            OR SB.ICD10_CD LIKE 'I24%'
            OR SB.ICD10_CD LIKE 'I25%'  THEN 1
           ELSE 0
        END                            AS KYOKETSU_SHINSHIKKAN_UMU  -- 011.虚血性心疾患等有無
      FROM
      /* DPC(MN) */
                      TNDS_T_RCP_DPC_MN MN
      /* DPC(SB) */
      INNER JOIN TNDS_T_RCP_DPC_SB SB
                      ON  ( MN.SEQ2_NO
                          = SB.SEQ2_NO
                      AND   MN.PRAC_YM
                          = SB.PRAC_YM )
      WHERE
        MN.KO_FLG IN (0,2) ) TOKUTEI_SY
    GROUP BY TOKUTEI_SY.SEQ2_NO
           , TOKUTEI_SY.PRAC_YM
  ) TOKUTEI_SY
                  ON  ( MN.PRAC_YM = TOKUTEI_SY.PRAC_YM
                    AND MN.SEQ2_NO = TOKUTEI_SY.SEQ2_NO )
  LEFT OUTER JOIN TNDS_T_TRANS_JC_YEAR M_JC      -- 和暦西暦変換テーブル
                  ON  ( MN.PRAC_YM
                      = M_JC.WAREKI )
  LEFT OUTER JOIN CMDS_M_SEX_DIV M_SEX           -- 男女区分マスター
                  ON  ( RE.SEX_DIV
                      = M_SEX.SEX_DIV )
  WHERE
       RE.RCPT_GNRLZ_DIV IN ( '0' , '1' )   -- レセプト総括区分
   AND MN.KO_FLG IN (0,2)
  GROUP BY
     RE.ID1N
   , MN.PRAC_YM
   , M_JC.SEIREKI
   , M_SEX.SEX_DIV_NAME
   , RE.SEX_DIV
   , HO.INSURER_NO_AFT
WITH READ ONLY
;
