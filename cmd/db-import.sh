#!/bin/bash
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

check_program "zcat"

if [[ -z "${db_dump+x}" ]]; then
    usage_error "Vous devez spécifier un dump sql.gz à importer";
else
    do_and_tell "vide la db"\
                mysql_quiet --execute="\"DROP DATABASE $db_name; CREATE DATABASE $db_name;"\"\
                --user "$db_user" --password='"$db_pwd"'\
                --host="$db_host" --port="$db_port";
    do_and_tell "importe le dump..."\
                zcat_or_cat "$db_dump" \| mysql_quiet --user "$db_user" --password='"$db_pwd"'\
                --host="$db_host" --port="$db_port" "$db_name";
fi
