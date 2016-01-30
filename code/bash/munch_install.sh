#!/bin/bash
# Download, extract and prepare a Nginx+PHP+MariaDB bundle wich we call Munch

function replace {
    sed -ri "s/$1/$2/gm" $3
}

function scrapelast {
    curl $1 | grep -oE $2
}

function firstoccur {
    awk "/$1/{ print NR; exit }" $2
}

# Preparing some path vars
tmpfile=$(mktemp)
serverbase=$(pwd)
phpbase=$serverbase'/binaries/php'
mariadbbase=$serverbase'/binaries/mariadb'
nginxbase=$serverbase'/binaries/nginx'

# Creating directories
mkdir binaries
mkdir www

# Download and setup adminer
downloadMask=$(scrapelast https://www.adminer.org/ '[0-9.]+/adminer-[0-9.]+.php')
wget https://www.adminer.org/static/download/$downloadMask
mkdir binaries/adminer
mv adminer-*.php binaries/adminer/adminer.php

# Download and setup mariadb
downloadMask=$(scrapelast ftp://ftp.igh.cnrs.fr/pub/mariadb/ 'mariadb-[0-9.]+' | sort -V | tail -1)
wget ftp://ftp.igh.cnrs.fr/pub/mariadb/$downloadMask/winx64-packages/$downloadMask-winx64.zip
unzip $downloadMask-winx64.zip
rm $downloadMask-winx64.zip
mv mariadb-*-winx64 binaries/mariadb

rm -rf binaries/mariadb/include
rm -r binaries/mariadb/mysql-test
rm -r binaries/mariadb/sql-bench

npath=$(cygpath -d $mariadbbase | sed 's/\\/\//g')
cat > $mariadbbase/my.ini <<EOF
[mysqld]
basedir = "$npath/"
datadir = "$npath/data/"
socket = "$npath/mysql.sock"
log_error = "$npath/data/mysql_error.log"
innodb_data_home_dir = "$npath/data/"
innodb_log_group_home_dir = "$npath/data/"
bind-address = 127.0.0.1
sql_mode = ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
EOF

# Download and setup nginx
downloadMask=$(scrapelast http://nginx.org/download/ 'nginx-[0-9.]+\.zip' | sort -V | tail -1)
wget http://nginx.org/download/$downloadMask
unzip $downloadMask
rm $downloadMask
mv nginx-* binaries/nginx

npath=$(cygpath -d $serverbase/www | sed -r 's/\\/\\\//g')
sed -i "44s/html;\$/\"$npath\";/" $nginxbase/conf/nginx.conf
sed -i '46i\            autoindex on;' $nginxbase/conf/nginx.conf
sed -i '66,72s/#//' $nginxbase/conf/nginx.conf
sed -i "67s/html;\$/\"$npath\";/" $nginxbase/conf/nginx.conf
sed -i '70s/\/scripts\$fastcgi_script_name;$/$document_root$fastcgi_script_name;/' $nginxbase/conf/nginx.conf

# Download and setup php
downloadMask=$(scrapelast http://windows.php.net/downloads/releases/ 'php-[0-9.]+-Win32-VC14-x64\.zip' | sort -V | tail -1)
wget http://windows.php.net/downloads/releases/$downloadMask
unzip $downloadMask -d binaries/php
rm $downloadMask

cp binaries/php/php.ini-development binaries/php/php.ini
replace '^; (extension_dir = )"ext"$' '\1"'$(cygpath -d $phpbase/ext | sed 's/\\/\\\\/g')'"' $phpbase/php.ini
replace '^;(date.timezone =)$' '\1 Europe\/Paris' $phpbase/php.ini
replace '^;(extension=)' '\1' $phpbase/php.ini
replace '^(extension=)(php_interbase|php_oci8_12c|php_pdo_firebird|php_pdo_oci|php_snmp)' ';\1\2' $phpbase/php.ini

# Download and setup xdebug
downloadMask=$(scrapelast https://xdebug.org/files/ 'php_xdebug-([0-9.]|rc)+-[0-9.]+-vc14-x86_64\.dll' | sort -V | tail -1)
wget https://xdebug.org/files/$downloadMask
mv $downloadMask binaries/php/php_xdebug.dll

cat > $tmpfile <<EOF

zend_extension = "$(cygpath -d $phpbase)\php_xdebug.dll"
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_host=127.0.0.1
xdebug.remote_port=9009
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_autostart = false
xdebug.dump_globals=1
xdebug.dump=COOKIE,FILES,GET,POST,REQUEST,SERVER,SESSION
xdebug.dump.SERVER=REMOTE_ADDR,REQUEST_METHOD,REQUEST_URI
xdebug.show_local_vars=1
xdebug.show_mem_delta=1
xdebug.collect_includes=1
xdebug.collect_vars=1
xdebug.collect_params=4
xdebug.collect_return=1
xdebug.auto_trace=0
xdebug.trace_options=0
xdebug.trace_format=0
xdebug.trace_output_dir=""
xdebug.trace_output_name="trace.%t"
xdebug.profiler_enable=0
xdebug.profiler_append=1
xdebug.profiler_enable_trigger=1
xdebug.profiler_output_dir=""
xdebug.profiler_output_name="cachegrind.out.%s.%t"

EOF
insertpos=$(($(firstoccur '^extension=' $phpbase/php.ini)-1))
sed -i "${insertpos}r $tmpfile" $phpbase/php.ini


# Remove debug symbols, linkable libraries and empty directories
find binaries -name *.pdb -type f -delete
find binaries -name *.lib -type f -delete

# Fix NTFS permissions
takeown /f . /r
icacls . /reset /T