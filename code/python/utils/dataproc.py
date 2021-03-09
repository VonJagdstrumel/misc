#!/usr/bin/env python3

import struct


def pack_read(f, pos, fmt):
    size = struct.calcsize(fmt)
    f.seek(pos)
    packed = f.read(size)
    data, *_ = struct.unpack(fmt, packed)
    return data


def pack_write(f, pos, fmt, data):
    packed = struct.pack(fmt, data)
    f.seek(pos)
    f.write(packed)


def clean_reader(iter):
    for line in iter:
        line = line.strip()

        if line:
            yield line
