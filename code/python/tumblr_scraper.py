#!/usr/bin/env python3

import sys
import re
import os
import json

from concurrent import futures
from urllib import request


def fetch_image(post_url, img_list):
    splitted_url = post_url.split('/')
    host = splitted_url[2].replace('.tumblr.com', '')
    post_dir = os.path.join(host, splitted_url[4])
    os.makedirs(post_dir, exist_ok = True)

    for img_url in img_list:
        img_url = re.sub(r'_(?:250|400|500|540|640)\.(jpg|png)', r'_1280.\1', img_url)
        file_name = re.sub(r'.*/', '', img_url)
        file_path = os.path.join(post_dir, file_name)
        request.urlretrieve(img_url, file_path)


future_list = []
pool = futures.ThreadPoolExecutor()
json_obj = json.load(sys.stdin)

for url in json_obj:
    future = pool.submit(fetch_image, url, json_obj[url])
    future_list.append(future)

futures.wait(future_list)
