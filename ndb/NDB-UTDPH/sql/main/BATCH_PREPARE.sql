-- 解析実行のために必要な準備を実行していくバッチ

-- パラレル実行を設定
alter session force parallel ddl parallel 30
alter session force parallel dml parallel 30
alter session force parallel query parallel 30

-- USER表領域の残り容量を確認する
@TABLE_SIZE.sql

-- レセプト種別のマスターのTEMPORARY TABLE RCP_CLS_MASTERを作成
@CREATE_RCP_CLS_MASTER.sql

--  RCP_CLS_MASTERに入っているCOSTSHARINGの'10','20','1020'を'10'にまとめるVIEW
@CREATE_RCP_CLS_MASTER_SIMPLE.sql

-- 抜き出す医薬品コードのTEMPORARY TABLE MEDICATION_TABLEを作成
@CREATE_MEDICATION_TABLE.sql

-- 外来での医科レセプトからの院内処方と調剤レセプトからの院外処方を抽出したデータを入れるTABLE IY_DATAを準備
@CREATE_TABLE_IY_DATA.sql

-- 模擬申出書の別添9に当たるクエリのTABLEを準備
@CREATE_TABLE_SUMMARY.sql

-- ログを見やすくするための設定
SET ECHO ON
SET LINESIZE 32767
SET PAGESIZE 50000
SET TRIMSPOOL ON
