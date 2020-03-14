#!/usr/bin/env python3

import requests

import cygwinreg3 as winreg


def get_app_list():
    json = requests.get('https://api.steampowered.com/ISteamApps/GetAppList/v2').json()
    app_list = {}

    for app in json['applist']['apps']:
        app_list[app['appid']] = app['name']

    return app_list


def list_installed():
    base_key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Software\Valve\Steam\Apps')
    subkey_count = winreg.QueryInfoKey(base_key)[0]
    app_list = get_app_list()

    for i in range(subkey_count):
        subkey_name = winreg.EnumKey(base_key, i)
        subkey = winreg.OpenKey(base_key, subkey_name)
        app_name = app_list.get(int(subkey_name))

        try:
            value = winreg.QueryValueEx(subkey, 'Installed')[0]
        except OSError:
            value = -1

        print(subkey_name + '\t' + str(value) + '\t' + str(app_name))


if __name__ == '__main__':
    list_installed()
