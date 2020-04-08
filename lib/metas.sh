#!/bin/bash
set -euo pipefail

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

get_file_meta_option () {

    local options

    # shellcheck disable=SC2154
    options="$( get_file_meta "$1" "options" )"
    echo "$options" | awk -v option="$2" -v param="$3" '
BEGIN { RS="%% " }

/[^[:blank:]]/ {
    if ($1 == option) {
        cmd = substr($0, length($1)+2) sprintf("\n echo -n $%s", param)
        if ((cmd | getline result) > 0) {
            printf "%s", result
        }
    }
}
'
}

