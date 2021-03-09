#!/usr/bin/env python3

from importlib import resources
from os import path
import functools
import hmac
import json
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
        self.headers = None

    def post(self, url, data=None):
        return requests.post(
            url,
            data=json.dumps(data) if data else None,
            headers=self.headers,
            verify=self.CERTS_PATH
        ).json()

    def get(self, url):
        return requests.get(
            url,
            headers=self.headers,
            verify=self.CERTS_PATH
        ).json()

    def discover(self):
        response = self.get(f'{self.BASE_URL}/api_version')
        base_path = response['api_base_url']
        major_version = response['api_version'].split('.')[0]
        return f'{self.BASE_URL}{base_path}v{major_version}'

    def auth(self, session_token):
        self.headers = {'X-Fbx-App-Auth': session_token}


class FreeboxOSClient:

    def __init__(self, app_id, app_name=None, app_token=None):
        self.client = BaseClient()
        self.api_url = self.client.discover()
        self.app_id = app_id
        self.app_name = app_name
        self.app_token = app_token
        self.track_id = None

    def authorize(self):
        response = self.client.post(f'{self.api_url}/login/authorize/', {
            'app_id': self.app_id,
            'app_name': self.app_name,
            'device_name': socket.gethostname()
        })

        if not response['success']:
            raise FreeboxException(response)

        self.track_id = str(response['result']['track_id'])
        return response['result']['app_token']

    def track(self):
        response = self.client.get(
            f'{self.api_url}/login/authorize/{self.track_id}')

        if not response['success']:
            raise FreeboxException(response)

        return response['result']['status']

    def register(self, blocking=True):
        app_token = self.authorize()

        while blocking:
            time.sleep(1)
            status = self.track()

            if status == 'granted':
                break
            elif status != 'pending':
                raise FreeboxException(status)

        self.app_token = app_token

    def challenge(self):
        response = self.client.get(f'{self.api_url}/login/')

        if not response['success']:
            raise FreeboxException(response)

        return response['result']['challenge']

    def password(self):
        return hmac.new(
            self.app_token.encode(),
            msg=self.challenge().encode('utf-8'),
            digestmod='sha1'
        ).digest().hex()

    def session(self):
        response = self.client.post(f'{self.api_url}/login/session', {
            'app_id': self.app_id,
            'password': self.password()
        })

        if not response['success']:
            raise FreeboxException(response)

        self.client.auth(response['result']['session_token'])

    def logout(self):
        response = self.client.post(f'{self.api_url}/login/logout/')

        if not response['success']:
            raise FreeboxException(response)

    def connection(self):
        response = self.client.get(f'{self.api_url}/connection/')

        if not response['success']:
            raise FreeboxException(response)

        return response['result']

    def lan_browser(self):
        response = self.client.get(f'{self.api_url}/lan/browser/pub/')

        if not response['success']:
            raise FreeboxException(response)

        return response['result']

    def host_count(self):
        return functools.reduce(lambda x, y: x + y['active'],
                                self.lan_browser(), 0)

    def forwarding(self):
        response = self.client.get(f'{self.api_url}/fw/redir/')

        if not response['success']:
            raise FreeboxException(response)

        return response['result']

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
        with open(token_path) as f:
            client.app_token = f.read().strip()
    else:
        with open(token_path, 'w') as f:
            client.register()
            f.write(client.app_token)

    client.session()

    connection = client.connection()
    print(connection)

    host_count = client.host_count()
    print(host_count)

    self_rules = client.self_forwarding()
    print(self_rules)

    client.logout()
