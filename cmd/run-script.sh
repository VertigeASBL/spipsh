#!/bin/bash
# Summary : Lance un script bash en lui passant les variables
# d'environnement qui vont bien. On passe l'adresse du script relativement au
# dossier bin/ situé à la racine du SPIP.
#
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

# shellcheck disable=SC2154
script="${CMD_ARGS[*]}"

if [[ -z "${script}" ]]; then
    out_usage_error "Vous devez spécifier le nom d'un script.";
else
    # shellcheck source=/dev/null
    . "./bin/$script";
fi
