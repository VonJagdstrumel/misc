#!/usr/bin/env bash

path="$1"
size="$(stat -c%s "$path")"
expire="$(date +%s%3N)"
name="$(basename "$path")"

json="$(curl -s https://hubic.com/home/browser/prepareUpload/ \
    --compressed \
    -H "X-Token: $2" \
    -H "Cookie: PHPSESSID=$3" \
    -d "max_file_size=$size" \
    -d max_file_count=1 \
    -d "expires=$expire" \
    -d path=/default/ \
    -d redirect= \
    -d "name=$name")"

url="$(perl -MJSON::PP -e '$res = decode_json($ARGV[0]); print $res->{answer}->{hubic}->{url}' -- "$json")"
signature="$(perl -MJSON::PP -e '$res = decode_json($ARGV[0]); print $res->{answer}->{hubic}->{signature}' -- "$json")"

curl "$url/default/" \
    -o /dev/null \
    --limit-rate 6000k \
    --compressed \
    -F "max_file_size=$size" \
    -F max_file_count=1 \
    -F "expires=$expire" \
    -F redirect= \
    -F "signature=$signature" \
    -F "name=$name" \
    -F "file1=@$path"