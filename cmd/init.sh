#!/bin/bash
# Description : Crée les dossiers de plugins et de libraires, puis donne les permissions adequates.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

# Les dossiers qui doivent exister pour que SPIP fonctionne sans embrouilles
needed_dirs="config IMG local lib tmp plugins plugins/auto plugins/fabrique_auto squelettes"

# Les dossiers qui doivent être accessibles en écriture par Apache
writeable_dirs="config IMG local lib tmp plugins/auto plugins/fabrique_auto"

for dir in $needed_dirs; do
    if [[ ! -d $dir ]]; then
        do_and_tell "crée le dossier $dir"\
                    mkdir "$dir";
    fi
done

do_and_tell "répare les permissions"\
            chmod -R a+rwX "$writeable_dirs";
