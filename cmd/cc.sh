#!/bin/bash
# Summary : Vide les caches du dossier tmp, à la dure, sans passer par SPIP.
# Env : spip
set -euo pipefail

# shellcheck disable=2154
out_exec "vide le cache"\
            rm -rf "${tmp_dir}"/{cache,plugin_xml_cache.gz,meta_cache.php,menu-rubriques-cache.txt} \&\&\
            rm -rf "${local_dir}"/{cache-css,cache-js}

# shellcheck disable=2154
if [[ $all -eq 1 ]] ; then
    out_exec "vide le cache des vignettes"\
                rm -rf "${local_dir}"/*;
fi
