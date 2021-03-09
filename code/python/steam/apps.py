#!/usr/bin/env python3

import requests

import cygwinreg3 as winreg

APP_LIST_API = 'https://api.steampowered.com/ISteamApps/GetAppList/v2'
STEAM_APPS_KEY = 'Software\\Valve\\Steam\\Apps'


def app_list():
    json = requests.get(APP_LIST_API).json()
    app_list = {}

    for app in json['applist']['apps']:
        app_list[app['appid']] = app['name']

    return app_list


def reg_list():
    b_key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, STEAM_APPS_KEY)
    count = winreg.QueryInfoKey(b_key)[0]

    for i in range(count):
        id = winreg.EnumKey(b_key, i)
        s_key = winreg.OpenKey(b_key, id)

        try:
            installed = winreg.QueryValueEx(s_key, 'Installed')[0]
        except OSError:
            installed = -1

        winreg.CloseKey(s_key)
        yield (int(id), installed)


if __name__ == '__main__':
    apps = app_list()

    for id, installed in reg_list():
        name = apps.get(id)
        print(f'{id}\t{installed}\t{name}')
