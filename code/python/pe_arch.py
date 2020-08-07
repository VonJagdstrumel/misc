#!/usr/bin/env python3

import struct
import sys

from pe_patch import read_size


def get_arch(file_path):
    with open(file_path, 'rb') as f:
        machine_pos = 0x4 + read_size(f, 0x3c, 4)
        machine = read_size(f, machine_pos, 2)

    if machine == 0x14c:
        return 'x86'
    elif machine == 0x200:
        return 'IA-64'
    elif machine == 0x8664:
        return 'x64'

    return 'unknown'


if __name__ == '__main__':
    print(get_arch(sys.argv[1]))
