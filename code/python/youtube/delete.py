#!/usr/bin/env python3

import sys
import time

from google import oauth
from utils import dataproc


def delete(session, item_id):
    url = f'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&id={item_id}'
    res = session.delete(url)
    print(res.status_code)
    time.sleep(1)


if __name__ == '__main__':
    for line in dataproc.clean_reader(sys.stdin):
        delete(oauth.session, line)
