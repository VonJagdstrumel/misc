#!/usr/bin/env bash

rm -f not_archived.txt archived.txt

while IFS= read -r url; do
    enc_url=$(perl -MURI::Escape -e 'print uri_escape(<>)' <<< "$url")
    res=$(curl -s "https://archive.org/wayback/available?url=$enc_url" | jq .archived_snapshots.closest.url)

    if [[ $res == null ]]; then
        printf '%4d Failure %s\n' $((++i)) "$url"
        echo "$url" >> not_archived.txt
        curl -s "https://web.archive.org/save/$url" > /dev/null
        sleep 4
    else
        printf '%4d Success %s\n' $((++i)) "$url"
        echo "\"$url\": $res," >> archived.txt
    fi
done
