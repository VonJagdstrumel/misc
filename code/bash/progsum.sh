#!/bin/bash
# Produce a checksum list of every library/executable file

find -regextype posix-egrep -regex ".+\.(exe|dll|phar|bat)" -printf '"%h/%f"\n' | xargs sha1sum
