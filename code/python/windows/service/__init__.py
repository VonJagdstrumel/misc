#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

from windows.service import api


def OpenSCManager(access):
    return api.OpenSCManagerW(None, None, access)


def OpenService(scm, name, access):
    return api.OpenServiceW(scm, name, access)


def QueryServiceStatus(svc):
    status = api.SERVICE_STATUS()
    ref_status = ctypes.byref(status)
    api.QueryServiceStatus(svc, ref_status)
    return status


def QueryServiceConfig(svc):
    size = wintypes.DWORD()
    ref_size = ctypes.byref(size)
    api.QueryServiceConfigW(svc, None, 0, ref_size)
    buf = ctypes.create_string_buffer(size.value)
    config = ctypes.cast(buf, api.LPQUERY_SERVICE_CONFIGW)
    api.QueryServiceConfigW(svc, config, size, ref_size)
    return config.contents


def ChangeServiceConfig(svc, start_type):
    return api.ChangeServiceConfigW(svc, api.SERVICE_NO_CHANGE, start_type,
                                    api.SERVICE_NO_CHANGE, None, None, None,
                                    None, None, None, None)


def StartService(svc):
    return api.StartServiceW(svc, 0, None)
