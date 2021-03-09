#!/usr/bin/env python3

import sys

import bencode

from torrent import parser
from utils import dataproc


def protected(t, p):
    return any(1 for i in t['trackers'] if p.search(i[0]))


def update(f, t):
    data = bencode.encode(t)
    f.seek(0)
    f.write(data)
    f.truncate()


if __name__ == '__main__':
    with open(sys.argv[1], 'r+b') as f:
        torrent = parser.load(f)

        if protected(torrent, parser.PROTECTED_PATTERN):
            exit(1)

        torrent['trackers'] = [[i] for i in dataproc.clean_reader(sys.stdin)]
        update(f, torrent)
