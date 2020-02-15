WHENEVER SQLERROR EXIT 1;

exec dbms_mview.refresh('CMDS_M_TOKKEN_PER','c');
exec dbms_mview.refresh('CMDS_M_THOKEN_PER','c');

exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_TOKKEN_PER', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_THOKEN_PER', degree => dbms_stats.auto_degree, cascade => true );

ALTER SESSION FORCE PARALLEL DDL PARALLEL 96;
ALTER SESSION FORCE PARALLEL DML PARALLEL 96;
ALTER SESSION FORCE PARALLEL QUERY PARALLEL 96;

truncate table CMDS_T_TOKKEN_VIEW_TABLE;
truncate table CMDS_T_THOKEN_VIEW_TABLE;

insert /*+ append */ into CMDS_T_TOKKEN_VIEW_TABLE
  select
  /*------------ 基本情報部 ------------*/
    BA.SEQ1_NO                     AS SEQ1_NO                    -- 001.通番１
  , BA.IDENT_CD                    AS IDENT_CD                   -- 002.識別コード
  , BA.INPUT_YM                    AS INPUT_YM                   -- 003.取込年月
  , BA.VLD_FLG                     AS VLD_FLG                    -- 004.有効フラグ
  , BA.ID1                         AS ID1                        -- 005.ID1
  , BA.ID1N                        AS ID1N                       -- 006.ID1n
  , BA.ID2                         AS ID2                        -- 007.ID2
  , BA.AGE                         AS AGE                        -- 008.年齢
  , BA.AGE_HIER_CD1                AS AGE_HIER_CD1               -- 009.年齢階層コード１
  , M_AGE01.AGE_HIER               AS AGE_HIER1                  -- 010.年齢階層１
  , BA.AGE_HIER_CD2                AS AGE_HIER_CD2               -- 011.年齢階層コード２
  , M_AGE11.AGE_HIER               AS AGE_HIER2                  -- 012.年齢階層２
  , BA.LAST_BIRTH_AGE              AS LAST_BIRTH_AGE             -- 013.満年齢
  , BA.LAST_BIRTH_AGE_HIER_CD1     AS LAST_BIRTH_AGE_HIER_CD1    -- 014.満年齢階層コード１
  , M_AGE02.AGE_HIER               AS LAST_BIRTH_AGE_HIER1       -- 015.満年齢階層１
  , BA.LAST_BIRTH_AGE_HIER_CD2     AS LAST_BIRTH_AGE_HIER_CD2    -- 016.満年齢階層コード２
  , M_AGE12.AGE_HIER               AS LAST_BIRTH_AGE_HIER2       -- 017.満年齢階層２
  , BA.TESTEE_POST_NO              AS TESTEE_POST_NO             -- 018.受診者・郵便番号
  , SUBSTR(BA.MEE_INST_NO_ORG,1,2) AS TDFK                       -- 019.都道府県
  , M_POPT.TDFK_NAME               AS TDFK_NAME                  -- 020.都道府県名
  , M_POPT.TTL_NUM                 AS TDFK_JINKOU                -- 021.都道府県人口
  , BA.TESTEE_SEX_CD               AS TESTEE_SEX_CD              -- 022.受診者・性別コード
  , M_SEX.SEX_DIV_NAME             AS TESTEE_SEX_NAME            -- 023.受診者・性別名
  , BA.TESTEE_BIRTH_YM             AS TESTEE_BIRTH_YM            -- 024.受診者・生年月
  , BA.CNSLT_TCKT_FACE_CLS         AS CNSLT_TCKT_FACE_CLS        -- 025.券面種別(受診券)
  , BA.CNSLT_TCKT_RFRNC_NO         AS CNSLT_TCKT_RFRNC_NO        -- 026.受診券整理番号
  , BA.MEE_PRG_CLS                 AS MEE_PRG_CLS                -- 027.健診実施時のプログラム種別
  , BA.MEE_YMD                     AS MEE_YMD                    -- 028.健診実施年月日
  , SUBSTR(BA.MEE_YMD,1,6)         AS MEE_YM                     -- 029.健診実施年月
  , BA.MEE_NENDO                   AS MEE_NENDO                  -- 030.健診実施年度
  , BA.MEE_INST_NO_ORG             AS MEE_INST_NO_ORG            -- 031.健診実施機関番号
  , BA.MEE_INST_NO                 AS MEE_INST_NO                -- 032.健診実施機関番号(匿名化後)
  , BA.INSURER_NO_ORG              AS INSURER_NO_ORG             -- 033.保険者情報（保険者番号）
  , BA.INSURER_NO_AFT              AS INSURER_NO_AFT             -- 034.保険者情報(補正後)
  , BA.INSURER_NO                  AS INSURER_NO                 -- 035.保険者番号(匿名化後)
  , BA.RPT_DIV                     AS RPT_DIV                    -- 036.報告区分
  , BA.QLFCT_DIV                   AS QLFCT_DIV                  -- 037.資格区分
  /*------------ 問診結果情報・詳細情報部 ------------*/
  , EX.EX.HEIGHT                   AS HEIGHT                     -- 038.身長
  , EX.WEIGHT                      AS WEIGHT                     -- 039.体重
  , EX.BMI                         AS BMI                        -- 040.ＢＭＩ
  , EX.NAIZO_SHIBO_MENSEKI         AS NAIZO_SHIBO_MENSEKI        -- 041.内臓脂肪面積
  , EX.FUKUI_JISSOKU               AS FUKUI_JISSOKU              -- 042.腹囲(実測）
  , EX.FUKUI_JIKO_HANTEI           AS FUKUI_JIKO_HANTEI          -- 043.腹囲(自己判定）
  , EX.FUKUI_JIKO_SHINKOKU         AS FUKUI_JIKO_SHINKOKU        -- 044.腹囲(自己申告）
  , EX.KIOUREKI                    AS KIOUREKI                   -- 045.既往歴
  , EX.DETAIL_KIOUREKI             AS DETAIL_KIOUREKI            -- 046.（具体的な既往歴）
  , EX.JIKAKU_SHOJYO               AS JIKAKU_SHOJYO              -- 047.自覚症状
  , EX.JIKAKU_SHOJYO_SHOKEN        AS JIKAKU_SHOJYO_SHOKEN       -- 048.自覚症状（所見）
  , EX.TAKAKU_SHOJYO               AS TAKAKU_SHOJYO              -- 049.他覚症状
  , EX.TAKAKU_SHOJYO_SHOKEN        AS TAKAKU_SHOJYO_SHOKEN       -- 050.他覚症状（所見）
  , EX.SHUSHUKU_KETSUATSU_SONOTA   AS SHUSHUKU_KETSUATSU_SONOTA  -- 051.収縮期血圧（その他）
  , EX.SHUSHUKU_KETSUATSU_SECOND   AS SHUSHUKU_KETSUATSU_SECOND  -- 052.収縮期血圧（２回目）
  , EX.SHUSHUKU_KETSUATSU_FIRST    AS SHUSHUKU_KETSUATSU_FIRST   -- 053.収縮期血圧（１回目）
  , EX.KAKUCHO_KETSUATSU_SONOTA    AS KAKUCHO_KETSUATSU_SONOTA   -- 054.拡張期血圧（その他）
  , EX.KAKUCHO_KETSUATSU_SECOND    AS KAKUCHO_KETSUATSU_SECOND   -- 055.拡張期血圧（２回目）
  , EX.KAKUCHO_KETSUATSU_FIRST     AS KAKUCHO_KETSUATSU_FIRST    -- 056.拡張期血圧（１回目）
  , EX.SHINPAKUSU                  AS SHINPAKUSU                 -- 057.心拍数
  , EX.SAIKETSUJIKAN_SHOKUGO       AS SAIKETSUJIKAN_SHOKUGO      -- 058.採血時間（食後）
  , EX.CHOLESTEROL_KASHI           AS CHOLESTEROL_KASHI          -- 059.総コレステロール（可視吸光光度法）
  , EX.CHOLESTEROL_SHIGAISEN       AS CHOLESTEROL_SHIGAISEN      -- 060.総コレステロール（紫外吸光光度法）
  , EX.CHOLESTEROL_SONOTA          AS CHOLESTEROL_SONOTA         -- 061.総コレステロール（その他）
  , EX.CHUSEI_KASHI                AS CHUSEI_KASHI               -- 062.中性脂肪（トリグリセリド）（可視吸光光度法）
  , EX.CHUSEI_SHIGAISEN            AS CHUSEI_SHIGAISEN           -- 063.中性脂肪（トリグリセリド）（紫外吸光光度法）
  , EX.CHUSEI_SONOTA               AS CHUSEI_SONOTA              -- 064.中性脂肪（トリグリセリド）（その他）
  , EX.HDL_KASHI                   AS HDL_KASHI                  -- 065.ＨＤＬコレステロール（可視吸光光度法）
  , EX.HDL_SHIGAI                  AS HDL_SHIGAI                 -- 066.ＨＤＬコレステロール（紫外吸光光度法）
  , EX.HDL_SONOTA                  AS HDL_SONOTA                 -- 067.ＨＤＬコレステロール（その他）
  , EX.LDL_KASHI                   AS LDL_KASHI                  -- 068.ＬＤＬコレステロール（可視吸光光度法）
  , EX.LDL_SHIGAI                  AS LDL_SHIGAI                 -- 069.ＬＤＬコレステロール（紫外吸光光度法）
  , EX.LDL_SONOTA                  AS LDL_SONOTA                 -- 070.ＬＤＬコレステロール（その他）
  , EX.BILIRUBIN_KASHI             AS BILIRUBIN_KASHI            -- 071.総ビリルビン（可視吸光光度法）
  , EX.BILIRUBIN_SONOTA            AS BILIRUBIN_SONOTA           -- 072.総ビリルビン（その他）
  , EX.GOT_SHIGAI                  AS GOT_SHIGAI                 -- 073.GOT（ＡＳＴ）（紫外吸光光度法）
  , EX.GOT_SONOTA                  AS GOT_SONOTA                 -- 074.GOT（ＡＳＴ）（その他）
  , EX.GPT_SHIGAI                  AS GPT_SHIGAI                 -- 075.GPT（ＡＬＴ）（紫外吸光光度法）
  , EX.GPT_SONOTA                  AS GPT_SONOTA                 -- 076.GPT（ＡＬＴ）（その他）
  , EX.GAMMA_GT_KASHI              AS GAMMA_GT_KASHI             -- 077.γ-GT(γ-GTP)（可視吸光光度法）
  , EX.GAMMA_GT_SONOTA             AS GAMMA_GT_SONOTA            -- 078.γ-GT(γ-GTP)（その他）
  , EX.KUHUKU_KETTOU_DENI          AS KUHUKU_KETTOU_DENI         -- 079.空腹時血糖（電位差法）
  , EX.KUHUKU_KETTOU_KASHI         AS KUHUKU_KETTOU_KASHI        -- 080.空腹時血糖（可視吸光光度法）
  , EX.KUHUKU_KETTOU_SHIGAI        AS KUHUKU_KETTOU_SHIGAI       -- 081.空腹時血糖（紫外吸光光度法）
  , EX.KUHUKU_KETTOU_SONOTA        AS KUHUKU_KETTOU_SONOTA       -- 082.空腹時血糖（その他）
  , EX.HBA1C_MENEKI                AS HBA1C_MENEKI               -- 083.ＨｂＡ１ｃ（免疫学的方法）
  , EX.HBA1C_HPLC                  AS HBA1C_HPLC                 -- 084.ＨｂＡ１ｃ（HPLC）
  , EX.HBA1C_KOUSO                 AS HBA1C_KOUSO                -- 085.ＨｂＡ１ｃ（酵素法）
  , EX.HBA1C_SONOTA                AS HBA1C_SONOTA               -- 086.ＨｂＡ１ｃ（その他）
  , EX.NYOUTOU_KIKAI               AS NYOUTOU_KIKAI              -- 087.尿糖（機械読み取り）
  , EX.NYOUTOU_MOKUSHI             AS NYOUTOU_MOKUSHI            -- 088.尿糖（目視法）
  , EX.NYOUTANPAKU_KIKAI           AS NYOUTANPAKU_KIKAI          -- 089.尿蛋白（機械読み取り）
  , EX.NYOUTANPAKU_MOKUSHI         AS NYOUTANPAKU_MOKUSHI        -- 090.尿蛋白（目視法）
  , DECODE( DE.HEMATOCRIT_DETAIL , null , EX.HEMATOCRIT_EXAM , DE.HEMATOCRIT_DETAIL )                                     AS HEMATOCRIT                 -- 091.ヘマトクリット値               DETAILを表示 なければ EXAMを表示
  , DECODE( DE.HEMOGLOBIN_DETAIL , null , EX.HEMOGLOBIN_EXAM , DE.HEMOGLOBIN_DETAIL )                                     AS HEMOGLOBIN                 -- 092.血色素量［ヘモグロビン値］     DETAILを表示 なければ EXAMを表示
  , DECODE( DE.SEKKEKKYU_DETAIL  , null , EX.SEKKEKKYU_EXAM  , DE.SEKKEKKYU_DETAIL )                                      AS SEKKEKKYU                  -- 093.赤血球数                       DETAILを表示 なければ EXAMを表示
  , CASE
      WHEN EX.HINKETSU_KENSA_REASON_EXAM = '1' OR DE.HINKETSU_KENSA_REASON_DETAIL = '1' THEN '1'
      ELSE '0'
    END                            AS HINKETSU_KENSA_REASON                                                                                             -- 094.貧血検査（実施理由）
  , DECODE( DE.SHINDENZU_SHOKEN_UMU_DETAIL  , null , EX.SHINDENZU_SHOKEN_UMU_EXAM  , DE.SHINDENZU_SHOKEN_UMU_DETAIL )     AS SHINDENZU_SHOKEN_UMU       -- 095.心電図（所見の有無）           DETAILを表示 なければ EXAMを表示
  , CASE
      WHEN EX.SHINDENZU_SHOKEN_EXAM = '1' OR DE.SHINDENZU_SHOKEN_DETAIL = '1' THEN '1'
      ELSE '0'
    END                            AS SHINDENZU_SHOKEN                                                                                                  -- 096.心電図（所見）
  , CASE
      WHEN EX.SHINDENZU_REASON_EXAM = '1' OR DE.SHINDENZU_REASON_DETAIL = '1' THEN '1'
      ELSE '0'
    END                            AS SHINDENZU_REASON                                                                                                  -- 097.心電図（実施理由）
  , DECODE( DE.GANTEI_KENSA_KEITH_DETAIL  , null , EX.GANTEI_KENSA_KEITH_EXAM  , DE.GANTEI_KENSA_KEITH_DETAIL )           AS GANTEI_KENSA_KEITH         -- 098.眼底検査（キースワグナー分類） DETAILを表示 なければ EXAMを表示
  , DECODE( DE.GANTEI_KENSA_SCHEIE_H_DETAIL  , null , EX.GANTEI_KENSA_SCHEIE_H_EXAM  , DE.GANTEI_KENSA_SCHEIE_H_DETAIL )  AS GANTEI_KENSA_SCHEIE_H      -- 099.眼底検査（シェイエ分類：Ｈ）   DETAILを表示 なければ EXAMを表示
  , DECODE( DE.GANTEI_KENSA_SCHEIE_S_DETAIL  , null , EX.GANTEI_KENSA_SCHEIE_S_EXAM  , DE.GANTEI_KENSA_SCHEIE_S_DETAIL )  AS GANTEI_KENSA_SCHEIE_S      -- 100.眼底検査（シェイエ分類：Ｓ）   DETAILを表示 なければ EXAMを表示
  , DECODE( DE.GANTEI_KENSA_SCOTT_DETAIL  , null , EX.GANTEI_KENSA_SCOTT_EXAM  , DE.GANTEI_KENSA_SCOTT_DETAIL )           AS GANTEI_KENSA_SCOTT         -- 101.眼底検査（ＳＣＯＴＴ分類)      DETAILを表示 なければ EXAMを表示
  , CASE
      WHEN EX.GANTEI_KENSA_SONOTA_SHOKEN_EX = '1' OR DE.GANTEI_KENSA_SONOTA_SHOKEN_DE = '1' THEN '1'
      ELSE '0'
    END                            AS GANTEI_KENSA_SONOTA_SHOKEN                                                                                        -- 102.眼底検査（その他の所見）
  , CASE
      WHEN EX.GANTEI_KENSA_REASON_EXAM = '1' OR DE.GANTEI_KENSA_REASON_DETAIL = '1' THEN '1'
      ELSE '0'
    END                            AS GANTEI_KENSA_REASON                                                                                               -- 103.眼底検査（実施理由）
  , EX.METABOLIC_HANTEI            AS METABOLIC_HANTEI           -- 104.メタボリックシンドローム判定
  , EX.HOKENSHIDOU_LEVEL           AS HOKENSHIDOU_LEVEL          -- 105.保健指導レベル
  , EX.DOCTOR_HANTEI               AS DOCTOR_HANTEI              -- 106.医師の診断（判定）
  , EX.KENKOU_SHINDAN_DOCTOR_NAME  AS KENKOU_SHINDAN_DOCTOR_NAME -- 107.健康診断を実施した医師の氏名
  , EX.HUKUYAKU1_KETSUATSU         AS HUKUYAKU1_KETSUATSU        -- 108.服薬１（血圧）
  , EX.HUKUYAKU1_PHARMA            AS HUKUYAKU1_PHARMA           -- 109.服薬１（薬剤）
  , EX.HUKUYAKU1_HUKUYAKU_REASON   AS HUKUYAKU1_HUKUYAKU_REASON  -- 110.服薬１（服薬理由）
  , EX.HUKUYAKU2_KETTOU            AS HUKUYAKU2_KETTOU           -- 111.服薬２（血糖）
  , EX.HUKUYAKU2_PHARMA            AS HUKUYAKU2_PHARMA           -- 112.服薬２（薬剤）
  , EX.HUKUYAKU2_HUKUYAKU_REASON   AS HUKUYAKU2_HUKUYAKU_REASON  -- 113.服薬２（服薬理由）
  , EX.HUKUYAKU3_SHISHITSU         AS HUKUYAKU3_SHISHITSU        -- 114.服薬３（脂質）
  , EX.HUKUYAKU3_PHARMA            AS HUKUYAKU3_PHARMA           -- 115.服薬３（薬剤）
  , EX.HUKUYAKU3_HUKUYAKU_REASON   AS HUKUYAKU3_HUKUYAKU_REASON  -- 116.服薬３（服薬理由）
  , EX.KIOUREKI1_NOUKEKKAN         AS KIOUREKI1_NOUKEKKAN        -- 117.既往歴１（脳血管）
  , EX.KIOUREKI2_SHINKEKKAN        AS KIOUREKI2_SHINKEKKAN       -- 118.既往歴２（心血管）
  , EX.KIOUREKI3_JINHUZEN_TOUSEKI  AS KIOUREKI3_JINHUZEN_TOUSEKI -- 119.既往歴３（腎不全・人工透析）
  , EX.HINKETSU                    AS HINKETSU                   -- 120.貧血
  , EX.KITSUEN                     AS KITSUEN                    -- 121.喫煙
  , EX.TWENTY_WEIGHT_HENKA         AS TWENTY_WEIGHT_HENKA        -- 122.２０歳からの体重変化
  , EX.THIRTY_UNDOU_SHUKAN         AS THIRTY_UNDOU_SHUKAN        -- 123.３０分以上の運動習慣
  , EX.HOKOU_SHINTAI               AS HOKOU_SHINTAI              -- 124.歩行又は身体活動
  , EX.HOKOU_SOKUDO                AS HOKOU_SOKUDO               -- 125.歩行速度
  , EX.ONE_YEAR_TAIJYU_HENKA       AS ONE_YEAR_TAIJYU_HENKA      -- 126.1年間の体重変化
  , EX.TABEKATA1                   AS TABEKATA1                  -- 127.食べ方1（早食い等）
  , EX.TABEKATA2                   AS TABEKATA2                  -- 128.食べ方２（就寝前）
  , EX.TABEKATA3                   AS TABEKATA3                  -- 129.食べ方３（夜食/間食）
  , EX.SHOKUSHUKAN                 AS SHOKUSHUKAN                -- 130.食習慣
  , EX.INSHU                       AS INSHU                      -- 131.飲酒
  , EX.INSYURYO                    AS INSYURYO                   -- 132.飲酒量
  , EX.SUIMIN                      AS SUIMIN                     -- 133.睡眠
  , EX.SEIKATSUSHUKAN_KAIZEN       AS SEIKATSUSHUKAN_KAIZEN      -- 134.生活習慣の改善
  , EX.HOKENSHIDOU_KIBOU           AS HOKENSHIDOU_KIBOU          -- 135.保健指導の希望
  FROM
  /* 基本情報レコード（特定健診） */
            TNDS_T_TOKKEN_BASE BA
  /* 健診結果・問診結果情報レコード（特定健診） */
  LEFT OUTER JOIN (
                   SELECT  SEQ1_NO                                       AS SEQ1_NO                    -- 001.通番１
                     , MAX(DECODE(CD,'9N001000000000001' ,VAL ))         AS HEIGHT                     -- 038.身長
                     , MAX(DECODE(CD,'9N006000000000001' ,VAL ))         AS WEIGHT                     -- 039.体重
                     , MAX(DECODE(CD,'9N011000000000001' ,VAL ))         AS BMI                        -- 040.ＢＭＩ
                     , MAX(DECODE(CD,'9N021000000000001' ,VAL ))         AS NAIZO_SHIBO_MENSEKI        -- 041.内臓脂肪面積
                     , MAX(DECODE(CD,'9N016160100000001' ,VAL ))         AS FUKUI_JISSOKU              -- 042.腹囲(実測）
                     , MAX(DECODE(CD,'9N016160200000001' ,VAL ))         AS FUKUI_JIKO_HANTEI          -- 043.腹囲(自己判定）
                     , MAX(DECODE(CD,'9N016160300000001' ,VAL ))         AS FUKUI_JIKO_SHINKOKU        -- 044.腹囲(自己申告）
                     , MAX(DECODE(CD,'9N056000000000011' ,VALUE_CD ))    AS KIOUREKI                   -- 045.既往歴
                     , MAX(DECODE(CD,'9N056160400000049' ,VAL_FREE ))    AS DETAIL_KIOUREKI            -- 046.（具体的な既往歴）
                     , MAX(DECODE(CD,'9N061000000000011' ,VALUE_CD ))    AS JIKAKU_SHOJYO              -- 047.自覚症状
                     , MAX(DECODE(CD,'9N061160800000049' ,VAL_FREE ))    AS JIKAKU_SHOJYO_SHOKEN       -- 048.自覚症状（所見）
                     , MAX(DECODE(CD,'9N066000000000011' ,VALUE_CD ))    AS TAKAKU_SHOJYO              -- 049.他覚症状
                     , MAX(DECODE(CD,'9N066160800000049' ,VAL_FREE ))    AS TAKAKU_SHOJYO_SHOKEN       -- 050.他覚症状（所見）
                     , MAX(DECODE(CD,'9A755000000000001' ,VAL ))         AS SHUSHUKU_KETSUATSU_SONOTA  -- 051.収縮期血圧（その他）
                     , MAX(DECODE(CD,'9A752000000000001' ,VAL ))         AS SHUSHUKU_KETSUATSU_SECOND  -- 052.収縮期血圧（２回目）
                     , MAX(DECODE(CD,'9A751000000000001' ,VAL ))         AS SHUSHUKU_KETSUATSU_FIRST   -- 053.収縮期血圧（１回目）
                     , MAX(DECODE(CD,'9A765000000000001' ,VAL ))         AS KAKUCHO_KETSUATSU_SONOTA   -- 054.拡張期血圧（その他）
                     , MAX(DECODE(CD,'9A762000000000001' ,VAL ))         AS KAKUCHO_KETSUATSU_SECOND   -- 055.拡張期血圧（２回目）
                     , MAX(DECODE(CD,'9A761000000000001' ,VAL ))         AS KAKUCHO_KETSUATSU_FIRST    -- 056.拡張期血圧（１回目）
                     , MAX(DECODE(CD,'9N121000000000001' ,VAL ))         AS SHINPAKUSU                 -- 057.心拍数
                     , MAX(DECODE(CD,'9N141000000000011' ,VALUE_CD ))    AS SAIKETSUJIKAN_SHOKUGO      -- 058.採血時間（食後）
                     , MAX(DECODE(CD,'3F050000002327101' ,VAL ))         AS CHOLESTEROL_KASHI          -- 059.総コレステロール（可視吸光光度法）
                     , MAX(DECODE(CD,'3F050000002327201' ,VAL ))         AS CHOLESTEROL_SHIGAISEN      -- 060.総コレステロール（紫外吸光光度法）
                     , MAX(DECODE(CD,'3F050000002399901' ,VAL ))         AS CHOLESTEROL_SONOTA         -- 061.総コレステロール（その他）
                     , MAX(DECODE(CD,'3F015000002327101' ,VAL ))         AS CHUSEI_KASHI               -- 062.中性脂肪（トリグリセリド）（可視吸光光度法）
                     , MAX(DECODE(CD,'3F015000002327201' ,VAL ))         AS CHUSEI_SHIGAISEN           -- 063.中性脂肪（トリグリセリド）（紫外吸光光度法）
                     , MAX(DECODE(CD,'3F015000002399901' ,VAL ))         AS CHUSEI_SONOTA              -- 064.中性脂肪（トリグリセリド）（その他）
                     , MAX(DECODE(CD,'3F070000002327101' ,VAL ))         AS HDL_KASHI                  -- 065.ＨＤＬコレステロール（可視吸光光度法）
                     , MAX(DECODE(CD,'3F070000002327201' ,VAL ))         AS HDL_SHIGAI                 -- 066.ＨＤＬコレステロール（紫外吸光光度法）
                     , MAX(DECODE(CD,'3F070000002399901' ,VAL ))         AS HDL_SONOTA                 -- 067.ＨＤＬコレステロール（その他）
                     , MAX(DECODE(CD,'3F077000002327101' ,VAL ))         AS LDL_KASHI                  -- 068.ＬＤＬコレステロール（可視吸光光度法）
                     , MAX(DECODE(CD,'3F077000002327201' ,VAL ))         AS LDL_SHIGAI                 -- 069.ＬＤＬコレステロール（紫外吸光光度法）
                     , MAX(DECODE(CD,'3F077000002399901' ,VAL ))         AS LDL_SONOTA                 -- 070.ＬＤＬコレステロール（その他）
                     , MAX(DECODE(CD,'3J010000002327101' ,VAL ))         AS BILIRUBIN_KASHI            -- 071.総ビリルビン（可視吸光光度法）
                     , MAX(DECODE(CD,'3J010000002399901' ,VAL ))         AS BILIRUBIN_SONOTA           -- 072.総ビリルビン（その他）
                     , MAX(DECODE(CD,'3B035000002327201' ,VAL ))         AS GOT_SHIGAI                 -- 073.GOT（ＡＳＴ）（紫外吸光光度法）
                     , MAX(DECODE(CD,'3B035000002399901' ,VAL ))         AS GOT_SONOTA                 -- 074.GOT（ＡＳＴ）（その他）
                     , MAX(DECODE(CD,'3B045000002327201' ,VAL ))         AS GPT_SHIGAI                 -- 075.GPT（ＡＬＴ）（紫外吸光光度法）
                     , MAX(DECODE(CD,'3B045000002399901' ,VAL ))         AS GPT_SONOTA                 -- 076.GPT（ＡＬＴ）（その他）
                     , MAX(DECODE(CD,'3B090000002327101' ,VAL ))         AS GAMMA_GT_KASHI             -- 077.γ-GT(γ-GTP)（可視吸光光度法）
                     , MAX(DECODE(CD,'3B090000002399901' ,VAL ))         AS GAMMA_GT_SONOTA            -- 078.γ-GT(γ-GTP)（その他）
                     , MAX(DECODE(CD,'3D010000001926101' ,VAL ))         AS KUHUKU_KETTOU_DENI         -- 079.空腹時血糖（電位差法）
                     , MAX(DECODE(CD,'3D010000002227101' ,VAL ))         AS KUHUKU_KETTOU_KASHI        -- 080.空腹時血糖（可視吸光光度法）
                     , MAX(DECODE(CD,'3D010000001927201' ,VAL ))         AS KUHUKU_KETTOU_SHIGAI       -- 081.空腹時血糖（紫外吸光光度法）
                     , MAX(DECODE(CD,'3D010000001999901' ,VAL ))         AS KUHUKU_KETTOU_SONOTA       -- 082.空腹時血糖（その他）
                     , DECODE( MAX(DECODE(CD,'3D046000001906202' ,VAL ))  , null , MAX(DECODE(CD,'3D045000001906202' ,VAL ))  , MAX(DECODE(CD,'3D046000001906202' ,VAL )) )   AS HBA1C_MENEKI  -- 083.ＨｂＡ１ｃ（免疫学的方法）
                     , DECODE( MAX(DECODE(CD,'3D046000001920402' ,VAL ))  , null , MAX(DECODE(CD,'3D045000001920402' ,VAL ))  , MAX(DECODE(CD,'3D046000001920402' ,VAL )) )   AS HBA1C_HPLC    -- 084.ＨｂＡ１ｃ（HPLC）
                     , DECODE( MAX(DECODE(CD,'3D046000001927102' ,VAL ))  , null , MAX(DECODE(CD,'3D045000001927102' ,VAL ))  , MAX(DECODE(CD,'3D046000001927102' ,VAL )) )   AS HBA1C_KOUSO   -- 085.ＨｂＡ１ｃ（酵素法）
                     , DECODE( MAX(DECODE(CD,'3D046000001999902' ,VAL ))  , null , MAX(DECODE(CD,'3D045000001999902' ,VAL ))  , MAX(DECODE(CD,'3D046000001999902' ,VAL )) )   AS HBA1C_SONOTA  -- 086.ＨｂＡ１ｃ（その他）
                     , MAX(DECODE(CD,'1A020000000191111' ,VALUE_CD ))    AS NYOUTOU_KIKAI              -- 087.尿糖（機械読み取り）
                     , MAX(DECODE(CD,'1A020000000190111' ,VALUE_CD ))    AS NYOUTOU_MOKUSHI            -- 088.尿糖（目視法）
                     , MAX(DECODE(CD,'1A010000000191111' ,VALUE_CD ))    AS NYOUTANPAKU_KIKAI          -- 089.尿蛋白（機械読み取り）
                     , MAX(DECODE(CD,'1A010000000190111' ,VALUE_CD ))    AS NYOUTANPAKU_MOKUSHI        -- 090.尿蛋白（目視法）
                     , MAX(DECODE(CD,'2A040000001930102' ,VAL ,null))        AS HEMATOCRIT_EXAM                 -- 091.ヘマトクリット値                 VAL
                     , MAX(DECODE(CD,'2A030000001930101' ,VAL ,null))        AS HEMOGLOBIN_EXAM                 -- 092.血色素量［ヘモグロビン値］       VAL
                     , MAX(DECODE(CD,'2A020000001930101' ,VAL ,null))        AS SEKKEKKYU_EXAM                  -- 093.赤血球数                         VAL
                     , MAX(DECODE(CD,'2A020161001930149' ,VAL_FREE ))        AS HINKETSU_KENSA_REASON_EXAM      -- 094.貧血検査（実施理由）             VAL_FREE
                     , MAX(DECODE(CD,'9A110160700000011' ,VALUE_CD ,null ))  AS SHINDENZU_SHOKEN_UMU_EXAM       -- 095.心電図（所見の有無）             VALUE_CD
                     , MAX(DECODE(CD,'9A110160800000049' ,VAL_FREE ))        AS SHINDENZU_SHOKEN_EXAM           -- 096.心電図（所見）                   VAL_FREE
                     , MAX(DECODE(CD,'9A110161000000049' ,VAL_FREE ))        AS SHINDENZU_REASON_EXAM           -- 097.心電図（実施理由）               VAL_FREE
                     , MAX(DECODE(CD,'9E100166000000011' ,VALUE_CD ,null))   AS GANTEI_KENSA_KEITH_EXAM         -- 098.眼底検査（キースワグナー分類）   VALUE_CD
                     , MAX(DECODE(CD,'9E100166100000011' ,VALUE_CD ,null))   AS GANTEI_KENSA_SCHEIE_H_EXAM      -- 099.眼底検査（シェイエ分類：Ｈ）     VALUE_CD
                     , MAX(DECODE(CD,'9E100166200000011' ,VALUE_CD ,null))   AS GANTEI_KENSA_SCHEIE_S_EXAM      -- 100.眼底検査（シェイエ分類：Ｓ）     VALUE_CD
                     , MAX(DECODE(CD,'9E100166300000011' ,VALUE_CD ,null))   AS GANTEI_KENSA_SCOTT_EXAM         -- 101.眼底検査（ＳＣＯＴＴ分類)        VALUE_CD
                     , MAX(DECODE(CD,'9E100160900000049' ,VAL_FREE ))        AS GANTEI_KENSA_SONOTA_SHOKEN_EX   -- 102.眼底検査（その他の所見）         VAL_FREE
                     , MAX(DECODE(CD,'9E100161000000049' ,VAL_FREE ))        AS GANTEI_KENSA_REASON_EXAM        -- 103.眼底検査（実施理由）             VAL_FREE
                     , MAX(DECODE(CD,'9N501000000000011' ,VALUE_CD ))    AS METABOLIC_HANTEI           -- 104.メタボリックシンドローム判定
                     , MAX(DECODE(CD,'9N506000000000011' ,VALUE_CD ))    AS HOKENSHIDOU_LEVEL          -- 105.保健指導レベル
                     , MAX(DECODE(CD,'9N511000000000049' ,VAL_FREE ))    AS DOCTOR_HANTEI              -- 106.医師の診断（判定）
                     , MAX(DECODE(CD,'9N516000000000049' ,VAL_FREE ))    AS KENKOU_SHINDAN_DOCTOR_NAME -- 107.健康診断を実施した医師の氏名
                     , MAX(DECODE(CD,'9N701000000000011' ,VALUE_CD ))    AS HUKUYAKU1_KETSUATSU        -- 108.服薬１（血圧）
                     , MAX(DECODE(CD,'9N701167000000049' ,VAL_FREE ))    AS HUKUYAKU1_PHARMA           -- 109.服薬１（薬剤）
                     , MAX(DECODE(CD,'9N701167100000049' ,VAL_FREE ))    AS HUKUYAKU1_HUKUYAKU_REASON  -- 110.服薬１（服薬理由）
                     , MAX(DECODE(CD,'9N706000000000011' ,VALUE_CD ))    AS HUKUYAKU2_KETTOU           -- 111.服薬２（血糖）
                     , MAX(DECODE(CD,'9N706167000000049' ,VAL_FREE ))    AS HUKUYAKU2_PHARMA           -- 112.服薬２（薬剤）
                     , MAX(DECODE(CD,'9N706167100000049' ,VAL_FREE ))    AS HUKUYAKU2_HUKUYAKU_REASON  -- 113.服薬２（服薬理由）
                     , MAX(DECODE(CD,'9N711000000000011' ,VALUE_CD ))    AS HUKUYAKU3_SHISHITSU        -- 114.服薬３（脂質）
                     , MAX(DECODE(CD,'9N711167000000049' ,VAL_FREE ))    AS HUKUYAKU3_PHARMA           -- 115.服薬３（薬剤）
                     , MAX(DECODE(CD,'9N711167100000049' ,VAL_FREE ))    AS HUKUYAKU3_HUKUYAKU_REASON  -- 116.服薬３（服薬理由）
                     , MAX(DECODE(CD,'9N716000000000011' ,VALUE_CD ))    AS KIOUREKI1_NOUKEKKAN        -- 117.既往歴１（脳血管）
                     , MAX(DECODE(CD,'9N721000000000011' ,VALUE_CD ))    AS KIOUREKI2_SHINKEKKAN       -- 118.既往歴２（心血管）
                     , MAX(DECODE(CD,'9N726000000000011' ,VALUE_CD ))    AS KIOUREKI3_JINHUZEN_TOUSEKI -- 119.既往歴３（腎不全・人工透析）
                     , MAX(DECODE(CD,'9N731000000000011' ,VALUE_CD ))    AS HINKETSU                   -- 120.貧血
                     , MAX(DECODE(CD,'9N736000000000011' ,VALUE_CD ))    AS KITSUEN                    -- 121.喫煙
                     , MAX(DECODE(CD,'9N741000000000011' ,VALUE_CD ))    AS TWENTY_WEIGHT_HENKA        -- 122.２０歳からの体重変化
                     , MAX(DECODE(CD,'9N746000000000011' ,VALUE_CD ))    AS THIRTY_UNDOU_SHUKAN        -- 123.３０分以上の運動習慣
                     , MAX(DECODE(CD,'9N751000000000011' ,VALUE_CD ))    AS HOKOU_SHINTAI              -- 124.歩行又は身体活動
                     , MAX(DECODE(CD,'9N756000000000011' ,VALUE_CD ))    AS HOKOU_SOKUDO               -- 125.歩行速度
                     , MAX(DECODE(CD,'9N761000000000011' ,VALUE_CD ))    AS ONE_YEAR_TAIJYU_HENKA      -- 126.1年間の体重変化
                     , MAX(DECODE(CD,'9N766000000000011' ,VALUE_CD ))    AS TABEKATA1                  -- 127.食べ方1（早食い等）
                     , MAX(DECODE(CD,'9N771000000000011' ,VALUE_CD ))    AS TABEKATA2                  -- 128.食べ方２（就寝前）
                     , MAX(DECODE(CD,'9N776000000000011' ,VALUE_CD ))    AS TABEKATA3                  -- 129.食べ方３（夜食/間食）
                     , MAX(DECODE(CD,'9N781000000000011' ,VALUE_CD ))    AS SHOKUSHUKAN                -- 130.食習慣
                     , MAX(DECODE(CD,'9N786000000000011' ,VALUE_CD ))    AS INSHU                      -- 131.飲酒
                     , MAX(DECODE(CD,'9N791000000000011' ,VALUE_CD ))    AS INSYURYO                   -- 132.飲酒量
                     , MAX(DECODE(CD,'9N796000000000011' ,VALUE_CD ))    AS SUIMIN                     -- 133.睡眠
                     , MAX(DECODE(CD,'9N801000000000011' ,VALUE_CD ))    AS SEIKATSUSHUKAN_KAIZEN      -- 134.生活習慣の改善
                     , MAX(DECODE(CD,'9N806000000000011' ,VALUE_CD ))    AS HOKENSHIDOU_KIBOU          -- 135.保健指導の希望
                   FROM TNDS_T_TOKKEN_EXAM
                   GROUP BY SEQ1_NO ) EX
          ON  ( BA.SEQ1_NO
              = EX.SEQ1_NO )
  /* 詳細情報レコード（特定健診） */
  LEFT OUTER JOIN (
                   SELECT  SEQ1_NO                                          AS SEQ1_NO                             -- 001.通番１
                     , MAX(DECODE(CD,'2A040000001930102' ,VAL ,null ))      AS HEMATOCRIT_DETAIL                   -- 091.ヘマトクリット値                 VAL
                     , MAX(DECODE(CD,'2A030000001930101' ,VAL ,null))       AS HEMOGLOBIN_DETAIL                   -- 092.血色素量［ヘモグロビン値］       VAL
                     , MAX(DECODE(CD,'2A020000001930101' ,VAL ,null))       AS SEKKEKKYU_DETAIL                    -- 093.赤血球数                         VAL
                     , MAX(DECODE(CD,'2A020161001930149' ,'1' , '0'))       AS HINKETSU_KENSA_REASON_DETAIL        -- 094.貧血検査（実施理由）             存在するか否かで判定
                     , MAX(DECODE(CD,'9A110160700000011' ,VALUE_CD ,null )) AS SHINDENZU_SHOKEN_UMU_DETAIL         -- 095.心電図（所見の有無）             VALUE_CD
                     , MAX(DECODE(CD,'9A110160800000049' ,'1' , '0'))       AS SHINDENZU_SHOKEN_DETAIL             -- 096.心電図（所見）                   存在するか否かで判定
                     , MAX(DECODE(CD,'9A110161000000049' ,'1' , '0'))       AS SHINDENZU_REASON_DETAIL             -- 097.心電図（実施理由）               存在するか否かで判定
                     , MAX(DECODE(CD,'9E100166000000011' ,VALUE_CD ,null )) AS GANTEI_KENSA_KEITH_DETAIL           -- 098.眼底検査（キースワグナー分類）   VALUE_CD
                     , MAX(DECODE(CD,'9E100166100000011' ,VALUE_CD ,null )) AS GANTEI_KENSA_SCHEIE_H_DETAIL        -- 099.眼底検査（シェイエ分類：Ｈ）     VALUE_CD
                     , MAX(DECODE(CD,'9E100166200000011' ,VALUE_CD ,null )) AS GANTEI_KENSA_SCHEIE_S_DETAIL        -- 100.眼底検査（シェイエ分類：Ｓ）     VALUE_CD
                     , MAX(DECODE(CD,'9E100166300000011' ,VALUE_CD ,null )) AS GANTEI_KENSA_SCOTT_DETAIL           -- 101.眼底検査（ＳＣＯＴＴ分類)        VALUE_CD
                     , MAX(DECODE(CD,'9E100160900000049' ,'1' , '0'))       AS GANTEI_KENSA_SONOTA_SHOKEN_DE       -- 102.眼底検査（その他の所見）         存在するか否かで判定
                     , MAX(DECODE(CD,'9E100161000000049' ,'1' , '0'))       AS GANTEI_KENSA_REASON_DETAIL          -- 103.眼底検査（実施理由）             存在するか否かで判定
                   FROM TNDS_T_TOKKEN_DETAIL
                   GROUP BY SEQ1_NO ) DE
          ON  ( BA.SEQ1_NO
              = DE.SEQ1_NO )
  /* マスター紐づけ中間テーブル */
  LEFT OUTER JOIN TNDS_T_MSTLINK MSTLINK
                  ON ( SUBSTR(BA.MEE_YMD,1,6) = MSTLINK.APPL_YM )
  /* 都道府県ごとの人口（性・年齢階層別） */
  LEFT OUTER JOIN TNDS_M_POP_PER_TDFK M_POPT
                  ON ( SUBSTR(BA.MEE_INST_NO_ORG,1,2) = M_POPT.TDFK_CD
                   AND M_POPT.SEX = 0
                   AND MSTLINK.POP_PER_TDFK_GEN = M_POPT.MST_GEN )
  LEFT OUTER JOIN TNDS_T_AGE_DIV1 M_AGE01        -- 年齢階層区分テーブル１
                  ON  ( BA.AGE_HIER_CD1
                      = M_AGE01.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV2 M_AGE11        -- 年齢階層区分テーブル２
                  ON  ( BA.AGE_HIER_CD2
                      = M_AGE11.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV1 M_AGE02        -- 年齢階層区分テーブル１
                  ON  ( BA.LAST_BIRTH_AGE_HIER_CD1
                      = M_AGE02.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV2 M_AGE12        -- 年齢階層区分テーブル２
                  ON  ( BA.LAST_BIRTH_AGE_HIER_CD2
                      = M_AGE12.AGE_HIER_CODE )
  LEFT OUTER JOIN CMDS_M_SEX_DIV M_SEX           -- 男女区分マスター
                  ON  ( BA.TESTEE_SEX_CD
                      = M_SEX.SEX_DIV )
;
commit;
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_T_TOKKEN_VIEW_TABLE', degree => dbms_stats.auto_degree, cascade => true );



insert /*+ append */ into CMDS_T_THOKEN_VIEW_TABLE
  SELECT
  /*------------ 基本情報部 ------------*/
    BA.SEQ1_NO                         AS SEQ1_NO                          -- 001.通番１
  , BA.IDENT_CD                        AS IDENT_CD                         -- 002.識別コード
  , BA.INPUT_YM                        AS INPUT_YM                         -- 003.取込年月
  , BA.VLD_FLG                         AS VLD_FLG                          -- 004.有効フラグ
  , BA.ID1                             AS ID1                              -- 005.ID1
  , BA.ID1N                            AS ID1N                             -- 006.ID1n
  , BA.ID2                             AS ID2                              -- 007.ID2
  , BA.AGE                             AS AGE                              -- 008.年齢
  , BA.AGE_HIER_CD1                    AS AGE_HIER_CD1                     -- 009.年齢階層コード１
  , M_AGE01.AGE_HIER                   AS AGE_HIER1                        -- 010.年齢階層１
  , BA.AGE_HIER_CD2                    AS AGE_HIER_CD2                     -- 011.年齢階層コード２
  , M_AGE11.AGE_HIER                   AS AGE_HIER2                        -- 012.年齢階層２
  , BA.LAST_BIRTH_AGE                  AS LAST_BIRTH_AGE                   -- 013.満年齢
  , BA.LAST_BIRTH_AGE_HIER_CD1         AS LAST_BIRTH_AGE_HIER_CD1          -- 014.満年齢階層コード１
  , M_AGE02.AGE_HIER                   AS LAST_BIRTH_AGE_HIER1             -- 015.満年齢階層１
  , BA.LAST_BIRTH_AGE_HIER_CD2         AS LAST_BIRTH_AGE_HIER_CD2          -- 016.満年齢階層コード２
  , M_AGE12.AGE_HIER                   AS LAST_BIRTH_AGE_HIER2             -- 017.満年齢階層２
  , BA.USER_POST_NO                    AS USER_POST_NO                     -- 018.利用者・郵便番号
  , SUBSTR(BA.HGE_INST_NO_ORG,1,2)     AS TDFK                             -- 019.都道府県
  , M_POPT.TDFK_NAME                   AS TDFK_NAME                        -- 020.都道府県名
  , M_POPT.TTL_NUM                     AS TDFK_JINKOU                      -- 021.都道府県人口
  , BA.USER_SEX_CD                     AS USER_SEX_CD                      -- 022.利用者・性別コード
  , M_SEX.SEX_DIV_NAME                 AS USER_SEX_NAME                    -- 023.利用者・性別名
  , BA.USER_BIRTH_YM                   AS USER_BIRTH_YM                    -- 024.利用者・生年月
  , BA.CNSLT_TCKT_FACE_CLS             AS CNSLT_TCKT_FACE_CLS              -- 025.券面種別(受診券)
  , BA.CNSLT_TCKT_RFRNC_NO             AS CNSLT_TCKT_RFRNC_NO              -- 026.受診券整理番号
  , BA.USE_TCKT_FACE_CLS               AS USE_TCKT_FACE_CLS                -- 027.券面種別（利用券）
  , BA.USE_TCKT_RFRNC_NO               AS USE_TCKT_RFRNC_NO                -- 028.利用券整理番号
  , BA.HGE_PRG_CLS                     AS HGE_PRG_CLS                      -- 029.保健指導実施時のプログラム種別
  , BA.HGE_YMD                         AS HGE_YMD                          -- 030.保健指導実施年月日
  , SUBSTR(BA.HGE_YMD,1,6)             AS HGE_YM                           -- 031.保健指導実施年月
  , BA.HGE_NENDO                       AS HGE_NENDO                        -- 032.保健指導実施年度
  , BA.HG_PRG_NAME                     AS HG_PRG_NAME                      -- 033.保健指導プログラム名
  , BA.HGE_INST_NO_ORG                 AS HGE_INST_NO_ORG                  -- 034.保健指導実施機関番号
  , BA.HGE_INST_NO                     AS HGE_INST_NO                      -- 035.保健指導実施機関番号(匿名化後)
  , BA.INSURER_NO_ORG                  AS INSURER_NO_ORG                   -- 036.保険者情報（保険者番号）
  , BA.INSURER_NO_AFT                  AS INSURER_NO_AFT                   -- 037.保険者情報(補正後)
  , BA.INSURER_NO                      AS INSURER_NO                       -- 038.保険者番号(匿名化後)
  , BA.RPT_DIV                         AS RPT_DIV                          -- 039.報告区分
  , BA.QLFCT_DIV                       AS QLFCT_DIV                        -- 040.資格区分
  /*------------ 保健指導結果情報部 ------------*/
  , RE.SHIEN_LEVEL                     AS SHIEN_LEVEL                      -- 041.支援レベル
  , RE.KODOU_HENYOU_STAGE              AS KODOU_HENYOU_STAGE               -- 042.行動変容ステージ
  , SK.SHOKAI_MENSETSU_DATE            AS SHOKAI_MENSETSU_DATE             -- 043.初回面接の実施日付
  , SK.SHOKAI_MENSETSU_KEITAI          AS SHOKAI_MENSETSU_KEITAI           -- 044.初回面接による支援の支援形態
  , SK.SHOKAI_MENSETSU_TIME            AS SHOKAI_MENSETSU_TIME             -- 045.初回面接の実施時間
  , SK.SHOKAI_MENSETSU_JISSHISHA       AS SHOKAI_MENSETSU_JISSHISHA        -- 046.初回面接の実施者
  , RE.KEIZOKU_SHIEN_YOTEI_KIKAN       AS KEIZOKU_SHIEN_YOTEI_KIKAN        -- 047.継続的支援予定期間
  , RE.MOKUHYOU_HUKUI                  AS MOKUHYOU_HUKUI                   -- 048.目標腹囲
  , RE.MOKUHYOU_WEIGHT                 AS MOKUHYOU_WEIGHT                  -- 049.目標体重
  , RE.MOKUHYOU_SHUSHUKU_KETSUATSU     AS MOKUHYOU_SHUSHUKU_KETSUATSU      -- 050.目標収縮期血圧
  , RE.MOKUHYOU_KAKUCHOU_KETSUATSU     AS MOKUHYOU_KAKUCHOU_KETSUATSU      -- 051.目標拡張期血圧
  , RE.ONEDAY_SAKUGEN_M_ENERGY         AS ONEDAY_SAKUGEN_M_ENERGY          -- 052.一日の削減目標エネルギー量
  , RE.ONEDAY_UNDOU_M_ENERGY           AS ONEDAY_UNDOU_M_ENERGY            -- 053.一日の運動による目標エネルギー量
  , RE.ONEDAY_SHOKUJI_M_ENERGY         AS ONEDAY_SHOKUJI_M_ENERGY          -- 054.一日の食事による目標エネルギー量
  , CH.CHUKAN_DATE                     AS CHUKAN_DATE                      -- 055.中間評価の実施日付
  , CH.CHUKAN_SHIEN_KEITAI             AS CHUKAN_SHIEN_KEITAI              -- 056.中間評価の支援形態
  , CH.CHUKAN_TIME                     AS CHUKAN_TIME                      -- 057.中間評価の実施時間
  , CH.CHUKAN_POINT                    AS CHUKAN_POINT                     -- 058.中間評価の実施ポイント
  , CH.CHUKAN_JISSHISHA                AS CHUKAN_JISSHISHA                 -- 059.中間評価の実施者
  , CH.CHUKAN_HUKUI                    AS CHUKAN_HUKUI                     -- 060.中間評価時の腹囲
  , CH.CHUKAN_WEIGHT                   AS CHUKAN_WEIGHT                    -- 061.中間評価時の体重
  , CH.CHUKAN_SHUSHUKU_KETSUATSU       AS CHUKAN_SHUSHUKU_KETSUATSU        -- 062.中間評価時の収縮期血圧
  , CH.CHUKAN_KAKUCHO_KETSUATSU        AS CHUKAN_KAKUCHO_KETSUATSU         -- 063.中間評価時の拡張期血圧
  , CH.CHUKAN_S_KAIZEN_EIYOU           AS CHUKAN_S_KAIZEN_EIYOU            -- 064.中間評価時の生活習慣の改善（栄養・食生活）
  , CH.CHUKAN_S_KAIZEN_SHINTAI         AS CHUKAN_S_KAIZEN_SHINTAI          -- 065.中間評価時の生活習慣の改善（身体活動）
  , CH.CHUKAN_S_KAIZEN_KITSUEN         AS CHUKAN_S_KAIZEN_KITSUEN          -- 066.中間評価時の生活習慣の改善（喫煙）
  , AA.SHIEN_A_1_DATE                  AS SHIEN_A_1_DATE                   -- 067.支援Ａ①の実施日付
  , AA.SHIEN_A_1_SHIEN_KEITAI          AS SHIEN_A_1_SHIEN_KEITAI           -- 068.支援Ａ①の支援形態
  , AA.SHIEN_A_1_TIME                  AS SHIEN_A_1_TIME                   -- 069.支援Ａ①の実施時間
  , AA.SHIEN_A_1_POINT                 AS SHIEN_A_1_POINT                  -- 070.支援Ａ①の実施ポイント
  , AA.SHIEN_A_1_JISSHISHA             AS SHIEN_A_1_JISSHISHA              -- 071.支援Ａ①の実施者
  , AA.SHIEN_A_2_DATE                  AS SHIEN_A_2_DATE                   -- 072.支援Ａ②の実施日付
  , AA.SHIEN_A_2_SHIEN_KEITAI          AS SHIEN_A_2_SHIEN_KEITAI           -- 073.支援Ａ②の支援形態
  , AA.SHIEN_A_2_TIME                  AS SHIEN_A_2_TIME                   -- 074.支援Ａ②の実施時間
  , AA.SHIEN_A_2_POINT                 AS SHIEN_A_2_POINT                  -- 075.支援Ａ②の実施ポイント
  , AA.SHIEN_A_2_JISSHISHA             AS SHIEN_A_2_JISSHISHA              -- 076.支援Ａ②の実施者
  , AA.SHIEN_A_3_DATE                  AS SHIEN_A_3_DATE                   -- 077.支援Ａ③の実施日付
  , AA.SHIEN_A_3_SHIEN_KEITAI          AS SHIEN_A_3_SHIEN_KEITAI           -- 078.支援Ａ③の支援形態
  , AA.SHIEN_A_3_TIME                  AS SHIEN_A_3_TIME                   -- 079.支援Ａ③の実施時間
  , AA.SHIEN_A_3_POINT                 AS SHIEN_A_3_POINT                  -- 080.支援Ａ③の実施ポイント
  , AA.SHIEN_A_3_JISSHISHA             AS SHIEN_A_3_JISSHISHA              -- 081.支援Ａ③の実施者
  , AA.SHIEN_A_4_DATE                  AS SHIEN_A_4_DATE                   -- 082.支援Ａ④の実施日付
  , AA.SHIEN_A_4_SHIEN_KEITAI          AS SHIEN_A_4_SHIEN_KEITAI           -- 083.支援Ａ④の支援形態
  , AA.SHIEN_A_4_TIME                  AS SHIEN_A_4_TIME                   -- 084.支援Ａ④の実施時間
  , AA.SHIEN_A_4_POINT                 AS SHIEN_A_4_POINT                  -- 085.支援Ａ④の実施ポイント
  , AA.SHIEN_A_4_JISSHISHA             AS SHIEN_A_4_JISSHISHA              -- 086.支援Ａ④の実施者
  , AA.SHIEN_A_5_DATE                  AS SHIEN_A_5_DATE                   -- 087.支援Ａ⑤の実施日付
  , AA.SHIEN_A_5_SHIEN_KEITAI          AS SHIEN_A_5_SHIEN_KEITAI           -- 088.支援Ａ⑤の支援形態
  , AA.SHIEN_A_5_TIME                  AS SHIEN_A_5_TIME                   -- 089.支援Ａ⑤の実施時間
  , AA.SHIEN_A_5_POINT                 AS SHIEN_A_5_POINT                  -- 090.支援Ａ⑤の実施ポイント
  , AA.SHIEN_A_5_JISSHISHA             AS SHIEN_A_5_JISSHISHA              -- 091.支援Ａ⑤の実施者
  , AA.SHIEN_A_6_DATE                  AS SHIEN_A_6_DATE                   -- 092.支援Ａ⑥の実施日付
  , AA.SHIEN_A_6_SHIEN_KEITAI          AS SHIEN_A_6_SHIEN_KEITAI           -- 093.支援Ａ⑥の支援形態
  , AA.SHIEN_A_6_TIME                  AS SHIEN_A_6_TIME                   -- 094.支援Ａ⑥の実施時間
  , AA.SHIEN_A_6_POINT                 AS SHIEN_A_6_POINT                  -- 095.支援Ａ⑥の実施ポイント
  , AA.SHIEN_A_6_JISSHISHA             AS SHIEN_A_6_JISSHISHA              -- 096.支援Ａ⑥の実施者
  , BB.SHIEN_B_1_DATE                  AS SHIEN_B_1_DATE                   -- 097.支援Ｂ①の実施日付
  , BB.SHIEN_B_1_SHIEN_KEITAI          AS SHIEN_B_1_SHIEN_KEITAI           -- 098.支援Ｂ①の支援形態
  , BB.SHIEN_B_1_TIME                  AS SHIEN_B_1_TIME                   -- 099.支援Ｂ①の実施時間
  , BB.SHIEN_B_1_POINT                 AS SHIEN_B_1_POINT                  -- 100.支援Ｂ①の実施ポイント
  , BB.SHIEN_B_1_JISSHISHA             AS SHIEN_B_1_JISSHISHA              -- 101.支援Ｂ①の実施者
  , BB.SHIEN_B_2_DATE                  AS SHIEN_B_2_DATE                   -- 102.支援Ｂ②の実施日付
  , BB.SHIEN_B_2_SHIEN_KEITAI          AS SHIEN_B_2_SHIEN_KEITAI           -- 103.支援Ｂ②の支援形態
  , BB.SHIEN_B_2_TIME                  AS SHIEN_B_2_TIME                   -- 104.支援Ｂ②の実施時間
  , BB.SHIEN_B_2_POINT                 AS SHIEN_B_2_POINT                  -- 105.支援Ｂ②の実施ポイント
  , BB.SHIEN_B_2_JISSHISHA             AS SHIEN_B_2_JISSHISHA              -- 106.支援Ｂ②の実施者
  , BB.SHIEN_B_3_DATE                  AS SHIEN_B_3_DATE                   -- 107.支援Ｂ③の実施日付
  , BB.SHIEN_B_3_SHIEN_KEITAI          AS SHIEN_B_3_SHIEN_KEITAI           -- 108.支援Ｂ③の支援形態
  , BB.SHIEN_B_3_TIME                  AS SHIEN_B_3_TIME                   -- 109.支援Ｂ③の実施時間
  , BB.SHIEN_B_3_POINT                 AS SHIEN_B_3_POINT                  -- 110.支援Ｂ③の実施ポイント
  , BB.SHIEN_B_3_JISSHISHA             AS SHIEN_B_3_JISSHISHA              -- 111.支援Ｂ③の実施者
  , BB.SHIEN_B_4_DATE                  AS SHIEN_B_4_DATE                   -- 112.支援Ｂ④の実施日付
  , BB.SHIEN_B_4_SHIEN_KEITAI          AS SHIEN_B_4_SHIEN_KEITAI           -- 113.支援Ｂ④の支援形態
  , BB.SHIEN_B_4_TIME                  AS SHIEN_B_4_TIME                   -- 114.支援Ｂ④の実施時間
  , BB.SHIEN_B_4_POINT                 AS SHIEN_B_4_POINT                  -- 115.支援Ｂ④の実施ポイント
  , BB.SHIEN_B_4_JISSHISHA             AS SHIEN_B_4_JISSHISHA              -- 116.支援Ｂ④の実施者
  , SA.SIX_MONTH_H_DATE                AS SIX_MONTH_H_DATE                 -- 117.６ヶ月後の評価の実施日付
  , SA.SIX_MONTH_H_SHIEN_KAKUNIN       AS SIX_MONTH_H_SHIEN_KAKUNIN        -- 118.６ヶ月後の評価の支援形態又は確認方法
  , SA.SIX_MONTH_H_JISSHISHA           AS SIX_MONTH_H_JISSHISHA            -- 119.６ヶ月後の評価の実施者
  , SA.SIX_MONTH_H_NOT_KAKUNIN         AS SIX_MONTH_H_NOT_KAKUNIN          -- 120.６ヶ月後の評価ができない場合の確認回数
  , SA.SIX_MONTH_H_HUKUI               AS SIX_MONTH_H_HUKUI                -- 121.６ヶ月後の評価時の腹囲
  , SA.SIX_MONTH_H_WEIGHT              AS SIX_MONTH_H_WEIGHT               -- 122.６ヶ月後の評価時の体重
  , SA.SIX_MONTH_H_SHUSHUKU_KETSUATSU  AS SIX_MONTH_H_SHUSHUKU_KETSUATSU   -- 123.６ヶ月後の評価時の収縮期血圧
  , SA.SIX_MONTH_H_KAKUCHOU_KETSUATSU  AS SIX_MONTH_H_KAKUCHOU_KETSUATSU   -- 124.６ヶ月後の評価時の拡張期血圧
  , SA.SIX_MONTH_H_HOKEN_EIYOU         AS SIX_MONTH_H_HOKEN_EIYOU          -- 125.６ヶ月後の評価時の保健指導による生活習慣の改善（栄養・食生活）
  , SA.SIX_MONTH_H_HOKEN_SHINTAI       AS SIX_MONTH_H_HOKEN_SHINTAI        -- 126.６ヶ月後の評価時の保健指導による生活習慣の改善（身体活動）
  , SA.SIX_MONTH_H_HOKEN_KITSUEN       AS SIX_MONTH_H_HOKEN_KITSUEN        -- 127.６ヶ月後の評価時の保健指導による生活習慣の改善（喫煙）
  , RE.KEIKAKU_SHIEN_TIMES             AS KEIKAKU_SHIEN_TIMES              -- 128.計画上の継続的な支援の実施回数
  , RE.KEIKAKU_TIMES_KOBETSU_A         AS KEIKAKU_TIMES_KOBETSU_A          -- 129.計画上の継続的な支援の実施回数（個別支援A）
  , RE.KEIKAKU_TOTAL_TIME_A            AS KEIKAKU_TOTAL_TIME_A             -- 130.計画上の継続的な支援の合計実施時間（個別支援A）
  , RE.KEIKAKU_TIMES_KOBETSU_B         AS KEIKAKU_TIMES_KOBETSU_B          -- 131.計画上の継続的な支援の実施回数（個別支援B）
  , RE.KEIKAKU_TOTAL_TIME_B            AS KEIKAKU_TOTAL_TIME_B             -- 132.計画上の継続的な支援の合計実施時間（個別支援B）
  , RE.KEIKAKU_TIMES_GROUP             AS KEIKAKU_TIMES_GROUP              -- 133.計画上の継続的な支援の実施回数（グループ支援）
  , RE.KEIKAKU_TOTAL_TIME_GROUP        AS KEIKAKU_TOTAL_TIME_GROUP         -- 134.計画上の継続的な支援の合計実施時間（グループ支援）
  , RE.KEIKAKU_TIMES_TEL_A             AS KEIKAKU_TIMES_TEL_A              -- 135.計画上の継続的な支援の実施回数（電話Aによる支援）
  , RE.KEIKAKU_TOTAL_TIME_TEL_A        AS KEIKAKU_TOTAL_TIME_TEL_A         -- 136.計画上の継続的な支援の合計実施時間（電話Aによる支援）
  , RE.KEIKAKU_TIMES_MAIL_A            AS KEIKAKU_TIMES_MAIL_A             -- 137.計画上の継続的な支援の実施回数（e-mailAによる支援）
  , RE.KEIKAKU_TIMES_TEL_B             AS KEIKAKU_TIMES_TEL_B              -- 138.計画上の継続的な支援の実施回数（電話Bによる支援）
  , RE.KEIKAKU_TOTAL_TIME_TEL_B        AS KEIKAKU_TOTAL_TIME_TEL_B         -- 139.計画上の継続的な支援の合計実施時間（電話Bによる支援）
  , RE.KEIKAKU_TIMES_MAIL_B            AS KEIKAKU_TIMES_MAIL_B             -- 140.計画上の継続的な支援の実施回数（e-mailBによる支援）
  , RE.KEIKAKU_POINT_SHIEN_A           AS KEIKAKU_POINT_SHIEN_A            -- 141.計画上の継続的な支援によるポイント（支援A)
  , RE.KEIKAKU_POINT_SHIEN_B           AS KEIKAKU_POINT_SHIEN_B            -- 142.計画上の継続的な支援によるポイント（支援B)
  , RE.KEIKAKU_POINT_SHIEN_TOTAL       AS KEIKAKU_POINT_SHIEN_TOTAL        -- 143.計画上の継続的な支援によるポイント（合計)
  , RE.JISSHI_TIMES                    AS JISSHI_TIMES                     -- 144.実施上の継続的な支援の実施回数
  , RE.JISSHI_TIMES_KOBETSU_A          AS JISSHI_TIMES_KOBETSU_A           -- 145.実施上の継続的な支援の実施回数（個別支援A）
  , RE.JISSHI_TOTAL_TIME_KOBETSU_A     AS JISSHI_TOTAL_TIME_KOBETSU_A      -- 146.実施上の継続的な支援の合計実施時間（個別支援A）
  , RE.JISSHI_TIMES_KOBETSU_B          AS JISSHI_TIMES_KOBETSU_B           -- 147.実施上の継続的な支援の実施回数（個別支援B）
  , RE.JISSHI_TOTAL_TIME_KOBETSU_B     AS JISSHI_TOTAL_TIME_KOBETSU_B      -- 148.実施上の継続的な支援の合計実施時間（個別支援B）
  , RE.JISSHI_TIMES_TIMES_GROUP        AS JISSHI_TIMES_TIMES_GROUP         -- 149.実施上の継続的な支援の実施回数（グループ支援）
  , RE.JISSHI_TOTAL_TIME_GROUP         AS JISSHI_TOTAL_TIME_GROUP          -- 150.実施上の継続的な支援の合計実施時間（グループ支援）
  , RE.JISSHI_TIMES_TEL_A              AS JISSHI_TIMES_TEL_A               -- 151.実施上の継続的な支援の実施回数（電話Aによる支援）
  , RE.JISSHI_TOTAL_TIME_TEL_A         AS JISSHI_TOTAL_TIME_TEL_A          -- 152.実施上の継続的な支援の合計実施時間（電話Aによる支援）
  , RE.JISSHI_TIMES_MAIL_A             AS JISSHI_TIMES_MAIL_A              -- 153.実施上の継続的な支援の実施回数（e-mailAによる支援）
  , RE.JISSHI_TIMES_TEL_B              AS JISSHI_TIMES_TEL_B               -- 154.実施上の継続的な支援の実施回数（電話Bによる支援）
  , RE.JISSHI_TOTAL_TIME_TEL_B         AS JISSHI_TOTAL_TIME_TEL_B          -- 155.実施上の継続的な支援の合計実施時間（電話Bによる支援）
  , RE.JISSHI_TIMES_MAIL_B             AS JISSHI_TIMES_MAIL_B              -- 156.実施上の継続的な支援の実施回数（e-mailBによる支援）
  , RE.KEIZOKU_SHIEN_POINT_A           AS KEIZOKU_SHIEN_POINT_A            -- 157.継続的な支援によるポイント（支援A)
  , RE.KEIZOKU_SHIEN_POINT_B           AS KEIZOKU_SHIEN_POINT_B            -- 158.継続的な支援によるポイント（支援B)
  , RE.KEIZOKU_SHIEN_POINT_TOTAL       AS KEIZOKU_SHIEN_POINT_TOTAL        -- 159.継続的な支援によるポイント（合計)
  , RE.KITSUEN_TIMES                   AS KITSUEN_TIMES                    -- 160.禁煙指導の実施回数
  , RE.JISSHI_SHIEN_END_DATE           AS JISSHI_SHIEN_END_DATE            -- 161.実施上の継続的な支援の終了日
  , IT.ITAKU_HOKEN_KIKAN_NO_1          AS ITAKU_HOKEN_KIKAN_NO_1           -- 162.委託先保健指導機関番号(1)
  , IT.ITAKU_HOKEN_KIKAN_NO_2          AS ITAKU_HOKEN_KIKAN_NO_2           -- 163.委託先保健指導機関番号(2)
  , IT.ITAKU_HOKEN_KIKAN_NO_3          AS ITAKU_HOKEN_KIKAN_NO_3           -- 164.委託先保健指導機関番号(3)
  , IT.ITAKU_HOKEN_KIKAN_NO_4          AS ITAKU_HOKEN_KIKAN_NO_4           -- 165.委託先保健指導機関番号(4)
  FROM
  /* 基本情報レコード（保健指導） */
            TNDS_T_THOKEN_BASE BA
  /* 健診結果・問診結果情報レコード（保健指導） */
  LEFT OUTER JOIN (
                   SELECT
                       SEQ1_NO                                   AS SEQ1_NO                         -- 001.通番１
                     , MAX(DECODE(CD,'1020000001' ,CNTNT ))      AS SHIEN_LEVEL                     -- 041.支援レベル
                     , MAX(DECODE(CD,'1020000002' ,CNTNT ))      AS KODOU_HENYOU_STAGE              -- 042.行動変容ステージ
                     , MAX(DECODE(CD,'1021000020' ,VAL ))        AS KEIZOKU_SHIEN_YOTEI_KIKAN       -- 047.継続的支援予定期間
                     , MAX(DECODE(CD,'1021001031' ,VAL ))        AS MOKUHYOU_HUKUI                  -- 048.目標腹囲
                     , MAX(DECODE(CD,'1021001032' ,VAL ))        AS MOKUHYOU_WEIGHT                 -- 049.目標体重
                     , MAX(DECODE(CD,'1021001033' ,VAL ))        AS MOKUHYOU_SHUSHUKU_KETSUATSU     -- 050.目標収縮期血圧
                     , MAX(DECODE(CD,'1021001034' ,VAL ))        AS MOKUHYOU_KAKUCHOU_KETSUATSU     -- 051.目標拡張期血圧
                     , MAX(DECODE(CD,'1021001050' ,VAL ))        AS ONEDAY_SAKUGEN_M_ENERGY         -- 052.一日の削減目標エネルギー量
                     , MAX(DECODE(CD,'1021001051' ,VAL ))        AS ONEDAY_UNDOU_M_ENERGY           -- 053.一日の運動による目標エネルギー量
                     , MAX(DECODE(CD,'1021001052' ,VAL ))        AS ONEDAY_SHOKUJI_M_ENERGY         -- 054.一日の食事による目標エネルギー量
                     , MAX(DECODE(CD,'1041800117' ,VAL ))        AS KEIKAKU_SHIEN_TIMES             -- 128.計画上の継続的な支援の実施回数
                     , MAX(DECODE(CD,'1041101117' ,VAL ))        AS KEIKAKU_TIMES_KOBETSU_A         -- 129.計画上の継続的な支援の実施回数（個別支援A）
                     , MAX(DECODE(CD,'1041101113' ,VAL ))        AS KEIKAKU_TOTAL_TIME_A            -- 130.計画上の継続的な支援の合計実施時間（個別支援A）
                     , MAX(DECODE(CD,'1041201117' ,VAL ))        AS KEIKAKU_TIMES_KOBETSU_B         -- 131.計画上の継続的な支援の実施回数（個別支援B）
                     , MAX(DECODE(CD,'1041201113' ,VAL ))        AS KEIKAKU_TOTAL_TIME_B            -- 132.計画上の継続的な支援の合計実施時間（個別支援B）
                     , MAX(DECODE(CD,'1041302117' ,VAL ))        AS KEIKAKU_TIMES_GROUP             -- 133.計画上の継続的な支援の実施回数（グループ支援）
                     , MAX(DECODE(CD,'1041302113' ,VAL ))        AS KEIKAKU_TOTAL_TIME_GROUP        -- 134.計画上の継続的な支援の合計実施時間（グループ支援）
                     , MAX(DECODE(CD,'1041103117' ,VAL ))        AS KEIKAKU_TIMES_TEL_A             -- 135.計画上の継続的な支援の実施回数（電話Aによる支援）
                     , MAX(DECODE(CD,'1041103113' ,VAL ))        AS KEIKAKU_TOTAL_TIME_TEL_A        -- 136.計画上の継続的な支援の合計実施時間（電話Aによる支援）
                     , MAX(DECODE(CD,'1041104117' ,VAL ))        AS KEIKAKU_TIMES_MAIL_A            -- 137.計画上の継続的な支援の実施回数（e-mailAによる支援）
                     , MAX(DECODE(CD,'1041203117' ,VAL ))        AS KEIKAKU_TIMES_TEL_B             -- 138.計画上の継続的な支援の実施回数（電話Bによる支援）
                     , MAX(DECODE(CD,'1041203113' ,VAL ))        AS KEIKAKU_TOTAL_TIME_TEL_B        -- 139.計画上の継続的な支援の合計実施時間（電話Bによる支援）
                     , MAX(DECODE(CD,'1041204117' ,VAL ))        AS KEIKAKU_TIMES_MAIL_B            -- 140.計画上の継続的な支援の実施回数（e-mailBによる支援）
                     , MAX(DECODE(CD,'1041100114' ,VAL ))        AS KEIKAKU_POINT_SHIEN_A           -- 141.計画上の継続的な支援によるポイント（支援A)
                     , MAX(DECODE(CD,'1041200114' ,VAL ))        AS KEIKAKU_POINT_SHIEN_B           -- 142.計画上の継続的な支援によるポイント（支援B)
                     , MAX(DECODE(CD,'1041800114' ,VAL ))        AS KEIKAKU_POINT_SHIEN_TOTAL       -- 143.計画上の継続的な支援によるポイント（合計)
                     , MAX(DECODE(CD,'1042800117' ,VAL ))        AS JISSHI_TIMES                    -- 144.実施上の継続的な支援の実施回数
                     , MAX(DECODE(CD,'1042101117' ,VAL ))        AS JISSHI_TIMES_KOBETSU_A          -- 145.実施上の継続的な支援の実施回数（個別支援A）
                     , MAX(DECODE(CD,'1042101113' ,VAL ))        AS JISSHI_TOTAL_TIME_KOBETSU_A     -- 146.実施上の継続的な支援の合計実施時間（個別支援A）
                     , MAX(DECODE(CD,'1042201117' ,VAL ))        AS JISSHI_TIMES_KOBETSU_B          -- 147.実施上の継続的な支援の実施回数（個別支援B）
                     , MAX(DECODE(CD,'1042201113' ,VAL ))        AS JISSHI_TOTAL_TIME_KOBETSU_B     -- 148.実施上の継続的な支援の合計実施時間（個別支援B）
                     , MAX(DECODE(CD,'1042302117' ,VAL ))        AS JISSHI_TIMES_TIMES_GROUP        -- 149.実施上の継続的な支援の実施回数（グループ支援）
                     , MAX(DECODE(CD,'1042302113' ,VAL ))        AS JISSHI_TOTAL_TIME_GROUP         -- 150.実施上の継続的な支援の合計実施時間（グループ支援）
                     , MAX(DECODE(CD,'1042103117' ,VAL ))        AS JISSHI_TIMES_TEL_A              -- 151.実施上の継続的な支援の実施回数（電話Aによる支援）
                     , MAX(DECODE(CD,'1042103113' ,VAL ))        AS JISSHI_TOTAL_TIME_TEL_A         -- 152.実施上の継続的な支援の合計実施時間（電話Aによる支援）
                     , MAX(DECODE(CD,'1042104117' ,VAL ))        AS JISSHI_TIMES_MAIL_A             -- 153.実施上の継続的な支援の実施回数（e-mailAによる支援）
                     , MAX(DECODE(CD,'1042203117' ,VAL ))        AS JISSHI_TIMES_TEL_B              -- 154.実施上の継続的な支援の実施回数（電話Bによる支援）
                     , MAX(DECODE(CD,'1042203113' ,VAL ))        AS JISSHI_TOTAL_TIME_TEL_B         -- 155.実施上の継続的な支援の合計実施時間（電話Bによる支援）
                     , MAX(DECODE(CD,'1042204117' ,VAL ))        AS JISSHI_TIMES_MAIL_B             -- 156.実施上の継続的な支援の実施回数（e-mailBによる支援）
                     , MAX(DECODE(CD,'1042100114' ,VAL ))        AS KEIZOKU_SHIEN_POINT_A           -- 157.継続的な支援によるポイント（支援A)
                     , MAX(DECODE(CD,'1042200114' ,VAL ))        AS KEIZOKU_SHIEN_POINT_B           -- 158.継続的な支援によるポイント（支援B)
                     , MAX(DECODE(CD,'1042800114' ,VAL ))        AS KEIZOKU_SHIEN_POINT_TOTAL       -- 159.継続的な支援によるポイント（合計)
                     , MAX(DECODE(CD,'1042800118' ,VAL ))        AS KITSUEN_TIMES                   -- 160.禁煙指導の実施回数
                     , MAX(DECODE(CD,'1042000022' ,VALUE ))      AS JISSHI_SHIEN_END_DATE           -- 161.実施上の継続的な支援の終了日
                   FROM TNDS_T_THOKEN_RESULT
                   WHERE
                     CD IN
                   (  '1020000001'
                     ,'1020000002'
                     ,'1020000003'
                     ,'1021000020'
                     ,'1021001031'
                     ,'1021001032'
                     ,'1021001033'
                     ,'1021001034'
                     ,'1021001050'
                     ,'1021001051'
                     ,'1021001052'
                     ,'1041800117'
                     ,'1041101117'
                     ,'1041101113'
                     ,'1041201117'
                     ,'1041201113'
                     ,'1041302117'
                     ,'1041302113'
                     ,'1041103117'
                     ,'1041103113'
                     ,'1041104117'
                     ,'1041203117'
                     ,'1041203113'
                     ,'1041204117'
                     ,'1041100114'
                     ,'1041200114'
                     ,'1041800114'
                     ,'1042800117'
                     ,'1042101117'
                     ,'1042101113'
                     ,'1042201117'
                     ,'1042201113'
                     ,'1042302117'
                     ,'1042302113'
                     ,'1042103117'
                     ,'1042103113'
                     ,'1042104117'
                     ,'1042203117'
                     ,'1042203113'
                     ,'1042204117'
                     ,'1042100114'
                     ,'1042200114'
                     ,'1042800114'
                     ,'1042800118'
                     ,'1042000022'
                   )
                   GROUP BY SEQ1_NO
                  ) RE
          ON  ( BA.SEQ1_NO
              = RE.SEQ1_NO )
  /* セクションコード90030：指導初回情報セクション */
  LEFT OUTER JOIN (
                   SELECT
                       SE.SEQ1_NO                AS SEQ1_NO                         -- 001.通番１
                     , MAX(EN.OPRTN_YMD)         AS SHOKAI_MENSETSU_DATE            -- 043.初回面接の実施日付
                     , MAX(EN.FORM_CD)           AS SHOKAI_MENSETSU_KEITAI          -- 044.初回面接による支援の支援形態
                     , MAX(RE.TIME_VAL)          AS SHOKAI_MENSETSU_TIME            -- 045.初回面接の実施時間
                     , MAX(EN.EFRCR_CD)          AS SHOKAI_MENSETSU_JISSHISHA       -- 046.初回面接の実施者
                   FROM
                    TNDS_T_THOKEN_SEC SE  -- セクションテーブル
                     INNER JOIN TNDS_T_THOKEN_ENTRY EN  -- エントリーテーブル
                     ON  ( SE.SEC_CD  = '90030'
                      AND  SE.SEQ1_NO = EN.SEQ1_NO
                      AND  SE.SEQ2_NO = SUBSTR( EN.SEQ2_NO,1,2) || N'0000' )
                     LEFT OUTER JOIN TNDS_T_THOKEN_RESULT RE  -- 詳細テーブル
                     ON  ( RE.CD  = '1022000013'
                      AND  EN.SEQ1_NO = RE.SEQ1_NO
                      AND  EN.SEQ2_NO = SUBSTR( RE.SEQ2_NO,1,4) || N'00' )
                   GROUP BY
                      SE.SEQ1_NO
                  ) SK
          ON  ( BA.SEQ1_NO
              = SK.SEQ1_NO )
  /* セクションコード90050：中間評価情報セクション */
  LEFT OUTER JOIN (
                   SELECT
                       SE.SEQ1_NO                                      AS SEQ1_NO                   -- 001.通番１
                     , MAX(EN.OPRTN_YMD)                               AS CHUKAN_DATE               -- 055.中間評価の実施日付
                     , MAX(EN.FORM_CD)                                 AS CHUKAN_SHIEN_KEITAI       -- 056.中間評価の支援形態
                     , MAX(DECODE(RE.CD,'1032000013',RE.TIME_VAL ))    AS CHUKAN_TIME               -- 057.中間評価の実施時間
                     , MAX(DECODE(RE.CD,'1032000014',RE.VAL ))         AS CHUKAN_POINT              -- 058.中間評価の実施ポイント
                     , MAX(EN.EFRCR_CD)                                AS CHUKAN_JISSHISHA          -- 059.中間評価の実施者
                     , MAX(DECODE(RE.CD,'1032001031',RE.VAL ))         AS CHUKAN_HUKUI              -- 060.中間評価時の腹囲
                     , MAX(DECODE(RE.CD,'1032001032',RE.VAL ))         AS CHUKAN_WEIGHT             -- 061.中間評価時の体重
                     , MAX(DECODE(RE.CD,'1032001033',RE.VAL ))         AS CHUKAN_SHUSHUKU_KETSUATSU -- 062.中間評価時の収縮期血圧
                     , MAX(DECODE(RE.CD,'1032001034',RE.VAL ))         AS CHUKAN_KAKUCHO_KETSUATSU  -- 063.中間評価時の拡張期血圧
                     , MAX(DECODE(RE.CD,'1032001042',RE.CNTNT ))       AS CHUKAN_S_KAIZEN_EIYOU     -- 064.中間評価時の生活習慣の改善（栄養・食生活）
                     , MAX(DECODE(RE.CD,'1032001041',RE.CNTNT ))       AS CHUKAN_S_KAIZEN_SHINTAI   -- 065.中間評価時の生活習慣の改善（身体活動）
                     , MAX(DECODE(RE.CD,'1032001043',RE.CNTNT ))       AS CHUKAN_S_KAIZEN_KITSUEN   -- 066.中間評価時の生活習慣の改善（喫煙）
                   FROM
                    TNDS_T_THOKEN_SEC SE  -- セクションテーブル
                     INNER JOIN TNDS_T_THOKEN_ENTRY EN  -- エントリーテーブル
                     ON  ( SE.SEC_CD  = '90050'
                      AND  SE.SEQ1_NO = EN.SEQ1_NO
                      AND  SE.SEQ2_NO = SUBSTR( EN.SEQ2_NO,1,2) || N'0000' )
                     LEFT OUTER JOIN TNDS_T_THOKEN_RESULT RE  -- 詳細テーブル
                     ON  ( 
                           RE.CD IN (
                             '1032000013'
                            ,'1032000014'
                            ,'1032001031'
                            ,'1032001032'
                            ,'1032001033'
                            ,'1032001034'
                            ,'1032001042'
                            ,'1032001041'
                            ,'1032001043')
                      AND  EN.SEQ1_NO = RE.SEQ1_NO
                      AND  EN.SEQ2_NO = SUBSTR( RE.SEQ2_NO,1,4) || N'00' )
                   GROUP BY
                      SE.SEQ1_NO
                  ) CH
          ON  ( BA.SEQ1_NO
              = CH.SEQ1_NO )
  /* セクションコード90040：支援Ａ */
   LEFT OUTER JOIN (
                    SELECT 
                       SEQ1_NO                                                        AS SEQ1_NO                -- 001.通番１
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_DATE))                           AS SHIEN_A_1_DATE         -- 067.支援Ａ①の実施日付
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_KEITAI))                         AS SHIEN_A_1_SHIEN_KEITAI -- 068.支援Ａ①の支援形態
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_TIME))                           AS SHIEN_A_1_TIME         -- 069.支援Ａ①の実施時間
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_POINT))                          AS SHIEN_A_1_POINT        -- 070.支援Ａ①の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_JISSHISHA))                      AS SHIEN_A_1_JISSHISHA    -- 071.支援Ａ①の実施者
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_DATE))                           AS SHIEN_A_2_DATE         -- 072.支援Ａ②の実施日付
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_KEITAI))                         AS SHIEN_A_2_SHIEN_KEITAI -- 073.支援Ａ②の支援形態
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_TIME))                           AS SHIEN_A_2_TIME         -- 074.支援Ａ②の実施時間
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_POINT))                          AS SHIEN_A_2_POINT        -- 075.支援Ａ②の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_JISSHISHA))                      AS SHIEN_A_2_JISSHISHA    -- 076.支援Ａ②の実施者
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_DATE))                           AS SHIEN_A_3_DATE         -- 077.支援Ａ③の実施日付
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_KEITAI))                         AS SHIEN_A_3_SHIEN_KEITAI -- 078.支援Ａ③の支援形態
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_TIME))                           AS SHIEN_A_3_TIME         -- 079.支援Ａ③の実施時間
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_POINT))                          AS SHIEN_A_3_POINT        -- 080.支援Ａ③の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_JISSHISHA))                      AS SHIEN_A_3_JISSHISHA    -- 081.支援Ａ③の実施者
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_DATE))                           AS SHIEN_A_4_DATE         -- 082.支援Ａ④の実施日付
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_KEITAI))                         AS SHIEN_A_4_SHIEN_KEITAI -- 083.支援Ａ④の支援形態
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_TIME))                           AS SHIEN_A_4_TIME         -- 084.支援Ａ④の実施時間
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_POINT))                          AS SHIEN_A_4_POINT        -- 085.支援Ａ④の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_JISSHISHA))                      AS SHIEN_A_4_JISSHISHA    -- 086.支援Ａ④の実施者
                     , MAX(DECODE(SHIEN_RANK,5,SHIEN_DATE))                           AS SHIEN_A_5_DATE         -- 087.支援Ａ⑤の実施日付
                     , MAX(DECODE(SHIEN_RANK,5,SHIEN_KEITAI))                         AS SHIEN_A_5_SHIEN_KEITAI -- 088.支援Ａ⑤の支援形態
                     , MAX(DECODE(SHIEN_RANK,5,SHIEN_TIME))                           AS SHIEN_A_5_TIME         -- 089.支援Ａ⑤の実施時間
                     , MAX(DECODE(SHIEN_RANK,5,SHIEN_POINT))                          AS SHIEN_A_5_POINT        -- 090.支援Ａ⑤の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,5,SHIEN_JISSHISHA))                      AS SHIEN_A_5_JISSHISHA    -- 091.支援Ａ⑤の実施者
                     , MAX(DECODE(SHIEN_RANK,6,SHIEN_DATE))                           AS SHIEN_A_6_DATE         -- 092.支援Ａ⑥の実施日付
                     , MAX(DECODE(SHIEN_RANK,6,SHIEN_KEITAI))                         AS SHIEN_A_6_SHIEN_KEITAI -- 093.支援Ａ⑥の支援形態
                     , MAX(DECODE(SHIEN_RANK,6,SHIEN_TIME))                           AS SHIEN_A_6_TIME         -- 094.支援Ａ⑥の実施時間
                     , MAX(DECODE(SHIEN_RANK,6,SHIEN_POINT))                          AS SHIEN_A_6_POINT        -- 095.支援Ａ⑥の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,6,SHIEN_JISSHISHA))                      AS SHIEN_A_6_JISSHISHA    -- 096.支援Ａ⑥の実施者
                   FROM (
                         SELECT
                             EN.SEQ1_NO                                               AS SEQ1_NO         -- 通番１
                           , EN.SEQ2_NO                                               AS SEQ2_NO         -- 通番２
                           , RANK() OVER(PARTITION BY EN.SEQ1_NO ORDER BY EN.SEQ2_NO) AS SHIEN_RANK      -- 同一通番１内で通番２昇順に並び替えランクづけする
                           , MAX(EN.OPRTN_YMD)                                        AS SHIEN_DATE      -- 実施日付
                           , MAX(EN.FORM_CD)                                          AS SHIEN_KEITAI    -- 支援形態
                           , MAX(RE.TIME_VAL)                                         AS SHIEN_TIME      -- 実施時間
                           , MAX(RE.VAL)                                              AS SHIEN_POINT     -- 実施ポイント
                           , MAX(EN.EFRCR_CD)                                         AS SHIEN_JISSHISHA -- 実施者
                         FROM
                          TNDS_T_THOKEN_SEC SE  -- セクションテーブル
                           INNER JOIN TNDS_T_THOKEN_ENTRY EN  -- エントリーテーブル
                           ON  ( SE.SEC_CD  = '90040'
                            AND  SE.SEQ1_NO = EN.SEQ1_NO
                            AND  SE.SEQ2_NO = SUBSTR( EN.SEQ2_NO,1,2) || N'0000' )
                           INNER JOIN TNDS_T_THOKEN_RESULT RE  -- 詳細テーブル   CDによる特定ができないと支援Ａか支援Ｂか判断できないため、INNER JOINで結合する
                           ON  (
                                 RE.CD IN (
                                    '1032100013'
                                   ,'1032100014')
                            AND  EN.SEQ1_NO = RE.SEQ1_NO
                            AND  EN.SEQ2_NO = SUBSTR( RE.SEQ2_NO,1,4) || N'00' )
                         GROUP BY
                            EN.SEQ1_NO
                          , EN.SEQ2_NO
                    )
                   GROUP BY
                      SEQ1_NO
              ) AA
          ON  ( BA.SEQ1_NO
              = AA.SEQ1_NO )
  /* セクションコード90040：支援Ｂ */
   LEFT OUTER JOIN (
                    SELECT 
                       SEQ1_NO                                                        AS SEQ1_NO                -- 001.通番１
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_DATE))                           AS SHIEN_B_1_DATE         -- 097.支援Ｂ①の実施日付
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_KEITAI))                         AS SHIEN_B_1_SHIEN_KEITAI -- 098.支援Ｂ①の支援形態
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_TIME))                           AS SHIEN_B_1_TIME         -- 099.支援Ｂ①の実施時間
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_POINT))                          AS SHIEN_B_1_POINT        -- 100.支援Ｂ①の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,1,SHIEN_JISSHISHA))                      AS SHIEN_B_1_JISSHISHA    -- 101.支援Ｂ①の実施者
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_DATE))                           AS SHIEN_B_2_DATE         -- 102.支援Ｂ②の実施日付
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_KEITAI))                         AS SHIEN_B_2_SHIEN_KEITAI -- 103.支援Ｂ②の支援形態
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_TIME))                           AS SHIEN_B_2_TIME         -- 104.支援Ｂ②の実施時間
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_POINT))                          AS SHIEN_B_2_POINT        -- 105.支援Ｂ②の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,2,SHIEN_JISSHISHA))                      AS SHIEN_B_2_JISSHISHA    -- 106.支援Ｂ②の実施者
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_DATE))                           AS SHIEN_B_3_DATE         -- 107.支援Ｂ③の実施日付
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_KEITAI))                         AS SHIEN_B_3_SHIEN_KEITAI -- 108.支援Ｂ③の支援形態
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_TIME))                           AS SHIEN_B_3_TIME         -- 109.支援Ｂ③の実施時間
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_POINT))                          AS SHIEN_B_3_POINT        -- 110.支援Ｂ③の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,3,SHIEN_JISSHISHA))                      AS SHIEN_B_3_JISSHISHA    -- 111.支援Ｂ③の実施者
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_DATE))                           AS SHIEN_B_4_DATE         -- 112.支援Ｂ④の実施日付
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_KEITAI))                         AS SHIEN_B_4_SHIEN_KEITAI -- 113.支援Ｂ④の支援形態
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_TIME))                           AS SHIEN_B_4_TIME         -- 114.支援Ｂ④の実施時間
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_POINT))                          AS SHIEN_B_4_POINT        -- 115.支援Ｂ④の実施ポイント
                     , MAX(DECODE(SHIEN_RANK,4,SHIEN_JISSHISHA))                      AS SHIEN_B_4_JISSHISHA    -- 116.支援Ｂ④の実施者
                   FROM (
                         SELECT
                             EN.SEQ1_NO                                               AS SEQ1_NO         -- 通番１
                           , EN.SEQ2_NO                                               AS SEQ2_NO         -- 通番２
                           , RANK() OVER(PARTITION BY EN.SEQ1_NO ORDER BY EN.SEQ2_NO) AS SHIEN_RANK      -- 同一通番１内で通番２昇順に並び替えランクづけする
                           , MAX(EN.OPRTN_YMD)                                        AS SHIEN_DATE      -- 実施日付
                           , MAX(EN.FORM_CD)                                          AS SHIEN_KEITAI    -- 支援形態
                           , MAX(RE.TIME_VAL)                                         AS SHIEN_TIME      -- 実施時間
                           , MAX(RE.VAL)                                              AS SHIEN_POINT     -- 実施ポイント
                           , MAX(EN.EFRCR_CD)                                         AS SHIEN_JISSHISHA -- 実施者
                         FROM
                          TNDS_T_THOKEN_SEC SE  -- セクションテーブル
                           INNER JOIN TNDS_T_THOKEN_ENTRY EN  -- エントリーテーブル
                           ON  ( SE.SEC_CD  = '90040'
                            AND  SE.SEQ1_NO = EN.SEQ1_NO
                            AND  SE.SEQ2_NO = SUBSTR( EN.SEQ2_NO,1,2) || N'0000' )
                           INNER JOIN TNDS_T_THOKEN_RESULT RE  -- 詳細テーブル   CDによる特定ができないと支援Ａか支援Ｂか判断できないため、INNER JOINで結合する
                           ON  (
                                 RE.CD IN (
                                    '1032200013'
                                   ,'1032200014')
                            AND  EN.SEQ1_NO = RE.SEQ1_NO
                            AND  EN.SEQ2_NO = SUBSTR( RE.SEQ2_NO,1,4) || N'00' )
                         GROUP BY
                            EN.SEQ1_NO
                          , EN.SEQ2_NO
                    )
                   GROUP BY
                      SEQ1_NO
              ) BB
          ON  ( BA.SEQ1_NO
              = BB.SEQ1_NO )
  /* セクションコード90060：最終評価情報セクション */
  LEFT OUTER JOIN (
                   SELECT 
                       SE.SEQ1_NO                                      AS SEQ1_NO                           -- 001.通番１
                     , MAX(EN.OPRTN_YMD)                               AS SIX_MONTH_H_DATE                  -- 117.６ヶ月後の評価の実施日付
                     , MAX(EN.FORM_CD)                                 AS SIX_MONTH_H_SHIEN_KAKUNIN         -- 118.６ヶ月後の評価の支援形態又は確認方法
                     , MAX(EN.EFRCR_CD)                                AS SIX_MONTH_H_JISSHISHA             -- 119.６ヶ月後の評価の実施者
                     , MAX(DECODE(RE.CD,'1042000116',RE.VAL   ))       AS SIX_MONTH_H_NOT_KAKUNIN           -- 120.６ヶ月後の評価ができない場合の確認回数
                     , MAX(DECODE(RE.CD,'1042001031',RE.VAL   ))       AS SIX_MONTH_H_HUKUI                 -- 121.６ヶ月後の評価時の腹囲
                     , MAX(DECODE(RE.CD,'1042001032',RE.VAL   ))       AS SIX_MONTH_H_WEIGHT                -- 122.６ヶ月後の評価時の体重
                     , MAX(DECODE(RE.CD,'1042001033',RE.VAL   ))       AS SIX_MONTH_H_SHUSHUKU_KETSUATSU    -- 123.６ヶ月後の評価時の収縮期血圧
                     , MAX(DECODE(RE.CD,'1042001034',RE.VAL   ))       AS SIX_MONTH_H_KAKUCHOU_KETSUATSU    -- 124.６ヶ月後の評価時の拡張期血圧
                     , MAX(DECODE(RE.CD,'1042001042',RE.CNTNT ))       AS SIX_MONTH_H_HOKEN_EIYOU           -- 125.６ヶ月後の評価時の保健指導による生活習慣の改善（栄養・食生活）
                     , MAX(DECODE(RE.CD,'1042001041',RE.CNTNT ))       AS SIX_MONTH_H_HOKEN_SHINTAI         -- 126.６ヶ月後の評価時の保健指導による生活習慣の改善（身体活動）
                     , MAX(DECODE(RE.CD,'1042001043',RE.CNTNT ))       AS SIX_MONTH_H_HOKEN_KITSUEN         -- 127.６ヶ月後の評価時の保健指導による生活習慣の改善（喫煙）
                   FROM
                    TNDS_T_THOKEN_SEC SE  -- セクションテーブル
                     INNER JOIN TNDS_T_THOKEN_ENTRY EN  -- エントリーテーブル
                     ON  ( SE.SEC_CD  = '90060'
                      AND  SE.SEQ1_NO = EN.SEQ1_NO
                      AND  SE.SEQ2_NO = SUBSTR( EN.SEQ2_NO,1,2) || N'0000' )
                     LEFT OUTER JOIN TNDS_T_THOKEN_RESULT RE  -- 詳細テーブル
                     ON  ( 
                           RE.CD IN (
                             '1042000116'
                            ,'1042001031'
                            ,'1042001032'
                            ,'1042001033'
                            ,'1042001034'
                            ,'1042001042'
                            ,'1042001041'
                            ,'1042001043')
                      AND  EN.SEQ1_NO = RE.SEQ1_NO
                      AND  EN.SEQ2_NO = SUBSTR( RE.SEQ2_NO,1,4) || N'00' )
                   GROUP BY
                      SE.SEQ1_NO
                  ) SA
          ON  ( BA.SEQ1_NO
              = SA.SEQ1_NO )
  /* セクションコード90080：委託先情報セクション */
  LEFT OUTER JOIN (
                   SELECT 
                       SEQ1_NO                                                        AS SEQ1_NO                -- 001.通番１
                     , MAX(DECODE(ITAKU_RANK,1,TRUST_INST_NO))                        AS ITAKU_HOKEN_KIKAN_NO_1 -- 162.委託先保健指導機関番号(1)
                     , MAX(DECODE(ITAKU_RANK,2,TRUST_INST_NO))                        AS ITAKU_HOKEN_KIKAN_NO_2 -- 163.委託先保健指導機関番号(2)
                     , MAX(DECODE(ITAKU_RANK,3,TRUST_INST_NO))                        AS ITAKU_HOKEN_KIKAN_NO_3 -- 164.委託先保健指導機関番号(3)
                     , MAX(DECODE(ITAKU_RANK,4,TRUST_INST_NO))                        AS ITAKU_HOKEN_KIKAN_NO_4 -- 165.委託先保健指導機関番号(4)
                   FROM (
                         SELECT
                             EN.SEQ1_NO                                               AS SEQ1_NO         -- 通番１
                           , EN.SEQ2_NO                                               AS SEQ2_NO         -- 通番２
                           , RANK() OVER(PARTITION BY EN.SEQ1_NO ORDER BY EN.SEQ2_NO) AS ITAKU_RANK      -- 同一通番１内で通番２昇順に並び替えランクづけする
                           , EN.TRUST_INST_NO                                         AS TRUST_INST_NO   -- 委託先機関番号
                         FROM
                          TNDS_T_THOKEN_SEC SE  -- セクションテーブル
                           INNER JOIN TNDS_T_THOKEN_ENTRY EN  -- エントリーテーブル
                           ON  ( SE.SEC_CD  = '90080'
                            AND  SE.SEQ1_NO = EN.SEQ1_NO
                            AND  SE.SEQ2_NO = SUBSTR( EN.SEQ2_NO,1,2) || N'0000' )
                    )
                   GROUP BY
                      SEQ1_NO
              ) IT
          ON  ( BA.SEQ1_NO
              = IT.SEQ1_NO )
  /* マスター紐づけ中間テーブル */
  LEFT OUTER JOIN TNDS_T_MSTLINK MSTLINK
                  ON ( SUBSTR(BA.HGE_YMD,1,6) = MSTLINK.APPL_YM )
  /* 都道府県ごとの人口（性・年齢階層別） */
  LEFT OUTER JOIN TNDS_M_POP_PER_TDFK M_POPT
                  ON ( SUBSTR(BA.HGE_INST_NO_ORG,1,2) = M_POPT.TDFK_CD
                   AND M_POPT.SEX = 0
                   AND MSTLINK.POP_PER_TDFK_GEN = M_POPT.MST_GEN )
  LEFT OUTER JOIN TNDS_T_AGE_DIV1 M_AGE01        -- 年齢階層区分テーブル１
                  ON  ( BA.AGE_HIER_CD1
                      = M_AGE01.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV2 M_AGE11        -- 年齢階層区分テーブル２
                  ON  ( BA.AGE_HIER_CD2
                      = M_AGE11.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV1 M_AGE02        -- 年齢階層区分テーブル１
                  ON  ( BA.LAST_BIRTH_AGE_HIER_CD1
                      = M_AGE02.AGE_HIER_CODE )
  LEFT OUTER JOIN TNDS_T_AGE_DIV2 M_AGE12        -- 年齢階層区分テーブル２
                  ON  ( BA.LAST_BIRTH_AGE_HIER_CD2
                      = M_AGE12.AGE_HIER_CODE )
  LEFT OUTER JOIN CMDS_M_SEX_DIV M_SEX           -- 男女区分マスター
                  ON  ( BA.USER_SEX_CD
                      = M_SEX.SEX_DIV )
;
commit;
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_T_THOKEN_VIEW_TABLE', degree => dbms_stats.auto_degree, cascade => true );
