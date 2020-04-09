#!/bin/bash
# Description : Importe un dump au format sql.gz dans la base de données MySQL.
# Env : spip
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

util_bin_ok "zcat"

# shellcheck disable=SC2154
db_dump="${cmd_args[*]}"

if [[ -z "$db_dump" ]]; then
    out_usage_error "Vous devez spécifier un dump sql.gz à importer";
else
    # shellcheck disable=SC2154,SC2016,SC2026
    out_exec "vide la db"\
                util_mysql_quiet --execute="\"DROP DATABASE $db_name; CREATE DATABASE $db_name;"\"\
                --user "$db_user" --password='"$db_pwd"'\
                --host="$db_host" --port="$db_port";
    # shellcheck disable=SC2016,SC2026
    out_exec "importe le dump..."\
                util_zcat_or_cat "$db_dump" \| util_mysql_quiet --user "$db_user" --password='"$db_pwd"'\
                --host="$db_host" --port="$db_port" "$db_name";
fi
