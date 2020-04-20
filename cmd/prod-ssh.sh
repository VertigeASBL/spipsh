#!/bin/bash
# Summary : Ouvre un shell sur le serveur de prod via ssh.
# Env : spip
set -euo pipefail

util_bin_ok "ssh";

# shellcheck disable=2154
ssh "$ssh_user"@"$prod_host";
