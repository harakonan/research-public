/*------------ 特定健診ビュー（第三者） ------------*/
CREATE VIEW CMDV_T_TOKKEN AS
  SELECT
      SEQ1_NO
    , IDENT_CD
    , INPUT_YM
    , VLD_FLG
    , ID1
    , ID1N
    , ID2
    , AGE
    , AGE_HIER_CD1
    , AGE_HIER1
    , AGE_HIER_CD2
    , AGE_HIER2
    , LAST_BIRTH_AGE
    , LAST_BIRTH_AGE_HIER_CD1
    , LAST_BIRTH_AGE_HIER1
    , LAST_BIRTH_AGE_HIER_CD2
    , LAST_BIRTH_AGE_HIER2
    , TESTEE_POST_NO
    , TDFK
    , TDFK_NAME
    , TDFK_JINKOU
    , TESTEE_SEX_CD
    , TESTEE_SEX_NAME
    , TESTEE_BIRTH_YM
    , CNSLT_TCKT_FACE_CLS
    , CNSLT_TCKT_RFRNC_NO
    , MEE_PRG_CLS
    , MEE_YMD
    , MEE_YM
    , MEE_NENDO
    , MEE_INST_NO
    , INSURER_NO
    , RPT_DIV
    , QLFCT_DIV
    , HEIGHT
    , WEIGHT
    , BMI
    , NAIZO_SHIBO_MENSEKI
    , FUKUI_JISSOKU
    , FUKUI_JIKO_HANTEI
    , FUKUI_JIKO_SHINKOKU
    , KIOUREKI
    , DETAIL_KIOUREKI
    , JIKAKU_SHOJYO
    , JIKAKU_SHOJYO_SHOKEN
    , TAKAKU_SHOJYO
    , TAKAKU_SHOJYO_SHOKEN
    , SHUSHUKU_KETSUATSU_SONOTA
    , SHUSHUKU_KETSUATSU_SECOND
    , SHUSHUKU_KETSUATSU_FIRST
    , KAKUCHO_KETSUATSU_SONOTA
    , KAKUCHO_KETSUATSU_SECOND
    , KAKUCHO_KETSUATSU_FIRST
    , SHINPAKUSU
    , SAIKETSUJIKAN_SHOKUGO
    , CHOLESTEROL_KASHI
    , CHOLESTEROL_SHIGAISEN
    , CHOLESTEROL_SONOTA
    , CHUSEI_KASHI
    , CHUSEI_SHIGAISEN
    , CHUSEI_SONOTA
    , HDL_KASHI
    , HDL_SHIGAI
    , HDL_SONOTA
    , LDL_KASHI
    , LDL_SHIGAI
    , LDL_SONOTA
    , BILIRUBIN_KASHI
    , BILIRUBIN_SONOTA
    , GOT_SHIGAI
    , GOT_SONOTA
    , GPT_SHIGAI
    , GPT_SONOTA
    , GAMMA_GT_KASHI
    , GAMMA_GT_SONOTA
    , KUHUKU_KETTOU_DENI
    , KUHUKU_KETTOU_KASHI
    , KUHUKU_KETTOU_SHIGAI
    , KUHUKU_KETTOU_SONOTA
    , HBA1C_MENEKI
    , HBA1C_HPLC
    , HBA1C_KOUSO
    , HBA1C_SONOTA
    , NYOUTOU_KIKAI
    , NYOUTOU_MOKUSHI
    , NYOUTANPAKU_KIKAI
    , NYOUTANPAKU_MOKUSHI
    , HEMATOCRIT
    , HEMOGLOBIN
    , SEKKEKKYU
    , HINKETSU_KENSA_REASON
    , SHINDENZU_SHOKEN_UMU
    , SHINDENZU_SHOKEN
    , SHINDENZU_REASON
    , GANTEI_KENSA_KEITH
    , GANTEI_KENSA_SCHEIE_H
    , GANTEI_KENSA_SCHEIE_S
    , GANTEI_KENSA_SCOTT
    , GANTEI_KENSA_SONOTA_SHOKEN
    , GANTEI_KENSA_REASON
    , METABOLIC_HANTEI
    , HOKENSHIDOU_LEVEL
    , DOCTOR_HANTEI
    , KENKOU_SHINDAN_DOCTOR_NAME
    , HUKUYAKU1_KETSUATSU
    , HUKUYAKU1_PHARMA
    , HUKUYAKU1_HUKUYAKU_REASON
    , HUKUYAKU2_KETTOU
    , HUKUYAKU2_PHARMA
    , HUKUYAKU2_HUKUYAKU_REASON
    , HUKUYAKU3_SHISHITSU
    , HUKUYAKU3_PHARMA
    , HUKUYAKU3_HUKUYAKU_REASON
    , KIOUREKI1_NOUKEKKAN
    , KIOUREKI2_SHINKEKKAN
    , KIOUREKI3_JINHUZEN_TOUSEKI
    , HINKETSU
    , KITSUEN
    , TWENTY_WEIGHT_HENKA
    , THIRTY_UNDOU_SHUKAN
    , HOKOU_SHINTAI
    , HOKOU_SOKUDO
    , ONE_YEAR_TAIJYU_HENKA
    , TABEKATA1
    , TABEKATA2
    , TABEKATA3
    , SHOKUSHUKAN
    , INSHU
    , INSYURYO
    , SUIMIN
    , SEIKATSUSHUKAN_KAIZEN
    , HOKENSHIDOU_KIBOU
  FROM
    CMDS_T_TOKKEN_VIEW_TABLE
WITH READ ONLY
;