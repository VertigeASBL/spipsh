#!/bin/bash
# Summary : Crée les dossiers de plugins et de libraires, puis donne les permissions adequates.
# Env : spip
set -euo pipefail

# Les dossiers qui doivent exister pour que SPIP fonctionne sans embrouilles
needed_dirs="config IMG local lib tmp plugins plugins/auto plugins/fabrique_auto squelettes"

# Les dossiers qui doivent être accessibles en écriture par Apache
writeable_dirs="config IMG local lib tmp plugins/auto plugins/fabrique_auto"

for dir in $needed_dirs; do
    if [[ ! -d $dir ]]; then
        out_exec "crée le dossier $dir"\
                 mkdir "$dir";
    fi
done

out_exec "répare les permissions"\
         chmod -R a+rwX "$writeable_dirs";
