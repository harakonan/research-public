-- 環境を初期化するために作成したオブジェクトを削除
-- 全ての解析が終了した後に実行する

-- 新たに作成したTEMPORARY TABLEをDROP
TRUNCATE TABLE MEDICATION_TABLE;
TRUNCATE TABLE RCP_CLS_MASTER;
DROP TABLE MEDICATION_TABLE;
DROP TABLE RCP_CLS_MASTER;
-- 新たに作成したVIEWをDROP
DROP VIEW RCP_CLS_MASTER_SIMPLE;
-- サマリー用テーブルをDROP
DROP TABLE IY_DATA;
DROP TABLE SUMMARY_1;
DROP TABLE SUMMARY_2;