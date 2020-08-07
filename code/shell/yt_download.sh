#!/usr/bin/env bash

while IFS='=' read -rd\& key val; do
    [[ $key == v ]] && id=$val
    [[ $key == t ]] && ss=$val
done <<< "${1#*\?}&"

while IFS='=' read -rd\& key val; do
    [[ $key != player_response ]] && continue
    s_url=$(perl -MURI::Escape -e 'print uri_unescape(<>)' <<< "$val" | jq -r '.streamingData.formats[-1].url')
    break
done <<< "$(curl -s "https://www.youtube.com/get_video_info?video_id=$id")&"

~/Programs/Console/ffmpeg -loglevel warning -hide_banner -y -i "$s_url" -map 0:a -ss "${ss-0}" ${2+-t $2} -c:a libmp3lame -b:a 256k "$id${ss+@$ss}.mp3"
