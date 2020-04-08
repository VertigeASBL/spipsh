#!/bin/bash
# Description : Récupère le contenu du dossier IMG en production via lftp.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

util_bin_ok "lftp"

out_exec "rapatrier les images et documents du serveur de production"\
            lftp -u "$ftp_user",'"$ftp_pwd"' "$ftp_url" -e "mirror IMG/ ./IMG/ ; exit";
