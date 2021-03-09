#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200
FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000
FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100

LANG_NEUTRAL = 0x00

ERROR_SUCCESS = 0
ERROR_FILE_NOT_FOUND = 2
ERROR_ALREADY_EXISTS = 183
ERROR_MORE_DATA = 234
ERROR_NO_MORE_ITEMS = 259

_kernel32 = ctypes.CDLL('kernel32.dll')

GetLastError = _kernel32.GetLastError
GetLastError.restype = wintypes.DWORD
GetLastError.argtypes = []

FormatMessageW = _kernel32.FormatMessageW
FormatMessageW.restype = wintypes.DWORD
FormatMessageW.argtypes = [wintypes.DWORD,
                           wintypes.LPCVOID,
                           wintypes.DWORD,
                           wintypes.DWORD,
                           wintypes.LPVOID,
                           wintypes.DWORD,
                           wintypes.LPVOID]

LocalFree = _kernel32.LocalFree
LocalFree.restype = wintypes.HLOCAL
LocalFree.argtypes = [wintypes.HLOCAL]
