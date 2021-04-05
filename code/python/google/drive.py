#!/usr/bin/env python3

import json
import os
import sys

from requests_toolbelt import MultipartEncoder, MultipartEncoderMonitor

from google import oauth


def progress(monitor):
    percent = monitor.bytes_read / monitor.len * 100
    sys.stdout.write(f'\r{percent:.1f}%')


def upload_file(session, path):
    metadata = json.dumps({
        'name': os.path.basename(path),
        'parents': ['18MpJkWPa-vELhotUuF40ergXkj8UvzDy']
    })

    with open(path, 'rb') as file:
        multipart = MultipartEncoder(fields={
            'metadata': ('', metadata, 'application/json'),
            'media': file
        })
        session.post(
            'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
            headers={'Content-Type': multipart.content_type},
            data=MultipartEncoderMonitor(multipart, progress)
        )


upload_file(oauth.session, sys.argv[1])
print('\r      ')
