#!/bin/bash
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

if [[ -z "${script+x}" ]]; then
    usage_error "Vous devez spécifier le nom d'un script.";
else
    # shellcheck source=/dev/null
    . "./bin/$script";
fi
