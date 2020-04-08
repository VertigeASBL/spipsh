#!/bin/bash
# Description : Exécute une commande MySQL.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

if [[ -z "${db_query+x}" ]]; then
    out_usage_error "Vous devez spécifier une commande à exécuter.";
fi

util_mysql_quiet --execute="$db_query"\
            --user "$db_user" --password="$db_pwd"\
            --host="$db_host" --port="$db_port" "$db_name"
