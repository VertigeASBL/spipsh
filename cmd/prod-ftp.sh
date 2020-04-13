#!/bin/bash
# Summary : Ouvre une connexion ftp vers le serveur via lftp.
# Env : spip
set -euo pipefail

util_bin_ok "lftp"

lftp -u "$ftp_user","$ftp_pwd" "$ftp_url";
