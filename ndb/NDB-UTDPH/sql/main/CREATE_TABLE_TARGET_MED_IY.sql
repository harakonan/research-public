-- CMDV_T_RCP_MED_IY����K�v�ȏ��𒊏o����TABLE TARGET_MED_IY
CREATE  TABLE   TARGET_MED_IY(USE_AMNT, TIMES, SEQ2_NO, MEDICINE_CD)    AS
SELECT
    IY.USE_AMNT
,   IY.TIMES
,   IY.SEQ2_NO
,   IY.MEDICINE_CD
FROM
    CMDV_T_RCP_MED_IY   IY
WHERE
    IY.PRAC_YM  >=  &START_YM
AND IY.PRAC_YM  <=  &END_YM
AND IY.VLD_FLG  =   1
AND EXISTS(
        SELECT
            *
        FROM
            TARGET_MED_SEQ  TS
        WHERE
            TS.SEQ2_NO  =   IY.SEQ2_NO
    )
;