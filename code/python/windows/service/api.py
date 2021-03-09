#!/usr/bin/env python3

import ctypes
from ctypes import wintypes

SC_MANAGER_ALL_ACCESS = 0x000F003F
SERVICE_ALL_ACCESS = 0x000F01FF
SERVICE_NO_CHANGE = 0XFFFFFFFF

SERVICE_AUTO_START = 0x00000002
SERVICE_BOOT_START = 0x00000000
SERVICE_DEMAND_START = 0x00000003
SERVICE_DISABLED = 0x00000004
SERVICE_SYSTEM_START = 0x00000001

SERVICE_CONTINUE_PENDING = 0x00000005
SERVICE_PAUSE_PENDING = 0x00000006
SERVICE_PAUSED = 0x00000007
SERVICE_RUNNING = 0x00000004
SERVICE_START_PENDING = 0x00000002
SERVICE_STOP_PENDING = 0x00000003
SERVICE_STOPPED = 0x00000001


class SERVICE_STATUS(ctypes.Structure):
    _fields_ = [('dwServiceType',             wintypes.DWORD),
                ('dwCurrentState',            wintypes.DWORD),
                ('dwControlsAccepted',        wintypes.DWORD),
                ('dwWin32ExitCode',           wintypes.DWORD),
                ('dwServiceSpecificExitCode', wintypes.DWORD),
                ('dwCheckPoint',              wintypes.DWORD),
                ('dwWaitHint',                wintypes.DWORD)]


class QUERY_SERVICE_CONFIGW(ctypes.Structure):
    _fields_ = [('dwServiceType',      wintypes.DWORD),
                ('dwStartType',        wintypes.DWORD),
                ('dwErrorControl',     wintypes.DWORD),
                ('lpBinaryPathName',   wintypes.LPWSTR),
                ('lpLoadOrderGroup',   wintypes.LPWSTR),
                ('dwTagId',            wintypes.DWORD),
                ('lpDependencies',     wintypes.LPWSTR),
                ('lpServiceStartName', wintypes.LPWSTR),
                ('lpDisplayName',      wintypes.LPWSTR)]


SC_HANDLE = wintypes.HANDLE
SC_STATUS_TYPE = wintypes.INT
LPSERVICE_STATUS = ctypes.POINTER(SERVICE_STATUS)
LPQUERY_SERVICE_CONFIGW = ctypes.POINTER(QUERY_SERVICE_CONFIGW)

_advapi32 = ctypes.CDLL('advapi32.dll')

OpenSCManagerW = _advapi32.OpenSCManagerW
OpenSCManagerW.restype = SC_HANDLE
OpenSCManagerW.argtypes = [wintypes.LPCWSTR,
                           wintypes.LPCWSTR,
                           wintypes.DWORD]

OpenServiceW = _advapi32.OpenServiceW
OpenServiceW.restype = SC_HANDLE
OpenServiceW.argtypes = [SC_HANDLE,
                         wintypes.LPCWSTR,
                         wintypes.DWORD]

QueryServiceStatus = _advapi32.QueryServiceStatus
QueryServiceStatus.restype = wintypes.BOOL
QueryServiceStatus.argtypes = [SC_HANDLE,
                               LPSERVICE_STATUS]

QueryServiceConfigW = _advapi32.QueryServiceConfigW
QueryServiceConfigW.restype = wintypes.BOOL
QueryServiceConfigW.argtypes = [SC_HANDLE,
                                LPQUERY_SERVICE_CONFIGW,
                                wintypes.DWORD,
                                wintypes.LPDWORD]

ChangeServiceConfigW = _advapi32.ChangeServiceConfigW
ChangeServiceConfigW.restype = wintypes.BOOL
ChangeServiceConfigW.argtypes = [SC_HANDLE,
                                 wintypes.DWORD,
                                 wintypes.DWORD,
                                 wintypes.DWORD,
                                 wintypes.LPCWSTR,
                                 wintypes.LPCWSTR,
                                 wintypes.LPDWORD,
                                 wintypes.LPCWSTR,
                                 wintypes.LPCWSTR,
                                 wintypes.LPCWSTR,
                                 wintypes.LPCWSTR]

StartServiceW = _advapi32.StartServiceW
StartServiceW.restype = wintypes.BOOL
StartServiceW.argtypes = [SC_HANDLE,
                          wintypes.DWORD,
                          wintypes.LPCWSTR]
