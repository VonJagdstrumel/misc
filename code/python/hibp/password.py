#!/usr/bin/env python3

import hashlib
import sys
import time

import requests

from utils import dataproc


def check(pw):
    full_hash = hashlib.sha1(pw.encode()).hexdigest()
    hash_suffix = full_hash[5:40].upper()

    time.sleep(1.5)
    r = requests.get(f'https://api.pwnedpasswords.com/range/{full_hash[0:5]}')

    if r.text.find(hash_suffix) > 0:
        return pw


if __name__ == '__main__':
    for line in dataproc.clean_reader(sys.stdin):
        res = check(line)
        print(res)
