/*------------ 医科個人別医療費ビュー ------------*/
CREATE VIEW CMDV_T_MED_KOJIN_IRYOHI AS
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
   , MAX(HO.INSURER_NO)        AS INSURER_NO          -- 07.保険者番号（匿名化後）
   , MAX(TOKUTEI_SY.KANSHIKKAN_UMU)           AS KANSHIKKAN_UMU           -- 08.肝疾患有無
   , MAX(TOKUTEI_SY.KOUNYOSAN_KESSHOU_UMU)    AS KOUNYOSAN_KESSHOU_UMU    -- 09.高尿酸血症有無
   , MAX(TOKUTEI_SY.SHISHITSU_IJOU_UMU)       AS SHISHITSU_IJOU_UMU       -- 10.脂質異常有無
   , MAX(TOKUTEI_SY.KOUKETSUATSU_GAPPEI_UMU)  AS KOUKETSUATSU_GAPPEI_UMU  -- 11.高血圧性疾患及び合併症有無
   , MAX(TOKUTEI_SY.TOUNYO_GAPPEI_UMU)        AS TOUNYO_GAPPEI_UMU        -- 12.糖尿病及び合併症有無
   , MAX(TOKUTEI_SY.DOUMYAKUKOUKA_UMU)        AS DOUMYAKUKOUKA_UMU        -- 13.動脈硬化有無
   , MAX(TOKUTEI_SY.JINSHIKKAN_UMU)           AS JINSHIKKAN_UMU           -- 14.腎疾患有無
   , MAX(TOKUTEI_SY.NOUKEKKAN_SHIKKAN_UMU)    AS NOUKEKKAN_SHIKKAN_UMU    -- 15.脳血管疾患有無
   , MAX(TOKUTEI_SY.KYOKETSU_SHINSHIKKAN_UMU) AS KYOKETSU_SHINSHIKKAN_UMU -- 16.虚血性心疾患等有無
   ,SUM(DECODE(SUBSTR(nvl(RE.RCP_CLS,''), 4, 1)
       ,'1', nvl(HO.TOTAL_SCORE,0)
       ,'3', nvl(HO.TOTAL_SCORE,0)
       ,'5', nvl(HO.TOTAL_SCORE,0)
       ,'7', nvl(HO.TOTAL_SCORE,0)
       ,'9', nvl(HO.TOTAL_SCORE,0)
       ,0
   )) + SUM(DECODE(SUBSTR(nvl(RE.RCP_CLS,''), 4, 1)
       ,'0', nvl(HO.TOTAL_SCORE,0)
       ,'2', nvl(HO.TOTAL_SCORE,0)
       ,'4', nvl(HO.TOTAL_SCORE,0)
       ,'6', nvl(HO.TOTAL_SCORE,0)
       ,'8', nvl(HO.TOTAL_SCORE,0)
       ,0
   )) AS TOTAL_SCORE -- 16.医療費（月合計）・点数
   ,SUM(DECODE(SUBSTR(nvl(RE.RCP_CLS,''), 4, 1)
       ,'1', nvl(HO.TOTAL_SCORE,0)
       ,'3', nvl(HO.TOTAL_SCORE,0)
       ,'5', nvl(HO.TOTAL_SCORE,0)
       ,'7', nvl(HO.TOTAL_SCORE,0)
       ,'9', nvl(HO.TOTAL_SCORE,0)
       ,0
   )) AS NYUIN_TOTAL_SCORE -- 17.医療費−入院（月合計）・点数
   ,SUM(DECODE(SUBSTR(nvl(RE.RCP_CLS,''), 4, 1)
       ,'0', nvl(HO.TOTAL_SCORE,0)
       ,'2', nvl(HO.TOTAL_SCORE,0)
       ,'4', nvl(HO.TOTAL_SCORE,0)
       ,'6', nvl(HO.TOTAL_SCORE,0)
       ,'8', nvl(HO.TOTAL_SCORE,0)
       ,0
   )) AS NYUINGAI_TOTAL_SCORE -- 18.医療費−入院外（月合計）・点数
   ,SUM(HO.PRAC_TRUE_DAYS) AS PRAC_TRUE_DAYS -- 19.診療実日数
  FROM
  /* MED(MN) */
  TNDS_T_RCP_MED_MN MN
  /* MED(RE) */
  INNER JOIN TNDS_T_RCP_MED_RE RE
                  ON  (  MN.PRAC_YM = RE.PRAC_YM
                     AND MN.SEQ2_NO = RE.SEQ2_NO )
  /* MED(HO) */
  LEFT OUTER JOIN TNDS_T_RCP_MED_HO HO
                  ON  (  MN.SEQ2_NO = HO.SEQ2_NO
                     AND MN.PRAC_YM = HO.PRAC_YM )
  /* 医科特定傷病ビュー */
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
         WHEN M_SKWD.ICD_10_1 LIKE 'K70%'
           OR M_SKWD.ICD_10_1 =    'K760'  THEN 1
          ELSE 0
       END                            AS KANSHIKKAN_UMU            -- 003.肝疾患有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 =    'E790'
           OR M_SKWD.ICD_10_1 =    'M103'  THEN 1
          ELSE 0
       END                            AS KOUNYOSAN_KESSHOU_UMU     -- 004.高尿酸血症有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 LIKE 'E78%'  THEN 1
          ELSE 0
       END                            AS SHISHITSU_IJOU_UMU        -- 005.脂質異常有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 LIKE 'I10%'
           OR M_SKWD.ICD_10_1 LIKE 'I11%'
           OR M_SKWD.ICD_10_1 LIKE 'I12%'
           OR M_SKWD.ICD_10_1 LIKE 'I13%'  THEN 1
          ELSE 0
       END                            AS KOUKETSUATSU_GAPPEI_UMU   -- 006.高血圧性疾患及び合併症有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 LIKE 'E11%'
           OR M_SKWD.ICD_10_1 LIKE 'E12%'
           OR M_SKWD.ICD_10_1 LIKE 'E13%'
           OR M_SKWD.ICD_10_1 LIKE 'E14%'  THEN 1
          ELSE 0
       END                            AS TOUNYO_GAPPEI_UMU         -- 007.糖尿病及び合併症有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 =    'E115'
           OR M_SKWD.ICD_10_1 =    'E145'
           OR M_SKWD.ICD_10_1 LIKE 'F01%'
           OR M_SKWD.ICD_10_1 =    'G218'
           OR M_SKWD.ICD_10_1 LIKE 'H34%'
           OR M_SKWD.ICD_10_1 =    'I250'
           OR M_SKWD.ICD_10_1 =    'I251'
           OR M_SKWD.ICD_10_1 LIKE 'I65%'
           OR M_SKWD.ICD_10_1 LIKE 'I66%'
           OR M_SKWD.ICD_10_1 =    'I672'
           OR M_SKWD.ICD_10_1 LIKE 'I70%'
           OR M_SKWD.ICD_10_1 =    'I632'  THEN 1
          ELSE 0
       END                            AS DOUMYAKUKOUKA_UMU         -- 008.動脈硬化有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 LIKE 'I12%'
           OR M_SKWD.ICD_10_1 LIKE 'I13%'
           OR M_SKWD.ICD_10_1 LIKE 'I15%'
           OR M_SKWD.ICD_10_1 =    'I701'
           OR M_SKWD.ICD_10_1 =    'K767'  THEN 1
          ELSE 0
       END                            AS JINSHIKKAN_UMU            -- 009.腎疾患有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 LIKE 'I61%'
           OR M_SKWD.ICD_10_1 =    'I691'
           OR M_SKWD.ICD_10_1 LIKE 'I63%'
           OR M_SKWD.ICD_10_1 =    'I693'  THEN 1
          ELSE 0
       END                            AS NOUKEKKAN_SHIKKAN_UMU     -- 010.脳血管疾患有無
     , CASE 
         WHEN M_SKWD.ICD_10_1 LIKE 'I20%'
           OR M_SKWD.ICD_10_1 LIKE 'I21%'
           OR M_SKWD.ICD_10_1 LIKE 'I22%'
           OR M_SKWD.ICD_10_1 LIKE 'I23%'
           OR M_SKWD.ICD_10_1 LIKE 'I24%'
           OR M_SKWD.ICD_10_1 LIKE 'I25%' THEN 1
          ELSE 0
       END                            AS KYOKETSU_SHINSHIKKAN_UMU  -- 011.虚血性心疾患等有無
     FROM
     /* 医科(MN) */
                     TNDS_T_RCP_MED_MN MN
     /* 医科(SY) */
     INNER JOIN TNDS_T_RCP_MED_SY SY
                     ON  ( MN.SEQ2_NO
                         = SY.SEQ2_NO
                     AND   MN.PRAC_YM
                         = SY.PRAC_YM )
     /* マスター紐づけ中間テーブル */
     INNER JOIN TNDS_T_MSTLINK MSTLINK
                     ON ( MN.PRAC_YM = MSTLINK.APPL_YM_W )
     /* 傷病名マスター */
     INNER JOIN TNDS_M_SKWD M_SKWD
                     ON ( SY.SKWD_NAME_CD = M_SKWD.SKWD_NAME_CD
                      AND MSTLINK.SKWD_MST_GEN = M_SKWD.MST_GEN )
     WHERE
       MN.KO_FLG IN (0,2) ) TOKUTEI_SY
   GROUP BY TOKUTEI_SY.SEQ2_NO
          , TOKUTEI_SY.PRAC_YM
  )TOKUTEI_SY
                  ON  ( MN.PRAC_YM = TOKUTEI_SY.PRAC_YM
                    AND MN.SEQ2_NO = TOKUTEI_SY.SEQ2_NO )
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
