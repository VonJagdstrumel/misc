#!/usr/bin/env python3

import functools
import hmac
from importlib import resources
import json
from os import path
import socket
import sys
import time

import requests


class FreeboxException(Exception):
    pass


class BaseClient:
    BASE_URL = 'https://mafreebox.freebox.fr'
    CERTS_PATH = str(resources.path(__package__, 'certs.pem').__enter__())

    def __init__(self):
        self._hdrs = None

    def post(self, url, data=None):
        return requests.post(
            url,
            data=json.dumps(data) if data else None,
            headers=self._hdrs,
            verify=self.CERTS_PATH
        ).json()

    def get(self, url):
        return requests.get(
            url,
            headers=self._hdrs,
            verify=self.CERTS_PATH
        ).json()

    def discover(self):
        resp = self.get(f'{self.BASE_URL}/api_version')
        base = resp['api_base_url']
        maj_ver = resp['api_version'].split('.')[0]
        return f'{self.BASE_URL}{base}v{maj_ver}'

    def auth(self, session_token):
        self._hdrs = {'X-Fbx-App-Auth': session_token}


class FreeboxOSClient:
    def __init__(self, app_id, app_name=None, app_token=None):
        self._clt = BaseClient()
        self._url = self._clt.discover()
        self._id = app_id
        self._name = app_name
        self._token = app_token
        self._track = None

    def authorize(self):
        resp = self._clt.post(f'{self._url}/login/authorize/', {
            'app_id': self._id,
            'app_name': self._name,
            'device_name': socket.gethostname()
        })

        if not resp['success']:
            raise FreeboxException(resp)

        self._track = str(resp['result']['track_id'])
        return resp['result']['app_token']

    def track(self):
        resp = self._clt.get(f'{self._url}/login/authorize/{self._track}')

        if not resp['success']:
            raise FreeboxException(resp)

        return resp['result']['status']

    def register(self, blocking=True):
        app_token = self.authorize()

        while blocking:
            time.sleep(1)
            status = self.track()

            if status == 'granted':
                break
            elif status != 'pending':
                raise FreeboxException(status)

        self._token = app_token

    def challenge(self):
        resp = self._clt.get(f'{self._url}/login/')

        if not resp['success']:
            raise FreeboxException(resp)

        return resp['result']['challenge']

    def password(self):
        return hmac.new(
            self._token.encode(),
            msg=self.challenge().encode('utf-8'),
            digestmod='sha1'
        ).digest().hex()

    def session(self):
        resp = self._clt.post(f'{self._url}/login/session', {
            'app_id': self._id,
            'password': self.password()
        })

        if not resp['success']:
            raise FreeboxException(resp)

        self._clt.auth(resp['result']['session_token'])

    def logout(self):
        resp = self._clt.post(f'{self._url}/login/logout/')

        if not resp['success']:
            raise FreeboxException(resp)

    def connection(self):
        resp = self._clt.get(f'{self._url}/connection/')

        if not resp['success']:
            raise FreeboxException(resp)

        return resp['result']

    def lan_browser(self):
        resp = self._clt.get(f'{self._url}/lan/browser/pub/')

        if not resp['success']:
            raise FreeboxException(resp)

        return resp['result']

    def host_count(self):
        return functools.reduce(lambda x, y: x + y['active'],
                                self.lan_browser(), 0)

    def forwarding(self):
        resp = self._clt.get(f'{self._url}/fw/redir/')

        if not resp['success']:
            raise FreeboxException(resp)

        return resp['result']

    def self_forwarding(self):
        ip_list = socket.gethostbyname_ex(socket.gethostname())[-1]
        self_rules = []

        for rule in self.forwarding():
            if rule['enabled'] and rule['lan_ip'] in ip_list:
                self_rules.append({
                    'ip_proto': rule['ip_proto'],
                    'wan_port_start': rule['wan_port_start'],
                    'wan_port_end': rule['wan_port_end']
                })

        return self_rules


if __name__ == '__main__':
    token_path = sys.argv[1]
    client = FreeboxOSClient('net.vonjagdstrumel.freeboxos',
                             'Freebox OS Client')

    if path.isfile(token_path):
        with open(token_path) as fp:
            client._token = fp.read().strip()
    else:
        with open(token_path, 'w') as fp:
            client.register()
            fp.write(client._token)

    client.session()

    connection = client.connection()
    print(connection)

    host_count = client.host_count()
    print(host_count)

    self_rules = client.self_forwarding()
    print(self_rules)

    client.logout()
