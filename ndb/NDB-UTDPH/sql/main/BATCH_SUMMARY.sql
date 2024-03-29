-- &START_YMから&END_YMまでの期間のIY_DATAをINSERTし、サマリーを作成するバッチ
-- サマリーを作成後、IY_DATAに次のデータを格納するために一連のTABLEをDROP

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- 疾患に対応する傷病コードのある医科レセプトのSEQ2_NOを持つTABLE INIT_SEQ
@&DISEASE/CREATE_TABLE_INIT_SEQ.sql

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- 疾患に対応する傷病コードのある個人のID1を持つTABLE TARGET_ID1
@CREATE_TABLE_TARGET_ID1.sql

-- INIT_SEQはこの後使わないのでDROP
TRUNCATE TABLE INIT_SEQ;
DROP TABLE INIT_SEQ;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- 今回の対象となるID1の医科レセプトのSEQ2_NOを抽出
@CREATE_TABLE_TARGET_MED_SEQ.sql

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- CMDV_T_RCP_MED_REから必要な情報を抽出したTABLE TARGET_MED_RE
@CREATE_TABLE_TARGET_MED_RE.sql

-- CMDV_T_RCP_MED_IRから必要な情報を抽出したTABLE TARGET_MED_IR
@CREATE_TABLE_TARGET_MED_IR.sql

-- CMDV_T_RCP_MED_IYから必要な情報を抽出したTABLE TARGET_MED_IY
@CREATE_TABLE_TARGET_MED_IY.sql

-- TARGET_MED_SEQはこの後使わないのでDROP
TRUNCATE TABLE TARGET_MED_SEQ;
DROP TABLE TARGET_MED_SEQ;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- IY_DATAに挿入するデータ
-- 院内処方
@INSERT_IY_DATA_MED.sql

-- TARGET_MED関連はこの後使わないのでDROP
TRUNCATE TABLE TARGET_MED_RE;
TRUNCATE TABLE TARGET_MED_IR;
TRUNCATE TABLE TARGET_MED_IY;
DROP TABLE TARGET_MED_RE;
DROP TABLE TARGET_MED_IR;
DROP TABLE TARGET_MED_IY;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- 今回の対象となるID1の調剤レセプトのSEQ2_NOを抽出
@CREATE_TABLE_TARGET_PHA_SEQ.sql

-- TARGET_ID1はこの後使わないのでDROP
TRUNCATE TABLE TARGET_ID1;
DROP TABLE TARGET_ID1;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- CMDV_T_RCP_PHA_REから必要な情報を抽出したTABLE TARGET_PHA_RE
@CREATE_TABLE_TARGET_PHA_RE.sql

-- CMDV_T_RCP_PHA_YKから必要な情報を抽出したTABLE TARGET_PHA_YK
@CREATE_TABLE_TARGET_PHA_YK.sql

-- CMDV_T_RCP_PHA_CZから必要な情報を抽出したTABLE TARGET_PHA_CZ
@CREATE_TABLE_TARGET_PHA_CZ.sql

-- CMDV_T_RCP_PHA_IYから必要な情報を抽出したTABLE TARGET_PHA_IY
@CREATE_TABLE_TARGET_PHA_IY.sql

-- TARGET_PHA_SEQはこの後使わないのでDROP
TRUNCATE TABLE TARGET_PHA_SEQ;
DROP TABLE TARGET_PHA_SEQ;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- TARGET_PHA_CZとTARGET_PHA_IYをJOINして必要な情報を抽出したTABLE TARGET_PHA_CZIY
@CREATE_TABLE_TARGET_PHA_CZIY.sql

-- TARGET_PHA_CZとTARGET_PHA_IYはこの後使わないのでDROP
TRUNCATE TABLE TARGET_PHA_CZ;
TRUNCATE TABLE TARGET_PHA_IY;
DROP TABLE TARGET_PHA_CZ;
DROP TABLE TARGET_PHA_IY;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- IY_DATAに挿入するデータ
-- 院外処方
@INSERT_IY_DATA_PHA.sql

-- TARGET_PHA関連はこの後使わないのでDROP
TRUNCATE TABLE TARGET_PHA_RE;
TRUNCATE TABLE TARGET_PHA_YK;
TRUNCATE TABLE TARGET_PHA_CZIY;
DROP TABLE TARGET_PHA_RE;
DROP TABLE TARGET_PHA_YK;
DROP TABLE TARGET_PHA_CZIY;

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- SUMMARY_1に挿入するデータ
@INSERT_SUMMARY_1.sql

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- SUMMARY_2に挿入するデータ
@INSERT_SUMMARY_2.sql

-- 中間タイム
TIMING SHOW
-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- IY_DATAに次のデータを格納するためにTRUNCATE
TRUNCATE TABLE IY_DATA;
