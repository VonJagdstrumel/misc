#!/usr/bin/env python3

import sys

from utils import dataproc


def get(pe_path):
    with open(pe_path, 'rb') as f:
        pos = 0x4 + dataproc.pack_read(f, 0x3c, '<I')
        mach = dataproc.pack_read(f, pos, '<H')

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
