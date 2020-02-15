-- CMDV_T_RCP_PHA_YK‚©‚ç•K—v‚Èî•ñ‚ð’Šo‚µ‚½TABLE TARGET_PHA_YK
CREATE  TABLE   TARGET_PHA_YK(TDFK, SEQ2_NO)    AS
SELECT
    YK.TDFK
,   YK.SEQ2_NO
FROM
    CMDV_T_RCP_PHA_YK   YK
WHERE
    YK.PRAC_YM  >=  &START_YM
AND YK.PRAC_YM  <=  &END_YM
AND YK.VLD_FLG     =   1
AND EXISTS(
        SELECT
            *
        FROM
            TARGET_PHA_SEQ  TS
        WHERE
            TS.SEQ2_NO  =   YK.SEQ2_NO
    )
;
