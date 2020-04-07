#!/bin/bash

################################################################################
#                                                                              #
#            Implémente l'auto-complétion pour la commande spipsh              #
#                                                                              #
#   À copier dans le bon dossier pour l'auto-complétion de bash.               #
#                                                                              #
#   p.ex. pour ubuntu :                                                        #
#                                                                              #
#     ln -s /chemin/vers/spipsh_completion.sh /etc/bash_completion.d/spipsh    #
#                                                                              #
################################################################################

in_array() {
    search="$1";
    shift;

    for item in "$@"; do
        if [[ "$item" == "$search" ]]; then
            return 0;
        fi
    done

    return 1
}

_spipsh_completion()
{
    local cur opts cmds_array cmds cmd cmd_args nb_expected_cmd_args
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="-a -d -c -t -l --all --dry-run --connect --tmp-dir --local-dir"
    cmds_array=(
        'cc'
        'init'
        'get_loader'
        'get_ecran_secu'
        'db-query'
        'db-import'
        'db-dump'
        'db-login'
        'run-script'
        'prod-db-dump'
        'prod-ssh'
        'prod-ftp'
        'prod-getimg'
        'prod-tramp'
    )
    cmds="${cmds_array[@]}"

    # Parser les options déjà saisies.
    ignore_next=0
    cmd_args=()
    for word in "${COMP_WORDS[@]}"; do
        if [[ -z "$word" ]]; then
            continue;
        elif [[ "$word" =~ ^- ]]; then
            # echo "opt: $word"
            if in_array "$word" '-t' '-d' '-c' '--connect' '--tmp-dir' '--local-dir'; then
                ignore_next=1
            fi
        elif [[ $ignore_next -gt 0 ]]; then
            # echo "optarg: $word"
            ((ignore_next--))
        elif [[ -z "${cmd+x}" ]]; then
            if in_array "$word" "${cmds_array[@]}"; then
                # echo "cmd: $word"
                cmd="$word"
            fi
        elif [[ -n "${cmd+x}" ]]; then
            # echo "cmd_arg: $word"
            cmd_args+=("$word")
        fi
    done

    if [[ ${#cur} -eq 0 ]]; then
        nb_expected_cmd_args=0
    else
        nb_expected_cmd_args=1
    fi

    if [[ -z "${cmd:+x}" ]] && [[ ! "${cur}" =~ ^- ]]; then
        COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
        return 0
    elif [[ -n "${cmd:+x}" ]] && [[ ! "${cur}" =~ ^- ]] && [[ ${#cmd_args[@]} -eq $nb_expected_cmd_args ]]; then
        case "${cmd}" in
            db-import)
                local running=$(find "."\
                                     -path "./${cur}*.sql.gz"\
                                     -type f\
                                     -print 2> /dev/null\
                                    | sed 's/^\.\///');
                COMPREPLY=( $(compgen -W "${running}" -- ${cur}) )
                return 0
                ;;
            run-script)
                local running=$(find "./bin/"\
                                     -path "./bin/${cur}*"\
                                     -type f\
                                     -executable\
                                     -print 2> /dev/null\
                                    | sed 's/^\.\/bin\///');
                COMPREPLY=( $(compgen -W "${running}" -- ${cur}) )
                return 0
                ;;
            *)
                COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                return 0
                ;;
        esac
    else
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _spipsh_completion spipsh
