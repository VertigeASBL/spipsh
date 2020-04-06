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

_spipsh_completion()
{
    local cur opts cmds_array cmds cmd
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

    for word in "${COMP_WORDS[@]}"; do
        if [[ -n "$word" ]] && [[ ! "$word" =~ ^- ]]; then
            for command in "${cmds_array[@]}"; do
                if [[ "$command" == "$word" ]]; then
                    cmd="$word";
                    break 2;
                fi
            done
        fi
    done

    if [[ -z "${cmd:+x}" ]] && [[ ! "${cur}" =~ ^- ]]; then
        COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
        return 0
    elif [[ -n "${cmd:+x}" ]] && [[ ! "${cur}" =~ ^- ]]; then
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
    elif [[ "${cur}" =~ ^- ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F _spipsh_completion spipsh
