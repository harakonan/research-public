# Oracle DBの環境構築（Mac OSX）

## Contents

<!--ts-->
   * [Oracle DBの環境構築（Mac OSX）](#oracle-dbの環境構築mac-osx)
      * [Contents](#contents)
      * [0. Overview](#0-overview)
         * [このフォルダにある他のMarkdownファイルの説明](#このフォルダにある他のmarkdownファイルの説明)
      * [1. Docker for Macのインストール、設定](#1-docker-for-macのインストール設定)
         * [Reference](#reference)
         * [インストール、設定](#インストール設定)
      * [2. OracleDBのdocker-imageのbuild](#2-oracledbのdocker-imageのbuild)
         * [Reference](#reference-1)
         * [事前準備](#事前準備)
         * [Imageをbuild](#imageをbuild)
      * [3. Oracle Instant Clientの設定](#3-oracle-instant-clientの設定)
         * [Reference](#reference-2)
         * [Oracle Instant Clientをダウンロード](#oracle-instant-clientをダウンロード)
         * [PATHを通す](#pathを通す)
         * [sqlplusのuser-nameの設定](#sqlplusのuser-nameの設定)
         * [sqlplusについて便利な設定](#sqlplusについて便利な設定)
      * [4. Docker containerの起動、sqlplusでの接続](#4-docker-containerの起動sqlplusでの接続)
         * [事前準備](#事前準備-1)
         * [Imageからcontainerを起動](#imageからcontainerを起動)
         * [Databaseの設定、サンプルデータの挿入](#databaseの設定サンプルデータの挿入)
         * [sqlplusでの接続](#sqlplusでの接続)
         * [テーブルの確認](#テーブルの確認)
      * [5. 終了、再起動](#5-終了再起動)
         * [終了](#終了)
         * [再起動](#再起動)
      * [6. Dockerのclean re-install](#6-dockerのclean-re-install)

<!-- Added by: harakonan, at:  -->

<!--te-->

## 0. Overview

- Oracle DBはMac OSXに対応していないので、Dockerを使ってOracle DBのimageを入手し、Containerを起動する。
- sqlplusを使ってOracle DBに接続し、サンプルデータを挿入する。
- 必要なスペック: ストレージの空き容量30GB以上、メモリ16GB以上での動作は確認済み。
- 2018/08/17にmacOS High Sierra version 10.13.6、Docker version 18.03.1-ce-mac65 (24312)での動作を確認。

### このフォルダにある他のMarkdownファイルの説明

- `docker.md`: Dockerの基本的な操作方法が記載されている。

## 1. Docker for Macのインストール、設定
### Reference

* [Get started with Docker for Mac | Docker Documentation](https://docs.docker.com/docker-for-mac/)
* [Docker入門 (全11回) - プログラミングならドットインストール](http://dotinstall.com/)

### インストール、設定
- [Install Docker for Mac | Docker Documentation](https://docs.docker.com/docker-for-mac/install/)
でStable channelをインストールする。
- Docker -> Preferences -> AdvancedでMemoryを8.0GBに変更する。  
以下のようになる（CPUの数は環境によって異なる）。
<img src="https://github.com/harakonan/images/blob/master/docker-memory-setting.png" width="500">  

- Docker -> Preferences -> DiskでDisk image sizeを96.0GBに変更する。  
以下のようになる。
<img src="https://github.com/harakonan/images/blob/master/docker-disk-size-setting.png" width="500">

## 2. OracleDBのdocker-imageのbuild
### Reference

* [docker-images/OracleDatabase at master · oracle/docker-images](https://github.com/oracle/docker-images/tree/master/OracleDatabase) (公式)
* [OS X 10.11で，Oracle Database 12cのDocker Imageを使ってみた - Qiita](http://qiita.com/lethe2211/items/0bb493fa93a0088cfac9)
* [公式 Oracle Database の Docker イメージを構築 - #chiroito ’s blog](http://chiroito.hatenablog.jp/entry/2016/12/28/235627)

### 事前準備
- 作業ディレクトリの作成

`Workspace`に`Oracle/product/database`というフォルダを作成し、そのフォルダにworking directoryを設定する。
`Workspace`は各自好きなディレクトリを設定する。ここでは、例としてホームディレクトリにWorkspaceというフォルダを作成する。

```
$ cd $HOME
$ mkdir Workspace
$ cd Workspace
$ mkdir -p Oracle/product/database
$ cd Oracle/product/database
```

- Oracleの公式docker-imageのgitをクローン

```
$ git clone https://github.com/oracle/docker-images.git
$ cd docker-images/OracleDatabase/dockerfiles
```
gitコマンドを初めて使う場合には、Xcodeのインストールを求められるので、指示に従う。

- Oracle DBのファイルをダウンロード
[Oracle Database 12c Release 2 for Linux x86-64 Downloads](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/oracle12c-linux-12201-3608234.html)
から、`linuxx64_12201_database.zip`をダウンロードしておく。
ダウンロードの際に、Oracleのアカウントを作成する必要がある。
ダウンロードフォルダにそのまま置いておき、zipファイルは解凍しないように注意する。


- Oracle DBのファイルをダウンロードフォルダから指定の場所に移動

```
$ cp $HOME/Downloads/linuxx64_12201_database.zip 12.2.0.1/
```

### Imageをbuild
```
$ ./buildDockerImage.sh -v 12.2.0.1 -e -i

# PCのスペックによってはかなり時間がかかる
# 以下のように表示されたら終了
Oracle Database Docker Image for 'ee' version 12.2.0.1 is ready to be extended:
 --> oracle/database:12.2.0.1-ee
Build completed in 395 seconds.
```

- 以下のコマンドで無事imageがbuildされていることを確認できる。下のように表示されれば成功。
```
$ docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
oracle/database     12.2.0.1-ee         5b3356b0fe40        3 weeks ago         15GB
oraclelinux         7-slim              08a01cc7be97        2 months ago        114MB
```

## 3. Oracle Instant Clientの設定
- sqlplusコマンドを用いてOracle DBへの接続する

### Reference
- [Oracle Instant Client Downloads](http://www.oracle.com/technetwork/jp/database/features/instant-client/index-097480.html)
- [Mac OS XからOracle Databaseへ接続する方法あれこれ | 正論紅茶](https://www.tank-sakurai.com/mac-os-x_oracle-database/)
- [OS X 10.11で，Oracle Database 12cのDocker Imageを使ってみた - Qiita](http://qiita.com/lethe2211/items/0bb493fa93a0088cfac9)

### Oracle Instant Clientをダウンロード
[公式サイト](http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html)から、Instant Clientをダウンロードする。

* `instantclient-basic-macos.x64-12.1.0.2.0.zip`
* `instantclient-sqlplus-macos.x64-12.1.0.2.0.zip`

の二つ
解凍すると、`instantclient_12_1`という名称のフォルダになるので、二つのフォルダをマージし、`Workspace/Oracle/product/`に格納する。

### PATHを通す
`$HOME/.bash_profile`にPATHを通す。
PATHの内容
```
# Setting PATH for Oracle Instant Client
export ORACLE_HOME=$HOME/Workspace/Oracle/product
export SQLPATH=$ORACLE_HOME/instantclient_12_1/
export PATH="$HOME/.rbenv/bin:$PATH:$SQLPATH"
export NLS_LANG=Japanese_Japan.AL32UTF8 # 文字化けを防ぐ
```
このPATHを通す作業には、一般的にvimを使うのが多いので、以下のサイトを参考にする。
[vim入門 (全18回) - プログラミングならドットインストール](https://dotinstall.com/lessons/basic_vim)
普段使っているテキストエディタがある場合には、それを使う。
vimを使う場合の具体例を以下に示す。
```
# vimの起動
$ sudo vi $HOME/.bash_profile
```
起動するとインサートモードになっているので、
```
# Setting PATH for Oracle Instant Client
export ORACLE_HOME=$HOME/Workspace/Oracle/product
export SQLPATH=$ORACLE_HOME/instantclient_12_1/
export PATH="$HOME/.rbenv/bin:$PATH:$SQLPATH"
export NLS_LANG=Japanese_Japan.AL32UTF8 # 文字化けを防ぐ
```
と記載する。
`esc`キーでコマンドモードに移り、`:wq`で保存して終了する。
ターミナルの再起動か
```
$ source $HOME/.bash_profile
```
で設定が反映される。
以下の作業で、vimを使ってファイルを編集・保存する時も同様。

### sqlplusのuser-nameの設定
sqlplusでは、初めにuser-nameの設定を行う必要がある。
まず、
```
$ uname -n
```

でlocalのホスト名を確認する。
ここでは仮に、`username.local`というホスト名であったとする。

```
$ sudo vi /etc/hosts
```

で、
```
127.0.0.1	localhost
```

となっている部分を
```
127.0.0.1	localhost username.local
```

と編集して保存する。

### sqlplusについて便利な設定
sqlplusを実行すると、`$HOME/oradiag_<username>`というディレクトリが自動生成されるので、それを自動的に削除するよう設定する。

`$ORACLE_HOME`の直下に`network/admin`というディレクトリを作る。
このディレクトリに`sqlnet.ora`というファイルを作り、
```
DIAG_ADR_ENABLED=off
LOG_FILE_CLIENT=/dev/null
```
と記載して保存する。
コマンドラインでは例えば以下のようにする。
```
$ mkdir -p $ORACLE_HOME/network/admin
$ vi $ORACLE_HOME/network/admin/sqlnet.ora
```

## 4. Docker containerの起動、sqlplusでの接続
### 事前準備
- 作業ディレクトリの作成

`Workspace`に`ndb/`というフォルダを作成し、そのフォルダにworking directoryを設定する。

```
$ cd $HOME/Workspace
$ mkdir ndb/
$ cd ndb/
```

- 必要なファイルをクローン

```
$ git clone https://github.com/harakonan/research-public.git
$ mv ndb/NDB-UTDPH/ ../NDB-UTDPH/
$ cd ..
$ rm -rf research-public
$ cd NDB-UTDPH/TestDBSetup
```

- Dockerのclean up

```
$ docker ps
# もし起動しているcontainerがあったら...
$ docker stop CONTAINER_ID

$ docker ps -a
# もしcontainerがあれば...
$ docker rm CONTAINER_ID

# docker内の容量整理
$ docker system prune
```

- スクリプトの実行権限付与

```
$ chmod 755 run_image.sh
$ chmod 755 setup.sh
```

### Imageからcontainerを起動

```
$ ./run_image.sh
```

以下のように表示されれば成功。

```
...

#########################
DATABASE IS READY TO USE!
#########################
```

ここで
```
[FATAL] [DBT-06604] The location specified for 'Fast Recovery Area Location' has insufficient free space.

...

#####################################
########### E R R O R ###############
DATABASE SETUP WAS NOT SUCCESSFUL!
Please check output for further info!
########### E R R O R ###############
#####################################
```
というエラーが発生する場合には、[インストール、設定](#インストール設定)のところの、Disk image sizeをさらに大きい値に設定する。

無事起動すると、これまで使っていたターミナルは使えなくなるので、別のターミナルを開いて（Cmd+T or Cmd+N）以下の作業を行う。

### Databaseの設定、サンプルデータの挿入

```
$ ./setup.sh
```

- 途中で失敗した場合
`./drop.sh`を実行することで、作りかけのテーブルなどを全て削除することができる。
実行前に`drop.sh`にも実行権限を付与する必要がある。

- SQLの練習のためにDatabaseの設定だけを行いたい場合
`./dcl.sh`でDatabaseの設定のみ行える。
実行前に`dcl.sh`にも実行権限を付与する必要がある。

### sqlplusでの接続
- sqlplusでの接続の基本構文

```
$ sqlplus <username>/<password>@//<hostname>:<port>/<SID>
```

このコマンドを実行したディレクトリが、SQL内でもカレントディレクトリになる。

- 構成したOracleDBへの接続 (passwordはo2WZcfM79ktmに設定されている)

```
$ sqlplus NDB/o2WZcfM79ktm@//localhost:1521/NDBdummy
```

とすると、DBに接続できる。

### テーブルの確認
```
> select table_name from user_tables;
```

でテーブルの一覧が出力されれば、成功。

## 5. 終了、再起動
### 終了
- sqlplusの接続終了
`^D` or `exit`でsqlでの接続を終了できる。

- Docker containerの停止

```
$ docker stop ndb-dummy
```

ここで、`docker start ndb-dummy`とすれば、すぐに再開可能だが、PCをシステム終了や再起動してしまうとdockerのprocessは終了してしまうので、状態は保存されない。

- Docker containerの削除

```
$ docker rm ndb-dummy
```

### 再起動
- TestDBSetupフォルダをworking directoryにする

```
$ cd $HOME/Workspace/ndb/NDB-UTDPH/TestDBSetup
```

- Dockerのclean up

```
# docker内の容量整理
$ docker system prune

$ docker ps
# もし起動しているcontainerがあったら...
$ docker stop CONTAINER_ID

$ docker ps -a
# もしcontainerがあれば...
$ docker rm CONTAINER_ID
```

- Imageからcontainerを起動

```
$ ./run_image.sh
```

起動すると、これまで使っていたターミナルは使えなくなるので、別のターミナルを開いて（Cmd+T or Cmd+N）以下の作業を行う。

- Databaseの設定、サンプルデータの挿入

```
$ ./setup.sh
```

SQLの練習のためにDatabaseの設定だけを行いたい場合は`./dcl.sh`。

- sqlplusでの接続

```
$ sqlplus NDB/o2WZcfM79ktm@//localhost:1521/NDBdummy
```

これで初期状態から作業を再開することが出来る。

## 6. Dockerのclean re-install
何らかの理由でDocker自体のclean re-installが必要になった時に行う。

- dockerfilesフォルダをworking directoryにする

```
$ cd $HOME/Workspace/Oracle/product/database/docker-images/OracleDatabase/dockerfiles
```

- Imageをbuild

```
$ ./buildDockerImage.sh -v 12.2.0.1 -e -i
```

Buildが成功すれば、後は[再起動](#再起動)のセクションと同じ。
