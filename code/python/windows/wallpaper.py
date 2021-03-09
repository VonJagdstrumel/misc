#!/usr/bin/env python3

import sys

from windows import cygwin
from windows import user

if __name__ == '__main__':
    w_path = cygwin.posix2win(sys.argv[1])
    user.SetDeskWallpaper(w_path)
