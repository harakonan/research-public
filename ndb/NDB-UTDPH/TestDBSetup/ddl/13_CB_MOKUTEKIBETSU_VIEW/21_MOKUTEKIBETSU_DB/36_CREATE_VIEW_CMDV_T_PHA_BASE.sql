/*------------ 調剤基本ビュー ------------*/
CREATE VIEW CMDV_T_PHA_BASE AS
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
  , RE.RCPT_IMPTT_NOTI             AS RCPT_IMPTT_NOTI         -- 026.レセプト特記事項
  , RE.TDFK                        AS TDFK_IK                 -- 027.都道府県(医療機関名称・所在地)
  , M_POPT_IK.TDFK_NAME            AS TDFK_NAME_IK            -- 028.都道府県(医療機関名称・所在地)名称
  , RE.SCORE_LIST                  AS SCORE_LIST_IK           -- 029.点数表(医療機関名称・所在地)
  , RE.MEDI_INST                   AS MEDI_INST_IK            -- 030.医療機関(医療機関名称・所在地)（匿名化後）
  , RE.SRCH_NO                     AS SRCH_NO                 -- 031.検索番号
  , RE.REC_CNDTN_SPEC_YM_INFO      AS REC_CNDTN_SPEC_YM_INFO  -- 032.記録条件仕様年月情報
  , RE.REQ_INFO                    AS REQ_INFO                -- 033.請求情報
  , RE.PART_BURD_DIV               AS PART_BURD_DIV           -- 034.一部負担金区分
  , YK.EXAM_PAY_INST               AS EXAM_PAY_INST           -- 035.審査支払機関
  , YK.TDFK                        AS TDFK                    -- 036.都道府県
  , M_POPT.TDFK_NAME               AS TDFK_NAME               -- 037.都道府県名
  , M_POPT.TTL_NUM                 AS TDFK_JINKOU             -- 038.都道府県人口
  , YK.SCORE_LIST                  AS SCORE_LIST              -- 039.点数表
  , YK.DRGST_CD                    AS DRGST_CD                -- 040.調剤薬局コード(匿名化後)
  , YK.REQ_YM                      AS REQ_YM                  -- 041.請求年月
  , YK.MLT_VOL_IDENT_INFO          AS MLT_VOL_IDENT_INFO      -- 042.マルチボリューム識別情報
  , M_MIC.SCND_MEDI_AREA_CD        AS SCND_MEDI_AREA_CD       -- 043.二次医療圏コード
  , M_POPS.SCND_MEDI_AREA_NAME     AS SCND_MEDI_AREA_NAME     -- 044.二次医療圏名
  , M_POPS.TTL_NUM                 AS SCND_MEDI_AREA_JINKOU   -- 045.二次医療圏人口
  , M_ICHI.ICHITAIRO_NAME          AS ICHITAIRO_DIV           -- 046.一退老区分
  , HO.INSURER_NO                  AS INSURER_NO              -- 047.保険者番号（匿名化後）
  , HO.PRSPT_RCPTN_TIMES           AS PRSPT_RCPTN_TIMES       -- 048.処方せん受付回数
  , HO.TOTAL_SCORE                 AS TOTAL_SCORE             -- 049.合計点数
  , HO.REASON_DUTY                 AS REASON_DUTY             -- 050.職務上の事由
  , M_REASON.REASON_DUTY_NAME      AS REASON_DUTY_NAME        -- 051.職務上の事由名称
  , HO.PART_BURD                   AS PART_BURD               -- 052.一部負担金
  , HO.RDCT_TAX_DIV                AS RDCT_TAX_DIV            -- 053.減免区分（負担金額）
  , M_RDCT.RDCT_DIV_NAME           AS RDCT_TAX_DIV_NAME       -- 054.減免区分（負担金額）名称
  , HO.RDCT_RAT                    AS RDCT_RAT                -- 055.減額割合（負担金額）
  , HO.RDCT_PRICE                  AS RDCT_PRICE              -- 056.減額金額（負担金額）
  FROM
  /* 調剤(MN) */
                  TNDS_T_RCP_PHA_MN MN
  /* 調剤(RE) */
  INNER JOIN TNDS_T_RCP_PHA_RE RE
                  ON  ( MN.SEQ2_NO
                      = RE.SEQ2_NO
                  AND   MN.PRAC_YM
                      = RE.PRAC_YM )
  /* 調剤(YK) */
  INNER JOIN TNDS_T_RCP_PHA_YK YK
                  ON  ( MN.SEQ2_NO
                      = YK.SEQ2_NO
                  AND   MN.PRAC_YM
                      = YK.PRAC_YM )
  /* 調剤(HO) */
  LEFT OUTER JOIN TNDS_T_RCP_PHA_HO HO
                  ON  ( MN.SEQ2_NO
                      = HO.SEQ2_NO
                  AND   MN.PRAC_YM
                      = HO.PRAC_YM )
  /* マスター紐づけ中間テーブル */
  LEFT OUTER JOIN TNDS_T_MSTLINK MSTLINK
                  ON ( MN.PRAC_YM = MSTLINK.APPL_YM_W )
  /* 都道府県ごとの人口（性・年齢階層別）１ */
  LEFT OUTER JOIN TNDS_M_POP_PER_TDFK M_POPT_IK
                  ON ( RE.TDFK = M_POPT_IK.TDFK_CD
                   AND M_POPT_IK.SEX = 0
                   AND MSTLINK.POP_PER_TDFK_GEN = M_POPT_IK.MST_GEN )
  /* 都道府県ごとの人口（性・年齢階層別）２ */
  LEFT OUTER JOIN TNDS_M_POP_PER_TDFK M_POPT
                  ON ( YK.TDFK = M_POPT.TDFK_CD
                   AND M_POPT.SEX = 0
                   AND MSTLINK.POP_PER_TDFK_GEN = M_POPT.MST_GEN )
  /* 医療機関・薬局マスター */
  LEFT OUTER JOIN TNDS_M_MIC M_MIC
                  ON ( YK.TDFK = M_MIC.MIC_TDFK_NO
                   AND YK.SCORE_LIST = M_MIC.MIC_SCORE_LIST_NO
                   AND SUBSTR( YK.DRGST_CD_ORG , 1 , 2 ) = M_MIC.MIC_CITY_AREA_NO
                   AND SUBSTR( YK.DRGST_CD_ORG , 3 , 4 ) = M_MIC.MIC_MIDI_INST_NO
                   AND SUBSTR( YK.DRGST_CD_ORG , 7 , 1 ) = M_MIC.MIC_VFCT_NO
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
  LEFT OUTER JOIN CMDS_M_ORI_SND_DIV M_SND       -- 送付元区分マスター
                  ON  ( YK.ORI_SND_DIV
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
