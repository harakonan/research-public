# Dockerの基本操作

Imageのbuild
```
$ 
```

ImageからContainerを起動
```
$ docker run --name IMAGE_ID -p xxxx:xxxx -e KEY=VALUE
```

終了するには、別ターミナルで
```
$ docker stop IMAGE_ID
```

この状態だと
```
$ docker start IMAGE_ID
```

ですぐに再開可能
Containerを完全に削除するには
```
$ docker rm CONTAINER_ID
```

とする（CONTAINER_IDには、`$ docker ps` で表示されたCONTAINER IDを入れる（最初の４桁くらいでok））

Containerを削除したとしても、
```
$ docker rmi IMAGE_ID
```

でimageの削除を実行しない限りは,imageは残るので、「ImageからContainerを起動」から再開することができる

このcontainerの起動作業を繰り返していると、
```
[FATAL] [DBT-06604] The location specified for 'Fast Recovery Area Location' has insufficient free space.
```

というエラーが出て、うまくいかなくなる
この時には
```
$ docker system prune
```

を行なって、docker内の容量整理を行う