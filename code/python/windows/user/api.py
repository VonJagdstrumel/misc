#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

SPI_SETDESKWALLPAPER = 0x0014
SPIF_UPDATEINIFILE = 0x0001
SPIF_SENDCHANGE = 0x0002

_user32 = ctypes.CDLL('user32.dll')

SystemParametersInfoW = _user32.SystemParametersInfoW
SystemParametersInfoW.restype = wintypes.BOOL
SystemParametersInfoW.argtypes = [wintypes.UINT,
                                  wintypes.UINT,
                                  wintypes.LPVOID,
                                  wintypes.UINT]
