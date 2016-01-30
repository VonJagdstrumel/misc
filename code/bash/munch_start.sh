#!/bin/bash

cd binaries/mariadb
./bin/mysqld --defaults-file=my.ini &
pids=$!:
cd ../../binaries/nginx
./nginx &
pids+=$!:
cd ../../binaries/php
./php-cgi.exe -b 127.0.0.1:9000 &
pids+=$!
cd ../..
echo $pids > .lock
