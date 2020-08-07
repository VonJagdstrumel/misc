#!/usr/bin/env python3

import os
import re
import sys

import bencode


def build_tracker_list():
    new_list = []
    valid_list = """"""

    for i in valid_list.split('\n'):
        new_list.append([i])

    return new_list


def is_protected(torrent):
    for tracker in torrent['trackers']:
        if regex.search(tracker[0]):
            return True

    return False


if __name__ == '__main__':
    file_list = os.listdir(sys.argv[1])
    regex = re.compile(r'(archive\.org|ehtracker\.org|yggtorrent\.com|debian\.org)')

    for file_name in file_list:
        if not file_name.endswith('.fastresume'):
            continue

        with open(sys.argv[1] + '/' + file_name, 'r+b') as f:
            content = f.read()
            torrent = bencode.decode(content)

            if is_protected(torrent):
                continue

            torrent['trackers'] = build_tracker_list()
            content = bencode.encode(torrent)
            f.seek(0)
            f.write(content)
            f.close()
