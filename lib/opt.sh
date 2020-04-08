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
