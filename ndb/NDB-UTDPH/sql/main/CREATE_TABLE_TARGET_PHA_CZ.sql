-- CMDV_T_RCP_PHA_CZ����K�v�ȏ��𒊏o����TABLE TARGET_PHA_CZ
CREATE  TABLE   TARGET_PHA_CZ(SEQ2_NO, PRSPT_NO, DSPNG_AMNT)    AS
SELECT
    CZ.SEQ2_NO
,   CZ.PRSPT_NO
,   CZ.DSPNG_AMNT
FROM
    CMDV_T_RCP_PHA_CZ   CZ
WHERE
    CZ.PRAC_YM  >=  &START_YM
AND CZ.PRAC_YM  <=  &END_YM
AND CZ.VLD_FLG  =   1
AND EXISTS(
        SELECT
            *
        FROM
            TARGET_PHA_SEQ  TS
        WHERE
            TS.SEQ2_NO  =   CZ.SEQ2_NO
    )
;