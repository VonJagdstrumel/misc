#!/usr/bin/env python3

import sys

from utils.dataproc import StructFile


def get(pe_path):
    with open(pe_path, 'rb') as fp:
        sf = StructFile(fp)
        pos = 0x4 + sf.read_at(0x3c, '<I')
        mach = sf.read_at(pos, '<H')

    if mach == 0x14c:
        return 'x86'
    elif mach == 0x200:
        return 'IA-64'
    elif mach == 0x8664:
        return 'x64'

    return 'unknown'


if __name__ == '__main__':
    arch = get(sys.argv[1])
    print(arch)
