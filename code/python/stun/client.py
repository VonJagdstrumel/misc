#!/usr/bin/env python3

import socket
import struct
import sys

MAGIC_COOKIE = 0x2112A442

HEADER_SIZE = 20
MAX_MSG_SIZE = 512

MAPPED_ADDRESS = 0x0001
XOR_MAPPED_ADDRESS = 0x0020


def long2ip(long_addr):
    bin_addr = struct.pack('>I', long_addr)
    dec_addr = struct.unpack('4B', bin_addr)
    return '.'.join(str(i) for i in dec_addr)


def mapped_address(host, port):
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        msg = struct.pack('>HHI12s', 1, 0, MAGIC_COOKIE, b'')
        addr = (host, int(port))
        s.sendto(msg, addr)
        buf = s.recv(MAX_MSG_SIZE)
        # Skip response header
        offset = HEADER_SIZE

        while offset < len(buf):
            type, length = struct.unpack('>HH', buf[offset:offset + 4])
            # Skip type and length
            offset += 4

            # Type is MAPPED-ADDRESS or XOR-MAPPED-ADDRESS
            if type in (MAPPED_ADDRESS, XOR_MAPPED_ADDRESS):
                break
            else:
                # Skip value
                offset += length

        # Reached end of response
        if offset == len(buf):
            raise ValueError

        # Skip family and port
        offset += 4
        long_addr, *_ = struct.unpack('>I', buf[offset:offset + 4])

        if type == MAPPED_ADDRESS:
            return long2ip(long_addr)
        else:
            return long2ip(long_addr ^ MAGIC_COOKIE)


if __name__ == '__main__':
    addr = mapped_address(sys.argv[1], sys.argv[2])
    print(addr)
