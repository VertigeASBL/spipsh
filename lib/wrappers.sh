#!/bin/bash
set -euo pipefail

check_program () {
    if [[ ! -x $(which "$1") ]]; then
        fatal_error "Le programme $1 n'est pas installé.";
    fi
}

ssh_do () {
    check_program "ssh";

    ssh "$ssh_user"@"$prod_host" "$1"
}

remove_some_warnings() {

    grep --no-messages --invert-match 'Using a password on the command line interface can be insecure.';
}

# une version de la commande mysql qui ne fait pas de warnings quand on passe le
# mot de passe en option.
mysql_quiet () {
    check_program "mysql";

    mysql "$@" 2> >(remove_some_warnings >&2);
}

# une version de zcat qui sait aussi lire le fichier non-compressés.
zcat_or_cat () {
    ( zcat "$1" 2> /dev/null || cat "$1" )
}
