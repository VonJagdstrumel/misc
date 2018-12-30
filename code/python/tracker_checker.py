#!/usr/bin/env python3

import bencode, sys, socket, struct, requests
from concurrent import futures
from urllib import parse

BT_UDP_PROT_ID_H = 0x417
BT_UDP_PROT_ID_L = 0x27101980
BT_UDP_TRAN_ID = 42
BT_HTTP_QUERY = 'info_hash=%c7%8a%7b%e0%60%93%4e%28%6b%b0%69%fc%b9%49%65%6b%c6%5d%48%11&peer_id=-SU2291-SOVIETRUSSIA&port=0&downloaded=0&uploaded=0&left=0'
BT_TIMEOUT = 10


def tracker_connect(url):
    resp = requests.get('{}?{}'.format(url, BT_HTTP_QUERY), timeout = BT_TIMEOUT)

    if not bencode.decode(resp.content):
        raise ValueError


def tracker_send(tracker):
    message = struct.pack('>2L', BT_UDP_PROT_ID_H, BT_UDP_PROT_ID_L) + struct.pack('<2L', 0, BT_UDP_TRAN_ID)
    address = (tracker.hostname, tracker.port)
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(BT_TIMEOUT)
    sock.sendto(message, address)
    data = sock.recv(32)
    sock.close()
    parsed_data = struct.unpack('<4L', data)

    if parsed_data[0] != 0 or parsed_data[1] != BT_UDP_TRAN_ID:
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
    except Exception as e:
        pass


future_list = []
pool = futures.ThreadPoolExecutor()

for line in sys.stdin:
    future = pool.submit(check_tracker, line.strip())
    future_list.append(future)

futures.wait(future_list)
