#!/usr/bin/env python3

import struct
import sys

PACK_SIZE_DEF = { 2: 'h', 4: 'i' }


def read_size(fh, pos, size):
    fh.seek(pos)
    packed = fh.read(size)
    unpacked = struct.unpack(PACK_SIZE_DEF[size], packed)
    return unpacked[0]


def write_size(fh, pos, size, data):
    packed = struct.pack(PACK_SIZE_DEF[size], data)
    fh.seek(pos)
    fh.write(packed)


def patch(file_path):
    fh = open(file_path, 'r+b')
    subsystem_pos = 0x5c + read_size(fh, 0x3c, 4)
    subsystem = read_size(fh, subsystem_pos, 2)

    if subsystem in (2, 3):
        subsystem = (subsystem - 1) % 2 + 2
        write_size(fh, subsystem_pos, 2, subsystem)


if __name__ == '__main__':
    patch(sys.argv[1])
