ALTER INDEX CMDS_M_RCP_CLS_MED_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_RCP_CLS_DPC_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_RCP_CLS_DEN_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_RCP_CLS_PHA_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_TDFK_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_SEX_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_RCP_IMPTT_NOTI_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_PRAC_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_PRAC_IDENT_MED_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_PRAC_IDENT_DPC_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_PRAC_IDENT_DEN_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_DSG_FRM_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_RCP_GNRLZ_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_RDCT_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_REASON_DUTY_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_STAND_BURD_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_MEDI_TREAT_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_OUTCM_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_WARD_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_SEX_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_BODY_PART_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_SPCFC_DISE_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_EXAM_PAY_INST_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_BYOSHIN_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_HOSTZ_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_NUM_INS_NUM_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_SSPCT_DSS_SELECT_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_MAIN_SKWD_SELECT_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_PHA_CLS_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_GENERIC_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_AGE_LOAD_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_ICHITAIRO_DIV_PK REBUILD NOLOGGING PARALLEL 96;
ALTER INDEX CMDS_M_ORI_SND_DIV_PK REBUILD NOLOGGING PARALLEL 96;

exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RCP_CLS_MED',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RCP_CLS_DPC',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RCP_CLS_DEN',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RCP_CLS_PHA',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_TDFK',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_SEX_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RCP_IMPTT_NOTI',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_PRAC',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_PRAC_IDENT_MED',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_PRAC_IDENT_DPC',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_PRAC_IDENT_DEN',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_DSG_FRM',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RCP_GNRLZ_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_RDCT_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_REASON_DUTY',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_STAND_BURD_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_MEDI_TREAT',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_OUTCM_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_WARD_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_SEX',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_BODY_PART',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_SPCFC_DISE',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_EXAM_PAY_INST',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_BYOSHIN_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_HOSTZ_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_NUM_INS_NUM',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_SSPCT_DSS_SELECT',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_MAIN_SKWD_SELECT',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_PHA_CLS',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_GENERIC',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_AGE_LOAD',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_ICHITAIRO_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_VLD_FLG',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
exec DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'NDB',TABNAME=>'CMDS_M_ORI_SND_DIV',DEGREE=>DBMS_STATS.AUTO_DEGREE,CASCADE=>TRUE);
