#!/bin/bash

/bin/find -regextype posix-egrep -regex ".+\.(exe|dll|phar|bat)" -printf '"%h/%f"\n' | xargs sha1sum
