#!/usr/bin/env python3

import time
import sys

import requests

for account in sys.stdin:
    account = account.strip()

    if not account:
        continue

    if account.find('@') > -1:
        time.sleep(1.5)
        r = requests.get('https://haveibeenpwned.com/api/v2/pasteaccount/' + account)

        if r.status_code == 200:
            print('https://haveibeenpwned.com/api/v2/pasteaccount/' + account)

    time.sleep(1.5)
    r = requests.get('https://haveibeenpwned.com/api/v2/breachedaccount/' + account)

    if r.status_code == 200:
        print('https://haveibeenpwned.com/api/v2/breachedaccount/' + account)
