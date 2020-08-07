#!/usr/bin/env python3

import struct
import sys

PACK_SIZE_DEF = { 2: 'H', 4: 'I' }


def read_size(f, pos, size):
    f.seek(pos)
    packed = f.read(size)
    data, *_ = struct.unpack(PACK_SIZE_DEF[size], packed)
    return data


def write_size(f, pos, size, data):
    packed = struct.pack(PACK_SIZE_DEF[size], data)
    f.seek(pos)
    f.write(packed)


if __name__ == '__main__':
    with open(sys.argv[1], 'r+b') as f:
        subsystem_pos = 0x5c + read_size(f, 0x3c, 4)
        subsystem = read_size(f, subsystem_pos, 2)

        if subsystem in (2, 3):
            subsystem = (subsystem - 1) % 2 + 2
            write_size(f, subsystem_pos, 2, subsystem)
