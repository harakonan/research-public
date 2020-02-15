CREATE MATERIALIZED VIEW CMDS_M_TOKKEN_PER parallel 96 nologging
AS
select distinct
    substr(SEIREKI,1,4) as SEIREKI,
    substr(SEIREKI_NAME,1,5) || N'度' as SEIREKI_NAME,
    substr(WAREKI,1,3) as WAREKI,
    substr(WAREKI_NAME,1,5)  || N'度' as WAREKI_NAME
from TNDS_T_TRANS_JC_YEAR
      INNER JOIN TNDS_T_TOKKEN_BASE
       ON substr(TNDS_T_TRANS_JC_YEAR.SEIREKI,1,4) = TNDS_T_TOKKEN_BASE.MEE_NENDO
order by SEIREKI DESC
;
