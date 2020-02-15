## 作業方針
- テストデータでは、調剤レセプトに存在する個人に対応する医科レセプトが存在しないので、対応する医科レセプトを追加する（`INSERT_TNDS_T_RCP_MED_RE.sql`, `INSERT_TNDS_T_RCP_MED_SY.sql`）
- テストデータでは、マスターテーブルは無いか、空になっているので、必要なマスターテーブルを作成する（`CREATE_TNDS_M_MEDICINE.sql`, `CREATE_TNDS_M_POP_PER_TDFK.sql`, `CREATE_TNDS_T_TRANS_JC_YEAR.sql`）
- 便利のため、独自のレセプト種別のマスターと対象となる医薬品コードのマスターを作成する（`CREATE_RCP_CLS_MASTER.sql`, `CREATE_RCP_CLS_MASTER_SIMPLE.sql`, `CREATE_MEDICATION_TABLE.sql`が実行される）
- 1 tupleを処方箋/医薬品単位とした、サマリーのための最終テーブル`IY_DATA`の枠を作成する（`CREATE_TABLE_IY_DATA.sql`）
- サマリーテーブル`SUMMARY_1`と`SUMMARY_2`の枠を作成する（`CREATE_TABLE_SUMMARY.sql`）
- 作業領域のキャパシティを考慮し、疾患は一つずつ順番に扱っていく（テストデータではDementiaを扱っているとする）
- 一時表領域のキャパシティを考慮し、内容を絞り込んだ`TABLE`を用意し、`JOIN`をしていく
- 必要なくなった`TABLE`は適宜`DROP`していく
- 疾患毎に異なるクエリは疾患別のフォルダに格納し、該当箇所に`-- 疾患に応じて変更する`と記載する（`CREATE_TABLE_MEDICINE_CD_EXTRACT.sql`, `CREATE_TABLE_INIT_SEQ.sql`）
- 作業領域のキャパシティを考慮し、以下の操作を一年度ずつ繰り返す（`BATCH_SUMMARY.sql`）
	- このバッチでは、適宜時間と空き容量を測定する
	- 疾患に対応する傷病コードのある個人の`SEQ2_NO`を抽出する（`CREATE_TABLE_MEDICINE_CD_EXTRACT.sql`, `CREATE_TABLE_INIT_SEQ.sql`）
	- 対象となる個人の医科レセプトから必要な情報を抽出する（`CREATE_TABLE_TARGET_MED_SEQ.sql`, `CREATE_TABLE_TARGET_MED_RE.sql`, `CREATE_TABLE_TARGET_MED_IR.sql`, `CREATE_TABLE_TARGET_MED_IY.sql`）
	- 対象となる個人の医科レセプトから、対象となる医薬品の院内処方の情報を抽出し、`IY_DATA`に`INSERT`する（`INSERT_IY_DATA_MED.sql`）
	- 対象となる個人の医科レセプトから必要な情報を抽出する（`CREATE_TABLE_TARGET_PHA_SEQ.sql`, `CREATE_TABLE_TARGET_PHA_RE.sql`, `CREATE_TABLE_TARGET_PHA_YK.sql`, `CREATE_TABLE_TARGET_PHA_CZ.sql`, `CREATE_TABLE_TARGET_PHA_IY.sql`, `CREATE_TABLE_TARGET_PHA_CZIY.sql`）
	- 対象となる個人の調剤レセプトから、対象となる医薬品の院外処方の情報を抽出し、`IY_DATA`に`INSERT`する（`INSERT_IY_DATA_PHA.sql`）
	- IY_DATAから、必要なサマリーを作成する（`INSERT_SUMMARY_1.sql`, `INSERT_SUMMARY_2.sql`）
- サマリーを見やすい形に変更してcsv出力する（`OUTPUT_SUMMARY_1_CSV.sql`, `OUTPUT_SUMMARY_2_CSV.sql`）

## 実行するクエリ
- `BATCH_TEST_INIT_1.sql`:テスト環境を補うための追加データ、環境を立ち上げて初回のみ実行する
- `BATCH_TEST_INIT_2.sql`:テスト環境を補うための追加データ、`SQL*Plus`で接続する度に実行する
- `BATCH_PREPARE.sql`:解析実行のために必要な準備を実行していくバッチ
- `BATCH_<DISEASE>.sql`:`IY_DATA`にデータを挿入して、サマリーする一連のクエリを繰り返し、最終結果を出力するバッチ
- `DROP_FINAL.sql`:環境を初期化するために作成したオブジェクトを削除、全ての解析が終了した後に実行する
- `DROP_TEST.sql`:テスト環境を補うための追加データを初期化する

## SQLの構成
バッチファイルにある順に記載されている

- `INSERT_TNDS_T_RCP_MED_RE.sql`:テスト用に`TNDS_T_RCP_MED_RE`に変数を追加
- `INSERT_TNDS_T_RCP_MED_SY.sql`:テスト用に`TNDS_T_RCP_MED_SY`に変数を追加
- `CREATE_TNDS_M_MEDICINE.sql`:テスト用の`TNDS_M_MEDICINE`を`TEMPORARY TABLE`で作成
- `CREATE_TNDS_M_POP_PER_TDFK.sql`:テスト用の`TNDS_M_POP_PER_TDFK`を`TEMPORARY TABLE`で作成
- `CREATE_TNDS_T_TRANS_JC_YEAR.sql`:テスト用の`TNDS_T_TRANS_JC_YEAR`を`INSERT`
- `TABLE_SIZE.sql`:USER表領域の残り容量を確認する
- `CREATE_RCP_CLS_MASTER.sql`:レセプト種別のマスターの`TEMPORARY TABLE` `RCP_CLS_MASTER`を作成
- `CREATE_RCP_CLS_MASTER_SIMPLE.sql`:レセプト種別のマスター簡易版の`TEMPORARY TABLE` `RCP_CLS_MASTER_SIMPLE`を作成
- `CREATE_MEDICATION_TABLE.sql`:対象となる医薬品コードの`TEMPORARY TABLE` `MEDICATION_TABLE`を作成
- `CREATE_TABLE_IY_DATA.sql`:外来での医科レセプトからの院内処方と調剤レセプトからの院外処方を抽出したデータを入れる`TABLE` `IY_DATA`を準備
- `CREATE_TABLE_SUMMARY.sql`:模擬申出書の別添9に当たるクエリの`TABLE`、`SUMMARY_1`（別添9上表：医薬品別、年月別、都道府県別、年代別、男女別のジェネリック医薬品シェア）と`SUMMARY_2`（別添9下表：医薬品別、年月別、都道府県別、年代別、男女別、自己負担割合＋公費別のジェネリック医薬品シェア）を準備
- `BATCH_SUMMARY.sql`:`&START_YM`から`&END_YM`までの期間の`IY_DATA`を`INSERT`し、サマリーを作成するバッチ、サマリーを作成後、`IY_DATA`に次のデータを格納するために一連の`TABLE`を`DROP`
	- `<DISEASE>/CREATE_TABLE_MEDICINE_CD_EXTRACT.sql`:対象となる医薬品の情報を持つ`TABLE` `MEDICINE_CD_EXTRACT`を作成
	- `<DISEASE>/CREATE_TABLE_INIT_SEQ.sql`:疾患に対応する傷病コードのある医科レセプトの`SEQ2_NO`を持つ`TABLE` `INIT_SEQ`
	- `CREATE_TABLE_TARGET_ID1.sql`:疾患に対応する傷病コードのある個人のID1を持つ`TABLE` `TARGET_ID1`
	- `CREATE_TABLE_TARGET_MED_SEQ.sql`:今回の対象となる`ID1`の医科レセプトの`SEQ2_NO`を抽出
	- `CREATE_TABLE_TARGET_MED_RE.sql`:`CMDV_T_RCP_MED_RE`から必要な情報を抽出した`TABLE` `TARGET_MED_RE`
	- `CREATE_TABLE_TARGET_MED_IR.sql`:`CMDV_T_RCP_MED_IR`から必要な情報を抽出した`TABLE` `TARGET_MED_IR`
	- `CREATE_TABLE_TARGET_MED_IY.sql`:`CMDV_T_RCP_MED_IY`から必要な情報を抽出した`TABLE` `TARGET_MED_IY`
	- `INSERT_IY_DATA_MED.sql`:院内処方で`IY_DATA`に挿入するデータ
	- `CREATE_TABLE_TARGET_PHA_SEQ.sql`:今回の対象となるID1の調剤レセプトの`SEQ2_NO`を抽出
	- `CREATE_TABLE_TARGET_PHA_RE.sql`:`CMDV_T_RCP_PHA_RE`から必要な情報を抽出した`TABLE` `TARGET_PHA_RE`
	- `CREATE_TABLE_TARGET_PHA_YK.sql`:`CMDV_T_RCP_PHA_YK`から必要な情報を抽出した`TABLE` `TARGET_PHA_YK`
	- `CREATE_TABLE_TARGET_PHA_CZ.sql`:`CMDV_T_RCP_PHA_CZ`から必要な情報を抽出した`TABLE` `TARGET_PHA_CZ`
	- `CREATE_TABLE_TARGET_PHA_IY.sql`:`CMDV_T_RCP_PHA_IY`から必要な情報を抽出した`TABLE` `TARGET_PHA_IY`
	- `CREATE_TABLE_TARGET_PHA_CZIY.sql`:`TARGET_PHA_CZ`と`TARGET_PHA_IY`を`JOIN`して必要な情報を抽出した`TABLE` `TARGET_PHA_CZIY`
	- `INSERT_IY_DATA_PHA.sql`:院外処方で`IY_DATA`に挿入するデータ
	- `INSERT_SUMMARY_1.sql`:`SUMMARY_1`に挿入するデータ
	- `INSERT_SUMMARY_2.sql`:`SUMMARY_2`に挿入するデータ
- `BATCH_OUTPUT.sql`:サマリーをcsv出力するためのバッチ
	- `OUTPUT_SUMMARY_1_CSV.sql`:SUMMARY_1から集計結果をcsv出力
	- `OUTPUT_SUMMARY_2_CSV.sql`:SUMMARY_2から集計結果をcsv出力

## 出力されるファイル
- `SPOOL_<DISEASE>.log`:`BATCH_<DISEASE>.sql`を実行したログ
- `SUMMARY_1_<DISEASE>.csv`:模擬申出書の別添9の上表に当たるクエリの出力結果
- `SUMMARY_2_<DISEASE>.csv`:模擬申出書の別添9の下表に当たるクエリの出力結果

## マスキング
- NDBのマスキングルールに従って最終結果のマスキングを行う
- 以下をマスクする
	- 患者数が不明な場合もしくは10人未満の場合であり、総量が内服・外用の場合は1000未満、注射の場合は400未満の行
	- 総量の列
	- ジェネリック医薬品シェアは小数点以下3桁まで
- マスクをしたデータの出力ファイルは同じ名前のファイルにし、`masked/`というフォルダに格納する
- この操作で、SQLでの抽出では空欄になってしまっていたgeneric shareに0を補完した
- Code
	- `mask.R`

## 全国集計値
- `SUMMARY_1_<DISEASE>.csv`と`SUMMARY_2_<DISEASE>.csv`から全国レベルに集計した出力を作成した
- マスキング処理を施している
- Code
	- `national.R`
