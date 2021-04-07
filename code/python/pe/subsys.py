#!/usr/bin/env python3

import sys

from utils import dataproc


def patch(pe_path):
    with open(pe_path, 'r+b') as f:
        pos = 0x5c + dataproc.pack_read_at(f, 0x3c, '<I')
        subsys = dataproc.pack_read_at(f, pos, '<H')

        if subsys in (2, 3):
            subsys = (subsys - 1) % 2 + 2
            dataproc.pack_write_at(f, pos, '<H', subsys)


if __name__ == '__main__':
    patch(sys.argv[1])
