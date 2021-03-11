#!/usr/bin/env python3

import sys

from windows import user
from windows.user import api

if __name__ == '__main__':
    data = sys.stdin.read()
    d_text = data.encode('cp1252')
    d_unicode = data.encode('utf_16_le')
    d_html = user.ComposeHtmlClipboard(data).encode()

    api.OpenClipboard(None)
    api.EmptyClipboard()
    user.SetClipboardData(api.CF_TEXT, d_text)
    user.SetClipboardData(api.CF_UNICODETEXT, d_unicode)
    user.SetClipboardData(api.CF_HTML, d_html)
    api.CloseClipboard()
