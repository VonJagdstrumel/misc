#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

from windows import kernel
from windows.file import api


def CreateFile(path, access, action, flags):
    res = api.CreateFileW(path, access, 0, None, action, flags, None)

    if res == api.INVALID_HANDLE_VALUE.value:
        raise kernel.WinError()

    return res


def WriteFile(handle, data):
    written = wintypes.DWORD()
    ref_written = ctypes.byref(written)

    if not api.WriteFile(handle, data, len(data), ref_written, None):
        raise kernel.WinError()

    return written.value


def ReadFile(handle, size):
    buf = ctypes.create_string_buffer(size)
    read = wintypes.DWORD()
    ref_read = ctypes.byref(read)

    if not api.ReadFile(handle, buf, size, ref_read, None):
        raise kernel.WinError()

    return buf.value


def OpenPipe(path):
    return CreateFile(path, api.GENERIC_READ | api.GENERIC_WRITE,
                      api.OPEN_EXISTING, api.FILE_FLAG_OVERLAPPED)
