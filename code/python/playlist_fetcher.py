#!/usr/bin/env python3

import sys

import requests

playlist_id = sys.argv[1]
api_key = sys.argv[2]
next_page = ''

while True:
    url = 'https://content.googleapis.com/youtube/v3/playlistItems?playlistId={}&maxResults=50&part=snippet&key={}&pageToken={}'.format(playlist_id, api_key, next_page)
    result = requests.get(url).json()

    for item in result['items']:
        print('<a href="https://www.youtube.com/watch?v={}">{}</a><br>'.format(item['snippet']['resourceId']['videoId'], item['snippet']['title']))

    if not 'nextPageToken' in result:
        break

    next_page = result['nextPageToken']
