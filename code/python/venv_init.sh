#!/usr/bin/env bash

#cd "$(dirname "${BASH_SOURCE[0]}")"
python3 -mvenv --system-site-packages venv
. venv/bin/activate
pip install --upgrade pip requests
pip install bencode.py
