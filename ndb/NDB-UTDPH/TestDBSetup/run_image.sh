# !bin/bash

docker run --name ndb-dummy -p 1521:1521 -p 5500:5500 -e ORACLE_SID=NDBdummyCDB -e ORACLE_PDB=NDBdummy -e ORACLE_PWD=o2WZcfM79ktm oracle/database:12.2.0.1-ee
