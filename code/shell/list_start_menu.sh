#!/usr/bin/env bash
# List every entry in the Start Menu

dirList=("Accessoires" "Autres" "Bureautique" "Développement" "Image" "Internet" "Jeux" "Multimédia" "Système")
printf '%s\n' "${dirList[@]}" | \
    xargs find | \
    grep / | \
    grep -v '/desktop.ini$'
