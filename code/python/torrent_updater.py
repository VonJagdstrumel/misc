#!/usr/bin/env python3

import sys
import os
import re

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


def process(search_path):
    file_list = os.listdir(search_path)
    regex = re.compile(r'(archive\.org|ehtracker\.org|yggtorrent\.com|debian\.org)')

    for file_name in file_list:
        if not file_name.endswith('.fastresume'):
            continue

        file_path = search_path + '/' + file_name
        fd = open(file_path, 'r+b')
        content = fd.read()
        torrent = bencode.decode(content)

        if is_protected(torrent):
            continue

        torrent['trackers'] = build_tracker_list()
        content = bencode.encode(torrent)
        fd.seek(0)
        fd.write(content)
        fd.close()


if __name__ == '__main__':
    process(sys.argv[1])
