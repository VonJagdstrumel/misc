#!/usr/bin/env python3

import ctypes
import errno

from windows.cygwin import api


def posix2win(path):
    # from is c_char_p, to is c_wchar_p
    path = path.encode()
    buf = api.cygwin_create_path(api.CCP_POSIX_TO_WIN_W, path)
    res = ctypes.cast(buf, ctypes.c_wchar_p).value
    api.free(buf)
    return res


def win2posix(path):
    # from is c_wchar_p, to is c_char_p
    buf = api.cygwin_create_path(api.CCP_WIN_W_TO_POSIX, path)
    res = ctypes.cast(buf, ctypes.c_char_p).value
    api.free(buf)
    return res.decode()


def errno_from_winerror(error):
    func = api.cygwin_internal
    func.argtypes = func.argtypes[:1] + [ctypes.c_int, ctypes.c_int]
    return func(api.CW_GET_ERRNO_FROM_WINERROR, error, errno.EINVAL)
