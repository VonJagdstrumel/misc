#!/usr/bin/env python3

import sys
import re

import bencode

content = sys.stdin.buffer.read()
torrent = bencode.decode(content)
regex = re.compile(r'(archive\.org|ehtracker\.org|yggtorrent\.com|debian\.org)')

for tracker in torrent['trackers']:
    if not regex.search(tracker[0]):
        print(tracker[0])
