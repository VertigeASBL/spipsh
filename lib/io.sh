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
