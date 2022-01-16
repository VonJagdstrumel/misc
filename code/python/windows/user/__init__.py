#!/usr/bin/env python3

import ctypes
from ctypes import wintypes
from io import StringIO
import re

from windows import kernel
from windows.kernel import api as kapi
from windows.user import api

CB_HTML_HEADER = """Version:0.9
StartHTML:00000000
EndHTML:00000000
StartFragment:00000000
EndFragment:00000000
"""


def SetDeskWallpaper(path):
    if not api.SystemParametersInfoW(api.SPI_SETDESKWALLPAPER, 0, path,
                                     api.SPIF_UPDATEINIFILE
                                     | api.SPIF_SENDCHANGE):
        raise kernel.WinError()


def SetClipboardData(typ, data):
    size = len(data) + 1
    handle = kapi.GlobalAlloc(kapi.GMEM_MOVEABLE, size)
    buf = kapi.GlobalLock(handle)
    ctypes.memmove(buf, wintypes.LPSTR(data), size)
    kapi.GlobalUnlock(handle)
    api.SetClipboardData(typ, handle)
    kapi.GlobalFree(handle)


def ComposeHtmlClipboard(data):
    with StringIO() as cb:
        offsets = [m.start() + 1 for m in re.finditer(':', CB_HTML_HEADER)]

        cb.write(CB_HTML_HEADER)
        start_html = cb.tell()
        cb.write('<html><body><!--StartFragment-->')
        start_fragment = cb.tell()
        cb.write(data)
        end_fragment = cb.tell()
        cb.write('<!--EndFragment--></body></html>')
        end_html = cb.tell()

        cb.seek(offsets[1])
        cb.write(f'{start_html:0>8}')
        cb.seek(offsets[2])
        cb.write(f'{end_html:0>8}')
        cb.seek(offsets[3])
        cb.write(f'{start_fragment:0>8}')
        cb.seek(offsets[4])
        cb.write(f'{end_fragment:0>8}')

        cb.seek(0)
        return cb.read()
