#!/usr/bin/env python3

import ctypes

CCP_POSIX_TO_WIN_W = 1
CCP_WIN_W_TO_POSIX = 3

CW_GET_ERRNO_FROM_WINERROR = 22

_cygwin1 = ctypes.CDLL("cygwin1.dll")

cygwin_create_path = _cygwin1.cygwin_create_path
cygwin_create_path.restype = ctypes.c_void_p
cygwin_create_path.argtypes = [ctypes.c_uint,
                               ctypes.c_void_p]

free = _cygwin1.free
free.restype = None
free.argtypes = [ctypes.c_void_p]

cygwin_internal = _cygwin1.cygwin_internal
cygwin_internal.restype = ctypes.c_uint
cygwin_internal.argtypes = [ctypes.c_int]
