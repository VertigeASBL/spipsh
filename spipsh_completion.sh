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
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # first argument : the command
    if [[ ${prev} == 'spipsh' ]] ; then
        opts="init init_vertige cc importdb dumpdb mysql ftp getimg get_loader"
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    # complete some commands
    else
        case "${prev}" in
            importdb)
                local running=$({ ls ${cur}*.sql.gz & ls -d ${cur}*/ ; } 2> /dev/null)
                COMPREPLY=( $(compgen -W "${running}" -- ${cur}) )
                return 0
                ;;
            *)
                return 0
                ;;
        esac
    fi

}

complete -F _spipsh_completion spipsh