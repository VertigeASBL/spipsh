#!/bin/bash
# Description : Crée les dossiers de plugins et de libraires, puis donne les permissions adequates.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

for dir in $SPIP_NEEDED_DIRS; do
    if [[ ! -d $dir ]]; then
        do_and_tell "crée le dossier $dir"\
                    mkdir "$dir";
    fi
done
do_and_tell "répare les permissions"\
            chmod -R a+rwX $SPIP_WRITEABLE_DIRS;
