#!/usr/bin/env python3

import sys

import requests


def fetch_iter(playlist_id, api_key):
    next_page = ''

    while True:
        url = f'https://www.googleapis.com/youtube/v3/playlistItems?playlistId={playlist_id}&maxResults=50&part=snippet&key={api_key}&pageToken={next_page}'
        res = requests.get(url).json()

        for item in res['items']:
            yield (item['snippet']['resourceId']['videoId'],
                   item['snippet']['title'])

        if 'nextPageToken' not in res:
            break

        next_page = res['nextPageToken']


def fetch_html(playlist_id, api_key):
    gen = (f'<a href="https://www.youtube.com/watch?v={vid}">{title}</a><br>'
           for vid, title in fetch_iter(playlist_id, api_key))
    return '\n'.join(gen)


if __name__ == '__main__':
    data = fetch_html(sys.argv[1], sys.argv[2])
    print(data)
