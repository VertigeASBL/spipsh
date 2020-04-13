#!/bin/bash
# Summary : Récupère le contenu du dossier IMG en production via lftp.
# Env : spip
set -euo pipefail

util_bin_ok "lftp"

out_exec "rapatrier les images et documents du serveur de production"\
            lftp -u "$ftp_user",'"$ftp_pwd"' "$ftp_url" -e "mirror IMG/ ./IMG/ ; exit";
