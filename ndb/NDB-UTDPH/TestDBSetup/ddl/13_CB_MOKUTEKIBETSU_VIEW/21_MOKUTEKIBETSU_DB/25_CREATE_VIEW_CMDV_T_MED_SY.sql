/*------------医科特定傷病ビュー ------------*/
CREATE VIEW CMDV_T_MED_SY AS
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
    LEFT OUTER JOIN TNDS_T_RCP_MED_SY SY
                    ON  ( MN.SEQ2_NO
                        = SY.SEQ2_NO
                    AND   MN.PRAC_YM
                        = SY.PRAC_YM )
    /* マスター紐づけ中間テーブル */
    LEFT OUTER JOIN TNDS_T_MSTLINK MSTLINK
                    ON ( MN.PRAC_YM = MSTLINK.APPL_YM_W )
    /* 傷病名マスター */
    LEFT OUTER JOIN TNDS_M_SKWD M_SKWD
                    ON ( SY.SKWD_NAME_CD = M_SKWD.SKWD_NAME_CD
                     AND MSTLINK.SKWD_MST_GEN = M_SKWD.MST_GEN )
    WHERE
      MN.KO_FLG IN (0,2) ) TOKUTEI_SY
  GROUP BY TOKUTEI_SY.SEQ2_NO
         , TOKUTEI_SY.PRAC_YM
WITH READ ONLY
;
