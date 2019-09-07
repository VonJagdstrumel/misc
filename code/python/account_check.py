#!/usr/bin/env python3

import sys
import time

import requests


def process(data_list):
    res = ''

    for account in data_list:
        account = account.strip()

        if not account:
            continue

        time.sleep(1.5)
        r = requests.get('https://api.haveibeenpwned.com/unifiedsearch/' + account)

        if r.status_code == 200:
            res += 'https://api.haveibeenpwned.com/unifiedsearch/' + account + '\n'

    return res


if __name__ == '__main__':
    print(process(sys.stdin), end = '')
