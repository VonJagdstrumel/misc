#!/usr/bin/env python3

import sys

import bencodepy

from utils import dataproc

if __name__ == '__main__':
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r+b') as fp:
            bt = bencodepy.bread(fp)
            tr = dataproc.clean_reader(sys.stdin)
            bt[b'trackers'] = [[i] for i in tr]
            fp.seek(0)
            bencodepy.bwrite(bt, fp)
            fp.truncate()
    else:
        bt = bencodepy.bread(sys.stdin.buffer)
        tr = [i[0].decode() for i in bt[b'trackers']]
        print('\n'.join(tr))
