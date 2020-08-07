#!/usr/bin/env bash

url_encode() {
    perl -MURI::Escape -e "print uri_escape(\$ARGV[0]);" -- "$1"
}

rm -f not_archived.txt archived.txt

while read -r url; do
    res=$(curl -s "https://archive.org/wayback/available?url=$(url_encode "$url")" | jq .archived_snapshots.closest.url)

    if [[ $res == null ]]; then
        printf '%4d NON %s\n' $((++i)) "$url"
        echo "$url" >> not_archived.txt
        curl -s "https://web.archive.org/save/$url" > /dev/null
        sleep 4
    else
        printf '%4d OUI %s\n' $((++i)) "$url"
        echo "\"$url\": $res," >> archived.txt
    fi
done
