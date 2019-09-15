#!/usr/bin/env python3

import sys

import requests


def fetch(playlist_id, api_key):
    res = ''
    next_page = ''

    while True:
        url = 'https://www.googleapis.com/youtube/v3/playlistItems?playlistId={}&maxResults=50&part=snippet&key={}&pageToken={}'.format(playlist_id, api_key, next_page)
        result = requests.get(url).json()

        for item in result['items']:
            res += '<a href="https://www.youtube.com/watch?v={}">{}</a><br>\n'.format(item['snippet']['resourceId']['videoId'], item['snippet']['title'])

        if not 'nextPageToken' in result:
            break

        next_page = result['nextPageToken']

    return res


if __name__ == '__main__':
    print(fetch(sys.argv[1], sys.argv[2]), end = '')
