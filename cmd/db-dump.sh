#!/bin/bash
# Summary : Dump la db dans stdout.
# Env : spip
set -euo pipefail

util_bin_ok "mysqldump"

mysqldump --user "$db_user" --password="$db_pwd" --host="$db_host" --port="$db_port" "$db_name" \
          2> <(util_filter_warnings);
