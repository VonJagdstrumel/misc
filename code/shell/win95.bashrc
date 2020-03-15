#!/usr/bin/env bash
# Win95 terminal emulator

echo "Microsoft(R) Windows 95"
echo "   (C)Copyright Microsoft Corp 1981-1995"
echo

set_ps1() {
    export PS1="C:$(awk '{gsub("/","\\\\",$1);print $1}' <<< "$PWD")>"
}

cd() {
  command cd "$(realpath "${1:-$HOME}")" || return
  set_ps1
}

set_ps1
