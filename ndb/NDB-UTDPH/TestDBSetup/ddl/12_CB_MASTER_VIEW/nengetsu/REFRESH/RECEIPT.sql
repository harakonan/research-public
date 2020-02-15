WHENEVER SQLERROR EXIT 1;

exec dbms_mview.refresh('CMDS_M_MED_PRA','c');
exec dbms_mview.refresh('CMDS_M_MED_CLA','c');
exec dbms_mview.refresh('CMDS_M_DPC_PRA','c');
exec dbms_mview.refresh('CMDS_M_DPC_CLA','c');
exec dbms_mview.refresh('CMDS_M_DEN_PRA','c');
exec dbms_mview.refresh('CMDS_M_DEN_CLA','c');
exec dbms_mview.refresh('CMDS_M_PHA_PRA','c');
exec dbms_mview.refresh('CMDS_M_PHA_CLA','c');

exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_MED_PRA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_MED_CLA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_DPC_PRA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_DPC_CLA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_DEN_PRA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_DEN_CLA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_PHA_PRA', degree => dbms_stats.auto_degree, cascade => true );
exec dbms_stats.gather_table_stats( ownname => 'NDB', tabname => 'CMDS_M_PHA_CLA', degree => dbms_stats.auto_degree, cascade => true );
