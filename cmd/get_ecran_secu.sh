#!/bin/bash
# Summary : Récupère et installe la dernière version de l'écran de sécurité.
# Env : spip
set -euo pipefail

util_bin_ok "wget"

wget --output-document=config/ecran_securite.php https://git.spip.net/spip-contrib-outils/securite/raw/branch/master/ecran_securite.php
