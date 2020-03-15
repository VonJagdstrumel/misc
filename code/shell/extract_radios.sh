#!/usr/bin/env bash

curl -L https://addons.mozilla.org/firefox/downloads/file/3521176/ > worldwide_radio.zip
unzip -ju worldwide_radio 'content/stations/*.json' -d stations
list=$(jq -r '[.[].site_url] | @csv' radios.json)
sed '1s/^/[/;s/^}$/},/;$s/,$/]/' stations/*.json | \
    jq "[.[][][] | select(.site_url == ($list))]" | \
    tee radios.json | \
    jq -r '"#EXTM3U", (.[] | "#EXTINF:-1," + .name, .radio_url)' > radios2.m3u8
rm -rf worldwide_radio.zip stations
