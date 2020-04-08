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
    # shellcheck disable=SC2154
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

get_options_descriptions () {
    local desc_offset options usages descs usage

    desc_offset=10
    options=$(get_main_options)
    usages=()
    descs=()

    for option in $options; do
        usage="$(printf "  --%s | -%s" "$option" "$(get_main_option_param "$option" "short")")"
        if [[ -z "$(get_main_option_param "$option" "value")" ]]; then
            usage="$usage [$(get_main_option_param "$option" "variable" | awk '{print toupper($0)}')]"
        fi
        usages+=("$usage")
        descs+=("$(get_main_option_param "$option" "desc" | fmt --width=$((term_width - desc_offset)))")
    done

    for ((i=0; i<${#usages[@]}; i++)); do
        printf "%s\n" "${usages[i]}"
        while IFS= read -r line; do
            printf "%${desc_offset}s%s\n" " " "${line}"
        done <<< "${descs[i]}"
        echo
    done
}
