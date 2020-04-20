#!/bin/bash
#
# Summary : Lance un script bash en lui passant les variables
# d'environnement qui vont bien. On passe l'adresse du script relativement au
# dossier bin/ situé à la racine du SPIP.
#
# Env : spip
# Argument complete : spipsh_script
#
set -euo pipefail

# shellcheck disable=SC2154
script="${CMD_ARGS[0]}"

if [[ -z "${script}" ]]; then
    out_usage_error "Vous devez spécifier le nom d'un script.";
else
    # shellcheck source=/dev/null
    . "./bin/$script";
fi
