#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

GENERIC_READ = 0x80000000
GENERIC_WRITE = 0x40000000

CREATE_NEW = 1
CREATE_ALWAYS = 2
OPEN_EXISTING = 3
OPEN_ALWAYS = 4
TRUNCATE_EXISTING = 5

INVALID_HANDLE_VALUE = wintypes.HANDLE(-1)


class SECURITY_ATTRIBUTES(ctypes.Structure):
    _fields_ = [('nLength',              wintypes.DWORD),
                ('lpSecurityDescriptor', wintypes.LPVOID),
                ('bInheritHandle',       wintypes.BOOL)]


LPSECURITY_ATTRIBUTES = ctypes.POINTER(SECURITY_ATTRIBUTES)

_kernel32 = ctypes.CDLL('kernel32.dll')

CreateFileW = _kernel32.CreateFileW
CreateFileW.restype = wintypes.HANDLE
CreateFileW.argtypes = [wintypes.LPCWSTR,
                        wintypes.DWORD,
                        wintypes.DWORD,
                        LPSECURITY_ATTRIBUTES,
                        wintypes.DWORD,
                        wintypes.DWORD,
                        wintypes.HANDLE]

WriteFile = _kernel32.WriteFile
WriteFile.restype = wintypes.BOOL
WriteFile.argtypes = [wintypes.HANDLE,
                      wintypes.LPCVOID,
                      wintypes.DWORD,
                      wintypes.LPDWORD,
                      wintypes.LPVOID]

ReadFile = _kernel32.ReadFile
ReadFile.restype = wintypes.BOOL
ReadFile.argtypes = [wintypes.HANDLE,
                     wintypes.LPVOID,
                     wintypes.DWORD,
                     wintypes.LPDWORD,
                     wintypes.LPVOID]

CloseHandle = _kernel32.CloseHandle
CloseHandle.restype = wintypes.BOOL
CloseHandle.argtypes = [wintypes.HANDLE]
