#!/usr/bin/env python3

import sys
import time

from google import oauth
from utils import dataproc


def insert(session, playlist_id, video_id):
    url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet'
    payload = {
        "snippet": {
            "playlistId": playlist_id,
            "resourceId": {
                "kind": "youtube#video",
                "videoId": video_id
                }
            }
        }
    res = session.post(url, json=payload)
    print(res.status_code)
    time.sleep(1)


if __name__ == '__main__':
    for line in dataproc.clean_reader(sys.stdin):
        insert(oauth.session, sys.argv[1], line)
