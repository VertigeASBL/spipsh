#!/bin/bash
set -euo pipefail

_opt_get_all () {
    local options

    # shellcheck disable=SC2154
    options="$( _meta_get "${script_dir}/spipsh" "options" )"
    echo "$options" | awk '
BEGIN { RS="%% " }

/[^[:blank:]]/ {
    print $1
}
'
}

_opt_get_param () {

    _meta_get_option "${script_dir}/spipsh" "$1" "$2"
}

_opt_expand_short_opts () {
    local options short_options args i char

    options=$(_opt_get_all)
    short_options=""

    for opt in $options; do
        short_options="$short_options$(_opt_get_param "$opt" "short")"
    done

    args=()
    while [[ -n ${1+x} ]]; do
        if [[ "$1" =~ ^-[${short_options}]+ ]]; then
            for (( i=0; i<${#1}; i++ )); do
                char=${1:$i:1}
                if [[ $char != '-' ]]; then
                    args+=("-$char")
                fi
            done
        else
            args+=("$1")
        fi
        shift;
    done

    echo "${args[@]}"
}

opt_parse () {

    # shellcheck disable=SC2068,SC2046
    set -- $(_opt_expand_short_opts $@)

    # parser et valider les arguments
    spipsh_opts="";
    while [[ -n "${1+x}" ]]; do
        if [[ ! "$1" =~ ^- ]]; then
            if [[ -z ${cmd+x} ]]; then
                cmd="$1";
            else
                case $cmd in
                    db-query)
                        # utilisé par la commande db-query
                        # shellcheck disable=SC2034
                        db_query="$1";
                        ;;
                    db-import)
                        # utilisé par la commande db-dump
                        # shellcheck disable=SC2034
                        db_dump="$1";
                        ;;
                    run-script)
                        # utilisé par la commande run-script
                        # shellcheck disable=SC2034
                        script="$1";
                        ;;
                esac
            fi
        else
            spipsh_opts="$spipsh_opts $1";
            opt="$1"
            case $opt in
                -a | --all)
                    # utilisé par la commande cc
                    # shellcheck disable=SC2034
                    all=1;
                    ;;
                -d | --dry-run)
                    # shellcheck disable=SC2034
                    dry_run=1;
                    ;;
                -t | --tmp-dir)
                    shift;
                    if [[ -z "${1+x}" ]]; then
                        out_usage_error "L'option $opt nécessite un nom de dossier en argument."
                    fi

                    tmp_dir="$1";

                    if [[ ! -d "$tmp_dir" ]]; then
                        out_usage_error "$tmp_dir n'est pas un répertoire."
                    fi
                    spipsh_opts="$spipsh_opts $1";
                    ;;
                -l | --local-dir)
                    shift;
                    if [[ -z "${1+x}" ]]; then
                        out_usage_error "L'option $opt nécessite un nom de dossier en argument."
                    fi

                    local_dir="$1";

                    if [[ ! -d "$local_dir" ]]; then
                        out_usage_error "$local_dir n'est pas un répertoire."
                    fi
                    spipsh_opts="$spipsh_opts $1";
                    ;;
                -c | --connect)
                    shift;
                    if [[ -z "${1+x}" ]]; then
                        out_usage_error "L'option $opt nécessite un nom de fichier en argument."
                    fi

                    connect="$1";

                    if [[ ! -f "config/${connect}.php" ]]; then
                        out_usage_error "config/${connect}.php n'est pas un fichier."
                    fi
                    spipsh_opts="$spipsh_opts $1";
                    ;;
                *)
                    out_usage_error "option invalide : $1"
                    ;;
            esac
        fi
        shift;
    done
}
