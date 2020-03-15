#!/usr/bin/env bash

find . -regextype posix-extended -iregex '.+\.png$' -exec optipng -i0 -strip all -preserve {} \;
find . -regextype posix-extended -iregex '.+\.jpe?g$' -exec jpegoptim -s -p --all-progressive {} \;
