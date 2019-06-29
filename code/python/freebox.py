#!/usr/bin/env python3

import functools
import hmac
import json
import socket
import time

import requests


class BaseClient:
    BASE_URL = 'https://mafreebox.freebox.fr'

    def __init__(self):
        self.headers = None

    def post(self, url, data = None):
        return requests.post(
            url,
            data = json.dumps(data) if data else None,
            headers = self.headers,
            verify = 'certs.pem'
        ).json()

    def get(self, url):
        return requests.get(
            url,
            headers = self.headers,
            verify = 'certs.pem'
        ).json()

    def discover(self):
        response = self.get(self.BASE_URL + '/api_version')
        return '{}{}v{}'.format(
            self.BASE_URL,
            response['api_base_url'],
            response['api_version'].split('.')[0]
        )

    def auth(self, session_token):
        self.headers = {'X-Fbx-App-Auth': session_token}


class FreeboxOSClient:

    def __init__(self, app_token = None):
        self.client = BaseClient()
        self.api_url = self.client.discover()
        self.app_def = {
            'app_id': 'net.vonjagdstrumel.freeboxos',
            'app_name': 'Freebox OS Client',
            'device_name': socket.gethostname()
        }
        self.track_id = None
        self.app_token = app_token

    def authorize(self):
        response = self.client.post(self.api_url + '/login/authorize/', self.app_def)

        if not response['success']:
            raise Exception(response)

        self.track_id = str(response['result']['track_id'])
        return response['result']['app_token']

    def track(self):
        response = self.client.get(self.api_url + '/login/authorize/' + self.track_id)

        if not response['success']:
            raise Exception(response)

        return response['result']['status']

    def register(self, blocking = True):
        app_token = self.authorize()

        while blocking:
            time.sleep(1)
            status = self.track()

            if status == 'granted':
                break
            elif status != 'pending':
                raise Exception(status)

        self.app_token = app_token

    def challenge(self):
        response = self.client.get(self.api_url + '/login/')

        if not response['success']:
            raise Exception(response)

        return response['result']['challenge']

    def password(self):
        return hmac.new(
            self.app_token.encode(),
            msg = self.challenge().encode('utf-8'),
            digestmod = 'sha1'
        ).digest().hex()

    def session(self):
        response = self.client.post(self.api_url + '/login/session', {
            'app_id': self.app_def['app_id'],
            'password': self.password()
        })

        if not response['success']:
            raise Exception(response)

        self.client.auth(response['result']['session_token'])

    def logout(self):
        response = self.client.post(self.api_url + '/login/logout/')

        if not response['success']:
            raise Exception(response)

    def connection(self):
        response = self.client.get(self.api_url + '/connection/')

        if not response['success']:
            raise Exception(response)

        return response['result']

    def lan_browser(self):
        response = self.client.get(self.api_url + '/lan/browser/pub/')

        if not response['success']:
            raise Exception(response)

        return response['result']

    def host_count(self):
        return functools.reduce(
            lambda x, y: x + y['active'],
            self.lan_browser(),
            0
        )

    def forwarding(self):
        response = self.client.get(self.api_url + '/fw/redir/')

        if not response['success']:
            raise Exception(response)

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
    # client = FreeboxOSClient()
    # client.register()
    # print(client.app_token)

    client = FreeboxOSClient('blahblah')
    client.session()

    connection = client.connection()
    print(connection)

    host_count = client.host_count()
    print(host_count)

    self_rules = client.self_forwarding()
    print(self_rules)

    client.logout()
