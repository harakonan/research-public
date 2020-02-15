-- SUMMARY_2に挿入するデータ
INSERT
INTO
    SUMMARY_2
SELECT
    SUM(
        CASE
            WHEN
                ID.GENERIC  =   1
            THEN
                ID.AMOUNT
            ELSE
                NULL
        END
    )/SUM(ID.AMOUNT)
,   ID.MEDICINE_SHORT
,   ID.PRAC_YM
,   ID.TDFK
,   ID.AGE
,   ID.SEX_DIV
,   RCMS.PUBFUND
,   RCMS.COSTSHARING
,   SUM(ID.AMOUNT)
FROM
    IY_DATA                 ID
,   RCP_CLS_MASTER_SIMPLE   RCMS
WHERE
    ID.RCP_CLS  =   RCMS.RCP_CLS
GROUP BY
    ID.MEDICINE_SHORT
,   ID.PRAC_YM
,   ID.TDFK
,   ID.AGE
,   ID.SEX_DIV
,   RCMS.PUBFUND
,   RCMS.COSTSHARING
;
