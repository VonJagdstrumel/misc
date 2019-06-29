#!/usr/bin/env python3

import socket
import struct

with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
    host = ('stun.l.google.com', 19302)
    magic = 0x2112A442
    message = struct.pack('>II12s', 0x10000, magic, b'')
    
    s.sendto(message, host)

    bin_addr = s.recv(40)[28:32]
    long_addr = struct.unpack('>I', bin_addr)[0]
    xor_addr = long_addr ^ magic
    bin_addr = struct.pack('>I', xor_addr)
    dec_addr = struct.unpack('4B', bin_addr)
    str_addr = map(lambda x: str(x), dec_addr)
    fmt_addr'.'.join(dec_addr)

    print(fmt_addr)
