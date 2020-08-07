#!/usr/bin/env python3

import sys
from ctypes import (cast, cdll,
                    c_void_p, c_wchar_p, c_uint, c_int)

SPI_SETDESKWALLPAPER = 0x00000014
SPIF_UPDATEINIFILE   = 0x00000001
SPIF_SENDCHANGE      = 0x00000002
CCP_POSIX_TO_WIN_W   = 0x00000001

PVOID = c_void_p
BOOL  = c_int
UINT  = c_uint

cdll.user32 = cdll.LoadLibrary('user32.dll')
cdll.cygwin1 = cdll.LoadLibrary('cygwin1.dll')

SystemParametersInfoW = cdll.user32.SystemParametersInfoW
SystemParametersInfoW.restype = BOOL
SystemParametersInfoW.argtypes = [UINT, UINT, PVOID, UINT]

cygwin_create_path = cdll.cygwin1.cygwin_create_path
cygwin_create_path.restype = c_void_p
cygwin_create_path.argtypes = [c_uint, c_void_p]

free = cdll.cygwin1.free
free.restype = None
free.argtypes = [c_void_p]


def set_wallpaper(path):
    return SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE) != 0


def posix2win(path):
    result = cygwin_create_path(CCP_POSIX_TO_WIN_W, path.encode())
    value = cast(result, c_wchar_p).value
    free(result)
    return value


if __name__ == '__main__':
    w_path = posix2win(sys.argv[1])
    set_wallpaper(w_path)
