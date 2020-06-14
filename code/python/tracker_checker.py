#!/usr/bin/env python3

import os
import socket
import struct
import sys

from concurrent import futures
from urllib import parse

import bencode
import requests


def tracker_connect(url):
    resp = requests.get(url, timeout = 10, params = {
        'info_hash': b'\xc7\x8a\x7b\xe0\x60\x93\x4e\x28\x6b\xb0\x69\xfc\xb9\x49\x65\x6b\xc6\x5d\x48\x11',
        'peer_id': '-SU2291-SOVIETRUSSIA',
        'port': 6881,
        'downloaded': 0,
        'uploaded': 0,
        'left': 0
    })

    if not bencode.decode(resp.content):
        raise ValueError


def tracker_send(tracker):
    trans_id = os.urandom(4)
    message = struct.pack('>ql4s', 0x41727101980, 0, trans_id)
    address = (tracker.hostname, tracker.port)
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(10)
    sock.sendto(message, address)
    data = sock.recv(32)
    sock.close()
    parsed_data = struct.unpack('>l4sq', data)

    if parsed_data[0] != 0 or parsed_data[1] != trans_id:
        raise ValueError


def check_tracker(url):
    tracker = parse.urlparse(url)
    if not tracker.scheme or not tracker.hostname:
        raise ValueError

    try:
        if tracker.scheme == 'http':
            tracker_connect(url)
        elif tracker.scheme == 'udp':
            tracker_send(tracker)

        print(url)
    except Exception:
        pass


def process(data_list):
    future_list = []
    pool = futures.ThreadPoolExecutor()

    for line in data_list:
        future = pool.submit(check_tracker, line.strip())
        future_list.append(future)

    futures.wait(future_list)


if __name__ == '__main__':
    process(sys.stdin)
