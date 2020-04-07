#!/bin/bash
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

check_program "lftp"

do_and_tell "rapatrier les images et documents du serveur de production"\
            lftp -u "$ftp_user",'"$ftp_pwd"' "$ftp_url" -e "mirror IMG/ ./IMG/ ; exit";
