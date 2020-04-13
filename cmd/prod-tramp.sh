#!/bin/bash
# Summary : Ouvrir le dossier racine de la prod dans emacs.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

util_bin_ok "emacs"

emacsclient --eval "(find-file \"/ssh:$ssh_user@$prod_host:.\")"
