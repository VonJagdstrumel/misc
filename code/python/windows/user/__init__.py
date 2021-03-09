#!/usr/bin/env python3

from windows import kernel
from windows.user import api


def SetDeskWallpaper(path):
    if not api.SystemParametersInfoW(api.SPI_SETDESKWALLPAPER, 0, path,
                                     api.SPIF_UPDATEINIFILE
                                     | api.SPIF_SENDCHANGE):
        raise kernel.WinError()
