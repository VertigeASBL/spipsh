#!/bin/bash
# Summary : Ouvre une connexion à mysql dans le terminal
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

util_mysql_quiet --user "$db_user" --password="$db_pwd" --host="$db_host" --port="$db_port" "$db_name";
