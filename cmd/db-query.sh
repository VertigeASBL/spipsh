#!/bin/bash
# Summary : Exécute une commande MySQL.
# Env : spip
set -euo pipefail


# shellcheck disable=SC2154
db_query="${CMD_ARGS[*]}"

if [[ -z "$db_query" ]]; then
    out_usage_error "Vous devez spécifier une commande à exécuter.";
fi

# shellcheck disable=SC2154
util_mysql_quiet --execute="$db_query" \
                 --user "$db_user" --password="$db_pwd"\
                 --host="$db_host" --port="$db_port" "$db_name"
