#!/usr/bin/env python3

import sys
import re

import bencode


def parse(content):
    res = ''
    torrent = bencode.decode(content)
    regex = re.compile(r'(archive\.org|ehtracker\.org|yggtorrent\.com|debian\.org)')

    for tracker in torrent['trackers']:
        if not regex.search(tracker[0]):
            res += tracker[0] + '\n'

    return res


if __name__ == '__main__':
    print(parse(sys.stdin.buffer.read()), end = '')
