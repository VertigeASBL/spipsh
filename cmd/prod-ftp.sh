#!/bin/bash
# Description : Ouvre une connexion ftp vers le serveur via lftp.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

util_bin_ok "lftp"

lftp -u "$ftp_user","$ftp_pwd" "$ftp_url";
