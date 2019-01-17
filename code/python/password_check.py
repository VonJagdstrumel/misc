#!/usr/bin/env python3

import time
import sys
import hashlib

import requests

for password in sys.stdin:
    password = password.strip()

    if not password:
        continue

    full_hash = hashlib.sha1(password.encode()).hexdigest()
    hash_suffix = full_hash[5:40].upper()

    time.sleep(1.5)
    r = requests.get('https://api.pwnedpasswords.com/range/' + full_hash[0:5])

    if r.text.find(hash_suffix) > 0:
        print(password)
