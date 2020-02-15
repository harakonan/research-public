-- CMDV_T_RCP_PHA_RE����K�v�ȏ��𒊏o����TABLE TARGET_PHA_RE
-- �N��敪�́A20�Α�A30�Α�A...�A80�Α�A90�Έȏ�
CREATE  TABLE   TARGET_PHA_RE(PRAC_YM, AGE, RCP_CLS, SEX_DIV, SEQ2_NO)  AS
SELECT
    RE.PRAC_YM
,   CASE
        WHEN
            RE.AGE  >=  100
        THEN
            90
        ELSE
            TRUNC(RE.AGE, -1)
    END
,   RE.RCP_CLS
,   RE.SEX_DIV
,   RE.SEQ2_NO
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
            TARGET_PHA_SEQ  TS
        WHERE
            TS.SEQ2_NO  =   RE.SEQ2_NO
    )
;
