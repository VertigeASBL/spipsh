#!/bin/bash
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

do_and_tell "vide le cache"\
            rm -rf ${tmp_dir:-tmp}/{cache,plugin_xml_cache.gz,meta_cache.php,menu-rubriques-cache.txt} \&\&\
            rm -rf ${local_dir:-local}/{cache-css,cache-js}

if [[ -n ${all+x} ]] ; then
    do_and_tell "vide le cache des vignettes"\
                rm -rf ${local_dir:-local}/*;
fi
