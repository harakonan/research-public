/*------------DPC特定傷病ビュー ------------*/
CREATE VIEW CMDV_T_DPC_SY AS
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
    SELECT /*+ USE_HASH_AGGREGATION */
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
    LEFT OUTER JOIN TNDS_T_RCP_DPC_SB SB
                    ON  ( MN.SEQ2_NO
                        = SB.SEQ2_NO
                    AND   MN.PRAC_YM
                        = SB.PRAC_YM )
    WHERE
      MN.KO_FLG IN (0,2) ) TOKUTEI_SY
  GROUP BY TOKUTEI_SY.SEQ2_NO
         , TOKUTEI_SY.PRAC_YM
WITH READ ONLY
;
