-- CMDV_T_RCP_MED_IR‚©‚ç•K—v‚Èî•ñ‚ð’Šo‚µ‚½TABLE TARGET_MED_IR
CREATE  TABLE   TARGET_MED_IR(TDFK, SEQ2_NO)    AS
SELECT
    IR.TDFK
,   IR.SEQ2_NO
FROM
    CMDV_T_RCP_MED_IR   IR
WHERE
    IR.PRAC_YM  >=  &START_YM
AND IR.PRAC_YM  <=  &END_YM
AND IR.VLD_FLG  =   1
AND EXISTS(
        SELECT
            *
        FROM
            TARGET_MED_SEQ  TS
        WHERE
            TS.SEQ2_NO  =   IR.SEQ2_NO
    )
;
