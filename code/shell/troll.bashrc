#!/usr/bin/env bash

unalias -a

while IFS= read -r p_dir; do
    while IFS= read -r e_path; do
        e_name=${e_path##*/}
        e_name=${e_name%.exe}
        alias "$e_name=cowsay"
    done < <(\find "$p_dir" -maxdepth 1 -type f -perm -555)
done < <(tr : $'\n' <<< "$PATH")

while IFS= read -r b_name; do
    alias "$b_name=cowsay"
done < <(compgen -A builtin)

for r_word in \{ case do done elif else esac fi for if select then until while; do
    alias "$w=cowsay"
done

unset p_dir e_path e_name b_name r_word
