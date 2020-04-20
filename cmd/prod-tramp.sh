#!/bin/bash
# Summary : Ouvrir le dossier racine de la prod dans emacs.
# Env : spip
set -euo pipefail

util_bin_ok "emacs"

# shellcheck disable=2154
emacsclient --eval "(find-file \"/ssh:$ssh_user@$prod_host:.\")"
