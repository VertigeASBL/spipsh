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
        opts="\
cc \
init \
get_loader \
get_ecran_secu \
db-query \
db-import \
db-dump \
db-login \
run-script \
prod-db-dump \
prod-ssh \
prod-ftp \
prod-getimg \
prod-tramp";
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    # complete some commands
    else
        case "${prev}" in
            cc)
                COMPREPLY=( $(compgen -W "all" -- ${cur}) );
                return 0;
                ;;
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
                return 0
                ;;
        esac
    fi

}

complete -F _spipsh_completion spipsh
