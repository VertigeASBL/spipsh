#!/bin/bash
set -euo pipefail

_spip_get_root () {
    local spip_root cwd

    spip_root='';

    cwd=$( pwd );
    while [[ $( pwd ) != '/' ]]; do
        if [[ -f 'ecrire/inc_version.php' ]]; then
            spip_root=$( pwd );
            break;
        fi
        cd ..;
    done;
    cd "$cwd";

    if [[ -z "$spip_root" ]]; then
        out_fatal_error "ecrire/inc_version.php introuvable. Ce script doit être exécuté dans l'arborescence d'un site SPIP."
    fi;

    echo "$spip_root";
}

_spip_get_env () {

    spip_root=$( _spip_get_root );

    # On se place à la racine du SPIP si c'est possible, on annule tout sinon.
    if [[ -z "$spip_root" ]]; then
        exit 1;
    else
        cd "$spip_root" || exit 1;
    fi;

    # charger des variables d'environnement dans un fichier .env
    if [ -r .env ]; then
        # shellcheck source=/dev/null
        source .env
    elif [ -r .env.gpg ]; then
        eval "$(gpg -d .env.gpg 2> /dev/null)"
    fi

    # charger les accès à la DB depuis config/connect.php
    # shellcheck disable=2154
    if [[ -f "config/${connect}.php" ]]; then

        # shellcheck disable=SC2034,2046,2026
        IFS=',' read -r db_host db_port db_user db_pwd db_name _ db_prefix _ <<< \
             $( grep spip_connect_db "config/${connect}.php"\
                    | sed 's/^spip_connect_db(//'\
                    | sed -E "s/[^']*'([^']*)'?/\1,/g"\
                    | sed "s/);//"\
                    | head --lines=1 );

        if [[ -z "$db_port" ]]; then
            db_port=3306; # use default
        fi;
    else
        out_fatal_error "Le fichier config/${connect}.php n'existe pas, est-ce que ce SPIP est bien installé ?";
    fi

    # charger les accès au ftp de prod depuis la config de git
    if [[ -z ${ftp_user+x} ]]; then
        ftp_user="$( git config --get git-ftp.user || echo '' )";
    fi;
    if [[ -z ${ftp_pwd+x} ]]; then
        ftp_pwd="$( git config --get git-ftp.password || echo '' )";
    fi;
    if [[ -z ${ftp_url+x} ]]; then
        ftp_url="$( git config --get git-ftp.url || echo '' )";
    fi;
}

util_bin_ok () {
    if [[ ! -x $(command -v "$1") ]]; then
        out_fatal_error "Le programme $1 n'est pas installé.";
    fi
}

util_ssh_exec () {
    util_bin_ok "ssh";

    # shellcheck disable=2154,2029
    ssh "$ssh_user"@"$prod_host" "$1"
}

util_filter_warnings() {

    grep --no-messages --invert-match 'Using a password on the command line interface can be insecure.';
}

# une version de la commande mysql qui ne fait pas de warnings quand on passe le
# mot de passe en option.
util_mysql_quiet () {
    util_bin_ok "mysql";

    mysql "$@" 2> >(util_filter_warnings >&2);
}

# une version de zcat qui sait aussi lire le fichier non-compressés.
util_zcat_or_cat () {

    ( zcat "$1" 2> /dev/null || cat "$1" )
}

out_exec () {

    # the summary in green
    if [[ -n "$1" ]]; then
        echo "$(_out_tput setaf 2)# $1$(_out_tput sgr 0)"
    fi
    shift
    if [[ ${dry_run:-0} -ne 1 ]]; then
        # the command in blue
        echo "$(_out_tput setaf 4)> $*$(_out_tput sgr 0)"
        # execute the command
        eval "$*"
    else
        # the command in dimmed blue
        echo "$(_out_tput dim)$(_out_tput setaf 4)> $*$(_out_tput sgr 0)"
    fi
}
