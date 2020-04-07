#!/bin/bash
set -euo pipefail

usage_error () {
    # texte en jaune
    echo "$(tput setaf 3)$1$(tput sgr 0)" 1>&2;
    exit 2;
}

fatal_error () {
    # texte en rouge
    echo "$(tput setaf 1)$1$(tput sgr 0)" 1>&2;
    exit 1;
}

do_and_tell () {
    # la description en vert s'il y en a une
    if [[ -n "$1" ]]; then
        echo "$(tput setaf 2)# $1$(tput sgr 0)"
    fi
    shift
    if [[ ${dry_run:-0} -ne 1 ]]; then
        # la commande en bleu
        echo "$(tput setaf 4)> $*$(tput sgr 0)"
        # exécuter la commande
        eval "$*"
    else
        # la commande en bleu dimmé
        echo "$(tput dim)$(tput setaf 4)> $*$(tput sgr 0)"
    fi
}

get_command_meta () {
    local cmd

    cmd="$1"
    meta="$2"

    <"$script_dir/cmd/${cmd}.sh" awk -v meta="$meta" '
BEGIN { stop=0; IGNORE_CASE=1 }

! /^#/ { stop=1 }

/^# / && stop==0 {
    if (match($0, /^# ([^:]+) : (.*)$/, matches)) {
       current_meta = tolower(matches[1])
       metas[current_meta] = matches[2]
    } else {
       metas[current_meta] = metas[current_meta] substr($0, 2)
    }
}

END { print metas[meta] }
'
}
