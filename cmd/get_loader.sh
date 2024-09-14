#!/bin/bash
# Summary : Récupère la dernière version de spip_loader.php.
set -euo pipefail

util_bin_ok "wget"

wget https://get.spip.net/spip_loader.php -O spip_loader.php
