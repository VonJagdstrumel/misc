#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

from windows import cygwin
from windows.kernel import api


def FormatError(code):
    buf = wintypes.LPWSTR()
    api.FormatMessageW(api.FORMAT_MESSAGE_ALLOCATE_BUFFER
                       | api.FORMAT_MESSAGE_FROM_SYSTEM
                       | api.FORMAT_MESSAGE_IGNORE_INSERTS,
                       None, code, api.LANG_NEUTRAL,
                       ctypes.byref(buf),
                       0, None)
    res = buf.value
    api.LocalFree(buf)
    return res.rstrip()


def WinError():
    code = api.GetLastError()
    descr = FormatError(code)
    err = cygwin.errno_from_winerror(code)
    return OSError(err, descr, None, code)
