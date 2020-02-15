# SQLでのNDBからのデータ抽出プロジェクト
## Introduction

- このフォルダは、平成29年度厚生労働科学研究費補助金政策科学総合研究事業 (H29-ICT-一般-004)「保健医療介護現場の課題に即したビッグデータ解析を実践するための臨床疫学・統計・医療情報技術を磨く高度人材育成プログラムの開発と検証に関する研究」の小林班での、SQLでのNDBからのデータ抽出プロジェクトのためのrepositoryでした。
- `sql/`: SQLのコードが格納されています。
- `TestDBSetup/`: Mac OSXでOracle DBの環境構築及び、構築したDBにNDBのサンプルデータをinsertするためのコードが格納されています。詳細は、[TestDBSetup/README.md](https://github.com/harakonan/research-public/tree/master/ndb/NDB-UTDPH/TestDBSetup/README.md)を見て下さい。

## SQLでの作業方針

1. 最終的な`TABLE`を明確にする
1. どの変数が必要かを選定する
1. 作業領域のキャパシティを考慮する
	- 完全に分割して作業可能な場合には一つずつ順番に扱っていく
	- 中間テーブルが必要な場合にも、必要な変数に応じて内容を出来るだけ絞り込んだ`TABLE`を用意する
	- 必要なくなった`TABLE`は適宜`DROP`していく
1. 一時表領域のキャパシティを考慮する
	- 一時表領域への書き込みが必要になるのは大きく4つ
		- ソートが必要になるコマンド
		- `UNION ALL`
		- サブクエリ
		- 3つ以上のオブジェクトの`JOIN`
	- ソートが必要になるコマンド
		- `UNION`等は避ける
	- `UNION ALL`
		- 必要な`TABLE`を準備し、`INSERT`する
	- サブクエリ
		- 内容を絞り込んだ`TABLE`を用意し、サブクエリを利用せずに`JOIN`する
	- 3つ以上のオブジェクトの`JOIN`
		- 容量が大きくなることが予想される場合には、`TABLE`は2つずつ`JOIN`する

1. 本番環境はOracle Exadataであることを意識する

1. テスト環境から本番環境に移行する際に変更すべき点
	1. パラレル実行指定

		  alter session force parallel ddl parallel [5-30]
		  alter session force parallel dml parallel [5-30]
		  alter session force parallel query parallel [5-30]

	1. テーブル名の変更: 現時点で判明しているのは以下の項目
		- マスターファイル以外は`VIEW`にアクセスする形式になっているので、TNDS_T -> CMDV_Tに全て置換
			- 全置換をした場合には、`TNDS_T_TRANS_JC_YEAR`等のマスターファイルはそのままでよいことに注意する
		- `TNDS_M_RCP_ID3` -> `TNDS_M_ID3`

	1. Encodingの設定
		- Logファイルを作成する場合には、文字化けを防ぐためにsqlファイルのencodingをSJISに設定する
			- UTF-8からSJISへの一括変換については[このページ](https://github.com/harakonan/tools/blob/master/sh/utf8-cp932.sh)を参照

## ジェネリック医薬品の使用割合の推移の記述

- 学術研究の名称：後発医薬品の普及状況および関連要因に関する研究
- 学術研究の概要：後発医薬品（ジェネリック薬）の先発医薬品（ブランド薬）の使用割合について、性別、年齢、疾患、効能、効能の変更・副作用情報の公表（学術的エビデンスを含む）、自己負担割合、当該地域の医薬分業割合、後発医薬品の発売時期からの経過期間との関連について明らかにする。
- 詳細
	- [テスト環境用のクエリのREADME.md](https://github.com/harakonan/research-public/tree/master/ndb/NDB-UTDPH/sql/test/README.md)
	- [本番環境用のクエリのREADME.md](https://github.com/harakonan/research-public/tree/master/ndb/NDB-UTDPH/sql/main/README.md)
