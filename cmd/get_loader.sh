#!/bin/bash
# Summary : Récupère la dernière version de spip_loader.php.
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

util_bin_ok "wget"

wget https://www.spip.net/spip-dev/INSTALL/spip_loader.php -O spip_loader.php
