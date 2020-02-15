-- 今回の対象となるID1の調剤レセプトのSEQ2_NOを抽出
CREATE  TABLE   TARGET_PHA_SEQ(SEQ2_NO) AS
SELECT
    RE.SEQ2_NO
FROM
    CMDV_T_RCP_PHA_RE   RE
WHERE
    RE.PRAC_YM  >=  &START_YM
AND RE.PRAC_YM  <=  &END_YM
AND RE.VLD_FLG  =   1
AND EXISTS(
        SELECT
            *
        FROM
            TARGET_ID1  TI
        WHERE
            TI.ID1  =   RE.ID1
    )
;
