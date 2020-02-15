/*------------ DPC基本ビュー ------------*/
CREATE VIEW CMDV_T_DPC_BASE AS
  SELECT
    MN.SEQ2_NO                     AS SEQ2_NO                 -- 001.通番２
  , MN.RCP_MNG_NO                  AS RCP_MNG_NO              -- 002.レセプト管理番号
  , MN.INSU_MEDI_INST_ADDR         AS INSU_MEDI_INST_ADDR     -- 003.保険医療機関の所在地
  , RE.AGE                         AS AGE                     -- 004.年齢
  , RE.AGE_HIER_CD1                AS AGE_HIER_CD1            -- 005.年齢階層コード１
  , M_AGE01.AGE_HIER               AS AGE_HIER1               -- 006.年齢階層１
  , RE.AGE_HIER_CD2                AS AGE_HIER_CD2            -- 007.年齢階層コード２
  , M_AGE11.AGE_HIER               AS AGE_HIER2               -- 008.年齢階層２
  , RE.LAST_BIRTH_AGE              AS LAST_BIRTH_AGE          -- 009.満年齢
  , RE.LAST_BIRTH_AGE_HIER_CD1     AS LAST_BIRTH_AGE_HIER_CD1 -- 010.満年齢階層コード１
  , M_AGE02.AGE_HIER               AS LAST_BIRTH_AGE_HIER1    -- 011.満年齢階層１
  , RE.LAST_BIRTH_AGE_HIER_CD2     AS LAST_BIRTH_AGE_HIER_CD2 -- 012.満年齢階層コード２
  , M_AGE12.AGE_HIER               AS LAST_BIRTH_AGE_HIER2    -- 013.満年齢階層２
  , RE.ID1                         AS ID1                     -- 014.ID1
  , RE.ID1N                        AS ID1N                    -- 015.ID1n
  , RE.ID2                         AS ID2                     -- 016.ID2
  , RE.RCP_NO                      AS RCP_NO                  -- 017.レセプト番号
  , RE.RCP_CLS                     AS RCP_CLS                 -- 018.レセプト種別
  , MN.PRAC_YM                     AS PRAC_YM                 -- 019.診療年月
  , RE.INPUT_YM                    AS INPUT_YM                -- 020.取込年月
  , RE.SEX_DIV                     AS SEX_DIV                 -- 021.男女区分
  , M_SEX.SEX_DIV_NAME             AS SEX_DIV_NAME            -- 022.男女区分名称
  , RE.BIRTH_YM                    AS BIRTH_YM                -- 023.生年月
  , CASE
      WHEN  M_JC1.SEIREKI IS NOT NULL
        AND M_JC2.SEIREKI IS NOT NULL THEN
            MONTHS_BETWEEN(TO_DATE(TO_CHAR(M_JC2.SEIREKI) || N'01' , 'yyyymmdd') ,
                           TO_DATE(TO_CHAR(M_JC1.SEIREKI) || N'01' , 'yyyymmdd') )
         ELSE NULL
      END                          AS GETSUREI                -- 024.月齢
  , RE.PAY_RAT                     AS PAY_RAT                 -- 025.給付割合
  , RE.HOSTZ_YMD                   AS HOSTZ_YMD               -- 026.入院年月日
  , RE.WARD_DIV                    AS WARD_DIV                -- 027.病棟区分
  , M_WARD.WARD_DIV_NAME           AS WARD_DIV_NAME           -- 028.病棟区分名称
  , SUBSTR(RE.WARD_DIV,1,2)        AS WARD_DIV1               -- 030.病棟区分１
  , SUBSTR(RE.WARD_DIV,3,2)        AS WARD_DIV2               -- 030.病棟区分２
  , SUBSTR(RE.WARD_DIV,5,2)        AS WARD_DIV3               -- 031.病棟区分３
  , SUBSTR(RE.WARD_DIV,7,2)        AS WARD_DIV4               -- 032.病棟区分４
  , RE.STAND_BURD_DIV              AS STAND_BURD_DIV          -- 033.一部負担金・食事療養費・生活療養費標準負担額区分
  , M_STAND.STAND_BURD_DIV_NAME    AS STAND_BURD_DIV_NAME     -- 034.一部負担金・食事療養費・生活療養費標準負担額区分名称
  , RE.RCPT_IMPTT_NOTI             AS RCPT_IMPTT_NOTI         -- 035.レセプト特記事項
  , RE.DISCNT_SCR_UNIT_PRICE       AS DISCNT_SCR_UNIT_PRICE   -- 036.割引点数単価
  , RE.INDI_PRAC_DEPT              AS INDI_PRAC_DEPT          -- 037.予備（旧診療科）
  , M_PRAC_OLD.PRAC_NAME_NAME      AS INDI_PRAC_DEPT_NAME     -- 038.予備（旧診療科名称）
  , RE.RCPT_GNRLZ_DIV              AS RCPT_GNRLZ_DIV          -- 039.レセプト総括区分
  , M_GNRLZ.RCPT_GNRLZ_DIV_NAME    AS RCPT_GNRLZ_DIV_NAME     -- 040.レセプト総括区分名称
  , RE.DETL_INFO_NUM               AS DETL_INFO_NUM           -- 041.明細情報数
  , RE.SRCH_NO                     AS SRCH_NO                 -- 042.検索番号
  , RE.REC_CNDTN_SPEC_YM_INFO      AS REC_CNDTN_SPEC_YM_INFO  -- 043.記録条件仕様年月情報
  , RE.REQ_INFO                    AS REQ_INFO                -- 044.請求情報
  , RE.PRAC1_NAME                  AS PRAC1_NAME              -- 045.診療科１・診療科名
  , M_PRAC1.PRAC_NAME_NAME         AS PRAC1_NAME_NAME         -- 046.診療科１・診療科名名称
  , RE.PRAC1_BODY_PART             AS PRAC1_BODY_PART         -- 047.診療科１・人体の部位等
  , M_BODY1.BODY_PART_NAME         AS PRAC1_BODY_PART_NAME    -- 048.診療科１・人体の部位等名称
  , RE.PRAC1_SEX                   AS PRAC1_SEX               -- 049.診療科１・性別等
  , M_SEX1.SEX_NAME                AS PRAC1_SEX_NAME          -- 050.診療科１・性別等名称
  , RE.PRAC1_MEDI_TREAT            AS PRAC1_MEDI_TREAT        -- 051.診療科１・医学的処置
  , M_MEDI1.MEDI_TREAT_NAME        AS PRAC1_MEDI_TREAT_NAME   -- 052.診療科１・医学的処置名称
  , RE.PRAC1_SPCFC_DISE            AS PRAC1_SPCFC_DISE        -- 053.診療科１・特定疾病
  , M_SPCFC1.SPCFC_NAME            AS PRAC1_SPCFC_DISE_NAME   -- 054.診療科１・特定疾病名称
  , IR.EXAM_PAY_INST               AS EXAM_PAY_INST           -- 055.審査支払機関
  , IR.TDFK                        AS TDFK                    -- 056.都道府県
  , M_POPT.TDFK_NAME               AS TDFK_NAME               -- 057.都道府県名
  , M_POPT.TTL_NUM                 AS TDFK_JINKOU             -- 058.都道府県人口
  , IR.SCORE_LIST                  AS SCORE_LIST              -- 059.点数表
  , IR.MEDI_INST_CD                AS MEDI_INST_CD            -- 060.医療機関コード（匿名化後）
  , IR.PRAC_DEPT_CD                AS PRAC_DEPT_CD            -- 061.予備（診療科コード）
  , M_PRAC_DC.PRAC_NAME_NAME       AS PRAC_DEPT_NAME          -- 062.診療科名称
  , IR.REQ_YM                      AS REQ_YM                  -- 063.請求年月
  , IR.MLT_VOL_IDENT_INFO          AS MLT_VOL_IDENT_INFO      -- 064.マルチボリューム識別情報
  , M_MIC.SCND_MEDI_AREA_CD        AS SCND_MEDI_AREA_CD       -- 065.二次医療圏コード
  , M_POPS.SCND_MEDI_AREA_NAME     AS SCND_MEDI_AREA_NAME     -- 066.二次医療圏名
  , M_POPS.TTL_NUM                 AS SCND_MEDI_AREA_JINKOU   -- 067.二次医療圏人口
  , SB.SKWD_NAME_CD                AS MAIN_SKWD_CD            -- 068.主傷病コード
  , M_ICHI.ICHITAIRO_NAME          AS ICHITAIRO_DIV           -- 069.一退老区分
  , HO.INSURER_NO                  AS INSURER_NO              -- 070.保険者番号（匿名化後）
  , HO.PRAC_TRUE_DAYS              AS PRAC_TRUE_DAYS          -- 071.診療実日数
  , HO.TOTAL_SCORE                 AS TOTAL_SCORE             -- 072.合計点数
  , HO.TIMES                       AS TIMES                   -- 073.回数（食事療養・生活療養)
  , HO.TOTAL_PRICE                 AS TOTAL_PRICE             -- 074.合計金額（食事療養・生活療養）
  , HO.REASON_DUTY                 AS REASON_DUTY             -- 075.職務上の事由
  , M_REASON.REASON_DUTY_NAME      AS REASON_DUTY_NAME        -- 076.職務上の事由名称
  , HO.MEDI_INSU                   AS MEDI_INSU               -- 077.医療保険（負担金額）
  , HO.RDCT_TAX_DIV                AS RDCT_TAX_DIV            -- 078.減免区分（負担金額）
  , M_RDCT.RDCT_DIV_NAME           AS RDCT_TAX_DIV_NAME       -- 079.減免区分（負担金額）名称
  , HO.RDCT_RAT                    AS RDCT_RAT                -- 080.減額割合（負担金額）
  , HO.RDCT_PRICE                  AS RDCT_PRICE              -- 081.減額金額（負担金額）
  , HO.STAND_BURD_PRICE            AS STAND_BURD_PRICE        -- 082.標準負担額（食事療養・生活療養）
  FROM
  /* DPC(MN) */
                  TNDS_T_RCP_DPC_MN MN
  /* DPC(RE) */
  INNER JOIN TNDS_T_RCP_DPC_RE RE
                  ON  ( MN.SEQ2_NO
                      = RE.SEQ2_NO
                  AND   MN.PRAC_YM
                      = RE.PRAC_YM )
  /* DPC(IR) */
  INNER JOIN TNDS_T_RCP_DPC_IR IR
                  ON  ( MN.SEQ2_NO
                      = IR.SEQ2_NO
                  AND   MN.PRAC_YM
                      = IR.PRAC_YM )
  /* DPC(HO) */
  LEFT OUTER JOIN TNDS_T_RCP_DPC_HO HO
                  ON  ( HO.TTL_FLG = 1
                   AND  MN.SEQ2_NO = HO.SEQ2_NO
                   AND  MN.PRAC_YM = HO.PRAC_YM )
  /* DPC(SB) */
  LEFT OUTER JOIN TNDS_T_RCP_DPC_SB SB
                  ON ( SB.MAIN_SKWD_DECIS_FLG = 1
                   AND MN.SEQ2_NO = SB.SEQ2_NO
                   AND MN.PRAC_YM = SB.PRAC_YM )
  /* マスター紐づけ中間テーブル */
  LEFT OUTER JOIN TNDS_T_MSTLINK MSTLINK
                  ON ( MN.PRAC_YM = MSTLINK.APPL_YM_W )
  /* 都道府県ごとの人口（性・年齢階層別） */
  LEFT OUTER JOIN TNDS_M_POP_PER_TDFK M_POPT
                  ON ( IR.TDFK = M_POPT.TDFK_CD
                   AND M_POPT.SEX = 0
                   AND MSTLINK.POP_PER_TDFK_GEN = M_POPT.MST_GEN )
  /* 医療機関・薬局マスター */
  LEFT OUTER JOIN TNDS_M_MIC M_MIC
                  ON ( IR.TDFK = M_MIC.MIC_TDFK_NO
                   AND IR.SCORE_LIST = M_MIC.MIC_SCORE_LIST_NO
                   AND SUBSTR( IR.MEDI_INST_CD_ORG , 1 , 2 ) = M_MIC.MIC_CITY_AREA_NO
                   AND SUBSTR( IR.MEDI_INST_CD_ORG , 3 , 4 ) = M_MIC.MIC_MIDI_INST_NO
                   AND SUBSTR( IR.MEDI_INST_CD_ORG , 7 , 1 ) = M_MIC.MIC_VFCT_NO
                   AND MSTLINK.MIC_MST_GEN = M_MIC.MST_GEN )
  /* 二次医療圏ごとの人口（性・年齢階層別） */
  LEFT OUTER JOIN TNDS_M_POP_PER_SMA M_POPS
                  ON ( M_MIC.SCND_MEDI_AREA_CD = M_POPS.SCND_MEDI_AREA_CD
                   AND M_POPS.SEX = 0
                   AND MSTLINK.POP_PER_SCND_MEDI_AREA_GEN = M_POPS.MST_GEN )
  LEFT OUTER JOIN TNDS_T_AGE_DIV1 M_AGE01        -- 年齢階層区分テーブル１
                  ON  ( RE.AGE_HIER_CD1
                      = M_AGE01.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV2 M_AGE11        -- 年齢階層区分テーブル２
                  ON  ( RE.AGE_HIER_CD2
                      = M_AGE11.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV1 M_AGE02        -- 年齢階層区分テーブル１
                  ON  ( RE.LAST_BIRTH_AGE_HIER_CD1
                      = M_AGE02.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV2 M_AGE12        -- 年齢階層区分テーブル２
                  ON  ( RE.LAST_BIRTH_AGE_HIER_CD2
                      = M_AGE12.AGE_HIER_CODE )
  LEFT OUTER JOIN CMDS_M_SEX_DIV M_SEX           -- 男女区分マスター
                  ON  ( RE.SEX_DIV
                      = M_SEX.SEX_DIV )
  LEFT OUTER JOIN TNDS_T_TRANS_JC_YEAR M_JC1     -- 和暦西暦変換テーブル１
                  ON  ( RE.BIRTH_YM
                      = M_JC1.WAREKI )
  LEFT OUTER JOIN TNDS_T_TRANS_JC_YEAR M_JC2     -- 和暦西暦変換テーブル２
                  ON  ( MN.PRAC_YM
                      = M_JC2.WAREKI )
  LEFT OUTER JOIN CMDS_M_WARD_DIV M_WARD         -- 病棟区分マスター
                  ON  ( RE.WARD_DIV
                      = M_WARD.WARD_DIV )
  LEFT OUTER JOIN CMDS_M_STAND_BURD_DIV M_STAND  -- 一部負担金・食事療養費・生活療養費標準負担額区分マスター
                  ON  ( RE.STAND_BURD_DIV
                      = M_STAND.STAND_BURD_DIV )
  LEFT OUTER JOIN CMDS_M_RCP_GNRLZ_DIV M_GNRLZ   -- レセプト総括区分マスター
                  ON  ( RE.RCPT_GNRLZ_DIV
                      = M_GNRLZ.RCPT_GNRLZ_DIV )
  LEFT OUTER JOIN CMDS_M_PRAC M_PRAC_OLD         -- 診療科マスター
                  ON  ( RE.INDI_PRAC_DEPT
                      = M_PRAC_OLD.PRAC_NAME )
  LEFT OUTER JOIN CMDS_M_PRAC M_PRAC1            -- 診療科マスター１
                  ON  ( RE.PRAC1_NAME
                      = M_PRAC1.PRAC_NAME )
  LEFT OUTER JOIN CMDS_M_BODY_PART M_BODY1       -- 人体の部位等マスター１
                  ON  ( RE.PRAC1_BODY_PART
                      = M_BODY1.BODY_PART )
  LEFT OUTER JOIN CMDS_M_SEX M_SEX1              -- 性別等マスター１
                  ON  ( RE.PRAC1_SEX
                      = M_SEX1.SEX )
  LEFT OUTER JOIN CMDS_M_MEDI_TREAT M_MEDI1      -- 医学的処置マスター１
                  ON  ( RE.PRAC1_MEDI_TREAT
                      = M_MEDI1.MEDI_TREAT )
  LEFT OUTER JOIN CMDS_M_SPCFC_DISE M_SPCFC1     -- 特定疾病マスター１
                  ON  ( RE.PRAC1_SPCFC_DISE
                      = M_SPCFC1.SPCFC_DISE )
  LEFT OUTER JOIN CMDS_M_PRAC M_PRAC_DC          -- 診療科マスター
                  ON  ( IR.PRAC_DEPT_CD
                      = M_PRAC_DC.PRAC_NAME )
  LEFT OUTER JOIN CMDS_M_ORI_SND_DIV M_SND       -- 送付元区分マスター
                  ON  ( IR.ORI_SND_DIV
                      = M_SND.ORI_SND_DIV )
  LEFT OUTER JOIN CMDS_M_REASON_DUTY M_REASON    -- 職務上の事由マスター
                  ON  ( HO.REASON_DUTY
                      = M_REASON.REASON_DUTY )
  LEFT OUTER JOIN CMDS_M_RDCT_DIV M_RDCT         -- 減免区分マスター
                  ON  ( HO.RDCT_TAX_DIV
                      = M_RDCT.RDCT_DIV )
  LEFT OUTER JOIN CMDS_M_BYOSHIN_DIV M_BYOSHIN   -- 病診区分マスター
                  ON  ( M_MIC.VCI_HSPTL_DIV
                      = M_BYOSHIN.BYOSHIN_DIV )
  LEFT OUTER JOIN CMDS_M_ICHITAIRO_DIV M_ICHI    -- 一退老マスター
                  ON  ( SUBSTR(RE.RCP_CLS,2,1)
                      = M_ICHI.ICHITAIRO )
  WHERE
    MN.KO_FLG IN (0,2)
WITH READ ONLY
;
