#!/usr/bin/env python3

import socket
import struct


def long2ip(long_addr):
    bin_addr = struct.pack('>I', long_addr)
    dec_addr = struct.unpack('4B', bin_addr)
    str_addr = map(lambda x: str(x), dec_addr)
    return '.'.join(str_addr)


def query():
    magic = 0x2112A442
    message = struct.pack('>HHI12s', 1, 0, magic, b'')
    # host = ('stun.l.google.com', 19302)
    host = ('stun.stunprotocol.org', 3478)
    # Skip response header
    offset = 20

    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        s.sendto(message, host)
        buf = s.recv(256)

        while offset < len(buf):
            type, length = struct.unpack('>HH', buf[offset:offset + 4])
            # Skip type and length
            offset += 4

            # Type is MAPPED-ADDRESS or XOR-MAPPED-ADDRESS
            if type in (1, 32):
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

        if type == 1:
            return long2ip(long_addr)
        else:
            return long2ip(long_addr ^ magic)


if __name__ == '__main__':
    print(query())
