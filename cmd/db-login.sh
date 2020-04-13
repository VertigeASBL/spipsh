#!/bin/bash
# Summary : Ouvre une connexion à mysql dans le terminal
# Env : spip
set -euo pipefail


util_mysql_quiet --user "$db_user" --password="$db_pwd" --host="$db_host" --port="$db_port" "$db_name";
