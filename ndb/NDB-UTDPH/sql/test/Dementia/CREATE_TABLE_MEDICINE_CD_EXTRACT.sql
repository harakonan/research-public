-- 対象となる医薬品の情報を持つTABLE MEDICINE_CD_EXTRACT
-- 医薬品はTNDS_M_MEDICINEのDRUG_PRICE_STD_CDの上8桁で定まる
-- マスター世代は初代（L01）を使用する
CREATE TABLE MEDICINE_CD_EXTRACT(MEDICINE_CD, GENERIC, MEDICINE_SHORT, APPL_YM_W) AS
SELECT
    TMM.MEDICINE_CD
,   TMM.GENERIC
,   SUBSTR(TMM.DRUG_PRICE_STD_CD, 1, 8) MEDICINE_SHORT
,   TTTJY.WAREKI
FROM
    TNDS_M_MEDICINE         TMM
    JOIN
        TNDS_T_TRANS_JC_YEAR    TTTJY
        ON  TMM.APPL_YM  =  TTTJY.SEIREKI
WHERE
    -- 疾患に応じて変更する
    SUBSTR(TMM.DRUG_PRICE_STD_CD, 1, 8) IN   ('1190012F')
AND SUBSTR(TMM.MST_GEN, 7, 9)           =   'L01'
;