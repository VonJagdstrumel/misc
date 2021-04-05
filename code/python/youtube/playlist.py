#!/usr/bin/env python3

import sys

from google import oauth


def fetch_iter(session, playlist_id):
    next_page = ''

    while True:
        url = f'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId={playlist_id}&maxResults=50&pageToken={next_page}'
        res = session.get(url).json()

        for item in res['items']:
            # print(f"{item['snippet']['resourceId']['videoId']} {item['id']}")
            yield (item['snippet']['resourceId']['videoId'],
                   item['snippet']['title'])

        if 'nextPageToken' not in res:
            break

        next_page = res['nextPageToken']


def fetch_html(playlist_id, access_token):
    gen = (f'<a href="https://www.youtube.com/watch?v={vid}">{title}</a><br>'
           for vid, title in fetch_iter(playlist_id, access_token))
    return '\n'.join(gen)


if __name__ == '__main__':
    data = fetch_html(oauth.session, sys.argv[1])
    print(data)
