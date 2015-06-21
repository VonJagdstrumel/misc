#!/bin/bash
# Win95 terminal emulator

echo "Microsoft(R) Windows 95"
echo "   (C)Copyright Microsoft Corp 1981-1995"
echo

export PS1="C:"$(echo $PWD | awk '{gsub("/","\\\\",$1);print $1}')">"

cd_func ()
{
  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
	export PS1="C:"$(echo $PWD | awk '{gsub("/","\\\\",$1);print $1}')">"
  return 0
}

alias cd=cd_func
