-- SUMMARY_1Ç…ë}ì¸Ç∑ÇÈÉfÅ[É^
INSERT
INTO
    SUMMARY_1
SELECT
    SUM(
        CASE
            WHEN
                GENERIC =   1
            THEN
                AMOUNT
            ELSE
                NULL
        END
    )/SUM(AMOUNT)
,   MEDICINE_SHORT
,   PRAC_YM
,   TDFK
,   AGE
,   SEX_DIV
,   SUM(AMOUNT)
FROM
    IY_DATA
GROUP BY
    MEDICINE_SHORT
,   PRAC_YM
,   TDFK
,   AGE
,   SEX_DIV
;
