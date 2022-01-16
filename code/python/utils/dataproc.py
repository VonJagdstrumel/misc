#!/usr/bin/env python3

import struct


class StructFile:
    def __init__(self, fp):
        self._fp = fp

    def read(self, fmt):
        sz = struct.calcsize(fmt)
        buf = self._fp.read(sz)
        val = struct.unpack(fmt, buf)
        if len(val) == 1:
            return val[0]
        else:
            return val

    def read_at(self, pos, fmt):
        sz = struct.calcsize(fmt)
        self._fp.seek(pos)
        buf = self._fp.read(sz)
        val = struct.unpack(fmt, buf)
        if len(val) == 1:
            return val[0]
        else:
            return val

    def write(self, fmt, *val):
        buf = struct.pack(fmt, *val)
        return self._fp.write(buf)

    def write_at(self, pos, fmt, *val):
        buf = struct.pack(fmt, *val)
        self._fp.seek(pos)
        return self._fp.write(buf)

    def _cstring_gen(self):
        while True:
            cur = self._fp.read(1)
            if not cur or cur == b'\0':
                return
            yield cur

    def cstring_read(self):
        return b''.join(self._cstring_gen())

    def cstring_read_at(self, pos):
        self._fp.seek(pos)
        return self.cstring_read()


def clean_reader(itr):
    for line in itr:
        line = line.strip()

        if line:
            yield line
