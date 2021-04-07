#!/usr/bin/env python3

import struct


def pack_read(f, fmt):
    sz = struct.calcsize(fmt)
    buf = f.read(sz)
    val = struct.unpack(fmt, buf)
    if len(val) == 1:
        return val[0]
    else:
        return val


def pack_write(f, fmt, *val):
    buf = struct.pack(fmt, *val)
    return f.write(buf)


def pack_read_at(f, pos, fmt):
    sz = struct.calcsize(fmt)
    f.seek(pos)
    buf = f.read(sz)
    val = struct.unpack(fmt, buf)
    if len(val) == 1:
        return val[0]
    else:
        return val


def pack_write_at(f, pos, fmt, *val):
    buf = struct.pack(fmt, *val)
    f.seek(pos)
    return f.write(buf)


def clean_reader(iter):
    for line in iter:
        line = line.strip()

        if line:
            yield line
