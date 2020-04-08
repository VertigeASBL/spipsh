#!/bin/bash
set -euo pipefail

usage_error () {
    # texte en jaune
    echo "$(tput setaf 3)$1$(tput sgr 0)" 1>&2;
    exit 2;
}

fatal_error () {
    # texte en rouge
    echo "$(tput setaf 1)$1$(tput sgr 0)" 1>&2;
    exit 1;
}

do_and_tell () {
    # la description en vert s'il y en a une
    if [[ -n "$1" ]]; then
        echo "$(tput setaf 2)# $1$(tput sgr 0)"
    fi
    shift
    if [[ ${dry_run:-0} -ne 1 ]]; then
        # la commande en bleu
        echo "$(tput setaf 4)> $*$(tput sgr 0)"
        # exécuter la commande
        eval "$*"
    else
        # la commande en bleu dimmé
        echo "$(tput dim)$(tput setaf 4)> $*$(tput sgr 0)"
    fi
}

is_registered_command () {

    if [[ -f "${script_dir:?}/cmd/${1}.sh" ]]; then
        return 0
    else
        return 1
    fi
}

get_command_meta () {

    get_file_meta "$script_dir/cmd/${1}.sh" "$2"
}

get_file_meta () {

    local file meta

    file="$1"
    meta="$2"

    <"$file" awk -v meta="$meta" '
BEGIN { stop=0; IGNORE_CASE=1 }

! /^#/ { stop=1 }

/^# / && stop==0 {
    if (match($0, /^# ([^:]+) : ?(.*)$/, matches)) {
       current_meta = tolower(matches[1])
       metas[current_meta] = matches[2]
    } else {
       metas[current_meta] = metas[current_meta] substr($0, 2)
    }
}

END { print metas[meta] }
'
}

get_commands () {

    find "${script_dir:?}/cmd/" -type f -name '*.sh' -print | sort \
        | sed 's#.*/\([^/]*\)\.sh#\1#' \
        | xargs printf '%s '
}

get_commands_descriptions () {

    local cmds max_cmd_length line_index

    cmds=$(get_commands)

    max_cmd_length=0
    for cmd in $cmds; do
        if [[ ${#cmd} -gt $max_cmd_length ]]; then
            max_cmd_length=${#cmd}
        fi
    done

    cmd_col_width=$((max_cmd_length + 1))
    desc_col_width=$((term_width - cmd_col_width - 3))

    for cmd in $cmds; do
        printf "  %-${cmd_col_width}s" "$cmd"
        line_index=0
        while IFS= read -r line; do
            if [[ line_index -eq 0 ]]; then
                printf "%s\n" "$line"
            else
                printf "%17s%s\n" " " "$line"
            fi
            ((line_index++))
        done <<< "$( get_command_meta "$cmd" "description" | fmt --width="$desc_col_width" )"
    done
}
