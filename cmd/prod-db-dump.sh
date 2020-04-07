#!/bin/bash
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

check_program "ssh";
check_program "gzip";

if [[ -z $prod_web_dir ]]; then
    prod_web_dir='public';
fi;

mkdir -p backup-db/prod

now=$(date '+%F-%R');
current_commit=$(ssh_do "cd $prod_web_dir && git log -1 --format='%H'");
filename="backup-db/prod/$site_slug-prod-$now-$current_commit.sql.gz";

do_and_tell "Importer la DB de production dans un dump local"\
            ssh -C "$ssh_user"@"$prod_host"\
            '"mysqldump -h' "$db_prod_host" '-u' "$db_prod_user" '-p$db_prod_pass --add-drop-table' "$db_prod_name" \
            '2> <(grep -v \"Using a password on the command line interface can be insecure.\" >&2);"' \
            \| gzip \> "$filename";
