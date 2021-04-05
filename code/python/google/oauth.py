#!/usr/bin/env python3

import json

from requests_oauthlib import OAuth2Session


def _token_save(token):
    config = _config_read()
    config['token'] = token
    _config_write(config)


def _config_read():
    with open('config.json') as config_file:
        return json.load(config_file)


def _config_write(config):
    with open('config.json', 'w') as config_file:
        json.dump(config, config_file, indent=4)


def _session_init(token_url, config):
    return OAuth2Session(config['client']['client_id'],
                         scope=config['scope'],
                         redirect_uri=config['redirect_uri'],
                         token=config.get('token'),
                         auto_refresh_url=token_url,
                         auto_refresh_kwargs=config['client'],
                         token_updater=_token_save)


def _token_init(session, token_url, config):
    if config.get('token'):
        return

    authorization_url, state = session.authorization_url(
        'https://accounts.google.com/o/oauth2/v2/auth',
        access_type='offline',
        prompt='consent'
    )
    print(authorization_url)
    config['token'] = session.fetch_token(
        token_url,
        client_secret=config['client']['client_secret'],
        authorization_response=input()
    )
    _config_write(config)


TOKEN_URL = 'https://www.googleapis.com/oauth2/v4/token'
config = _config_read()
session = _session_init(TOKEN_URL, config)
_token_init(session, TOKEN_URL, config)
