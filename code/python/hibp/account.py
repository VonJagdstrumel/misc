#!/usr/bin/env python3

import sys
import time

import requests

from utils import dataproc


def check(ident):
    time.sleep(1.5)
    url = f'https://api.haveibeenpwned.com/unifiedsearch/{ident}'
    r = requests.get(url)

    if r.status_code == 200:
        return url


if __name__ == '__main__':
    for line in dataproc.clean_reader(sys.stdin):
        res = check(line)
        print(res)
