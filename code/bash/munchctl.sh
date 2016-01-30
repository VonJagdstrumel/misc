#!/bin/bash

case "$1" in
    start)
        cd binaries/mariadb
        ./bin/mysqld --defaults-file=my.ini &
        cd ../../binaries/php
        ./php-cgi.exe -b 127.0.0.1:9000 &
        echo $! > ../../.pid
        cd ../../binaries/nginx
        ./nginx &
        ;;
    stop)
        cd binaries/nginx
        ./nginx -s quit
        cd ../..
        /bin/kill -f $(cat .pid)
        rm .pid
        /bin/kill -f $(cat binaries/mariadb/data/$(uname -n).pid)
        ;;
    restart)
        stop && start
        ;;
    *)
        cat <<EOF
Usage: $0 start
       $0 stop
       $0 restart
EOF
        exit 1
        ;;
esac
