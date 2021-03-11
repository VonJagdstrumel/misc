#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

SPI_SETDESKWALLPAPER = 0x0014
SPIF_UPDATEINIFILE = 0x0001
SPIF_SENDCHANGE = 0x0002

CF_TEXT = 1
CF_UNICODETEXT = 13

_user32 = ctypes.CDLL('user32.dll')

SystemParametersInfoW = _user32.SystemParametersInfoW
SystemParametersInfoW.restype = wintypes.BOOL
SystemParametersInfoW.argtypes = [wintypes.UINT,
                                  wintypes.UINT,
                                  wintypes.LPVOID,
                                  wintypes.UINT]


OpenClipboard = _user32.OpenClipboard
OpenClipboard.restype = wintypes.BOOL
OpenClipboard.argtypes = [wintypes.HWND]

CloseClipboard = _user32.CloseClipboard
CloseClipboard.restype = wintypes.BOOL
CloseClipboard.argtypes = []

EmptyClipboard = _user32.EmptyClipboard
EmptyClipboard.restype = wintypes.BOOL
EmptyClipboard.argtypes = []

SetClipboardData = _user32.SetClipboardData
SetClipboardData.restype = wintypes.HANDLE
SetClipboardData.argtypes = [wintypes.UINT,
                             wintypes.HANDLE]

RegisterClipboardFormatW = _user32.RegisterClipboardFormatW
RegisterClipboardFormatW.restype = wintypes.UINT
RegisterClipboardFormatW.argtypes = [wintypes.LPCWSTR]

CF_HTML = RegisterClipboardFormatW("HTML Format")
