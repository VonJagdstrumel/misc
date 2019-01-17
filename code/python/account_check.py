#!/usr/bin/env python3

import time
import sys

import requests

for account in sys.stdin:
    account = account.strip()

    if not account:
        continue

    time.sleep(1.5)
    r = requests.get('https://api.haveibeenpwned.com/unifiedsearch/' + account)

    if r.status_code == 200:
        print('https://api.haveibeenpwned.com/unifiedsearch/' + account)
