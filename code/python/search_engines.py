#!/usr/bin/env python3

import base64
import imghdr
import json
import sys
import tempfile

import lz4.block
import requests


def test_ico(h, f):
    if h[:4] == b'\x00\x00\x01\x00':
        return 'x-icon'


imghdr.tests.append(test_ico)


def load(path):
    with open(path, 'rb') as f:
        raw = f.read()
        raw = lz4.block.decompress(raw[8:])
        return json.loads(raw)


def dump(path, data):
    with open(path, 'wb') as f:
        raw = json.dumps(data).encode()
        raw = b'mozLz40\0' + lz4.block.compress(raw)
        f.write(raw)


def data_uri(url):
    with tempfile.TemporaryFile() as f:
        r = requests.get(url)
        f.write(r.content)
        f.seek(0)
        type = imghdr.what(f)
        data = base64.b64encode(r.content).decode()
        return f'data:image/{type};base64,{data}'


def convert_engine(engine, order, alias = None):
    return {
        '_name': engine['name'],
        '_shortName': engine['name'].lower().replace(' ', '-'),
        'description': engine['name'],
        'queryCharset': 'UTF-8',
        '_iconURL': data_uri(engine['iconUrl']),
        '_loadPath': '[other]addEngineWithDetails',
        '_metaData': {
            'alias': alias,
            'order': order
        },
        '_urls': [
            {
                'template': engine['searchUrl']
            }
        ]
    }


if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f:
        sJson = json.load(f)

    dJson = load(sys.argv[2])
    order = 1
    engines = []

    for sEngine in sJson['searchEngines']:
        if sEngine.get('id') == 'separator':
            continue

        try:
            dEngine = next(e for e in dJson['engines'] if e['_name'] == sEngine['name'])
            dEngine = convert_engine(sEngine, order, dEngine['_metaData']['alias'])
        except StopIteration:
            dEngine = convert_engine(sEngine, order)

        order += 1
        engines.append(dEngine)

    dJson['engines'] = engines
    dump(sys.argv[2], dJson)
