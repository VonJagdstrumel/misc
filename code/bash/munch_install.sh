#!/bin/bash
# Download, extract and prepare a Nginx+PHP+MariaDB bundle wich we call Munch

mkdir binaries
mkdir binaries/home
mkdir data
mkdir data/conf
mkdir data/www

downloadMask=$(curl "https://www.adminer.org/" | grep -oE "[0-9.]+/adminer-[0-9.]+.php")
wget https://www.adminer.org/static/download/$downloadMask
mv adminer-*.php binaries/home/adminer.php

downloadMask=$(curl "ftp://ftp.igh.cnrs.fr/pub/mariadb/" | grep -oE "mariadb-[0-9.]+" | sort -V | tail -1)
wget ftp://ftp.igh.cnrs.fr/pub/mariadb/$downloadMask/winx64-packages/$downloadMask-winx64.zip
unzip $downloadMask-winx64.zip
rm $downloadMask-winx64.zip
mv mariadb-*-winx64 binaries/mariadb

downloadMask=$(curl "http://nginx.org/download/" | grep -oE "nginx-[0-9.]+\.zip" | sort -V | tail -1)
wget http://nginx.org/download/$downloadMask
unzip $downloadMask
rm $downloadMask
mv nginx-* binaries/nginx

downloadMask=$(curl "http://windows.php.net/downloads/releases/" | grep -oE "php-[0-9.]+-nts-Win32-VC14-x64\.zip" | sort -V | tail -1)
wget http://windows.php.net/downloads/releases/$downloadMask
unzip $downloadMask -d binaries/php
rm $downloadMask

find binaries -name "*.pdb" -o -name "*.lib" -type f -delete
find binaries -depth -type d -empty -exec rmdir {} \;
rm -r binaries/mariadb/include
rm -r binaries/mariadb/mysql-test
rm -r binaries/mariadb/sql-bench

cp binaries/mariadb/my-medium.ini data/conf/my.ini
cp binaries/nginx/conf/nginx.conf data/conf/nginx.conf
cp binaries/php/php.ini-development data/conf/php.ini
