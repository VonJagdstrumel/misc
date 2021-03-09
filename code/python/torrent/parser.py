#!/usr/bin/env python3

import re
import sys

import bencode

PROTECTED_PATTERN = re.compile(
    r'(archive\.org|ehtracker\.org|yggtracker.cc|debian\.org)')


def load(f):
    return bencode.decode(f.read())


def from_torrent(t, p):
    return '\n'.join(i[0] for i in t['trackers'] if not p.search(i[0]))


if __name__ == '__main__':
    torrent = load(sys.stdin.buffer)
    t_list = from_torrent(torrent, PROTECTED_PATTERN)
    print(t_list)
