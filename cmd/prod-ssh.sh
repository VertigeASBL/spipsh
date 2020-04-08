#!/bin/bash
# Description : Ouvre un shell sur le serveur de prod via ssh.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

check_program "ssh";

ssh "$ssh_user"@"$prod_host";
