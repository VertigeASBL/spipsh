#!/bin/bash
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

check_program "emacs"

emacsclient --eval "(find-file \"/ssh:$ssh_user@$prod_host:.\")"
