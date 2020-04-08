#!/bin/bash
set -euo pipefail

get_main_options () {
    local options

    # shellcheck disable=SC2154
    options="$( get_file_meta "${script_dir}/spipsh" "options" )"
    echo "$options" | awk '
BEGIN { RS="%% " }

/[^[:blank:]]/ {
    print $1
}
'
}

get_main_option_param () {

    get_file_meta_option "${script_dir}/spipsh" "$1" "$2"
}
