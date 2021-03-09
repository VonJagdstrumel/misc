#!/usr/bin/env python3

from concurrent import futures
from urllib import request
import json
import os
import re
import sys


def fetch_images(post_url, img_list):
    splitted_url = post_url.split('/')
    host = splitted_url[2].replace('.tumblr.com', '')
    post_dir = os.path.join(host, splitted_url[4])
    os.makedirs(post_dir, exist_ok=True)

    for img_url in img_list:
        try:
            img_url = re.sub(r'_(?:250|400|500|540|640)\.(jpg|png)',
                             r'_1280.\1', img_url)
            file_name = re.sub(r'.*/', '', img_url)
            file_path = os.path.join(post_dir, file_name)

            if not os.path.isfile(file_path):
                print(file_path)
                request.urlretrieve(img_url, file_path)
        except OSError as e:
            print(e)


if __name__ == '__main__':
    future_list = []
    pool = futures.ThreadPoolExecutor()
    json_obj = json.load(sys.stdin)

    for url in json_obj:
        future = pool.submit(fetch_images, url, json_obj[url])
        future_list.append(future)

    futures.wait(future_list)
