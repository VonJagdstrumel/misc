#!/usr/bin/env python3

import sys

from utils.dataproc import StructFile


def patch(pe_path):
    with open(pe_path, 'r+b') as fp:
        sf = StructFile(fp)
        pos = 0x5c + sf.read_at(0x3c, '<I')
        subsys = sf.read_at(pos, '<H')

        if subsys in (2, 3):
            subsys = (subsys - 1) % 2 + 2
            sf.write_at(pos, '<H', subsys)


if __name__ == '__main__':
    patch(sys.argv[1])
