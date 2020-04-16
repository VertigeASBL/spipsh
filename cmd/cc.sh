#!/bin/bash
# Summary : Vide les caches du dossier tmp, à la dure, sans passer par SPIP.
#
# Env : spip
#
# Options :
#
# % all
# desc="Permet de vider aussi le cache des vignettes."
# short="a" type="flag" variable="all" value="1" default=0
#
# % tmp-dir
# desc="Permet de choisir un répertoire tmp/ alternatif."
# short="t" type="option" variable="tmp_dir" default="tmp"
#
# % local-dir
# desc="Permet de choisir un répertoire local/ alternatif."
# short="l" type="option" variable="local_dir" default="local"
#
set -euo pipefail


# shellcheck disable=2154
if [[ ! -d "$tmp_dir" ]]; then
    out_usage_error "$tmp_dir n'est pas un dossier."
fi

# shellcheck disable=2154
if [[ ! -d "$local_dir" ]]; then
    out_usage_error "$local_dir n'est pas un dossier."
fi


# shellcheck disable=2154
out_exec "vide le cache"\
            rm -rf "${tmp_dir}"/{cache,plugin_xml_cache.gz,meta_cache.php,menu-rubriques-cache.txt} \&\&\
            rm -rf "${local_dir}"/{cache-css,cache-js}

# shellcheck disable=2154
if [[ $all -eq 1 ]] ; then
    out_exec "vide le cache des vignettes"\
                rm -rf "${local_dir}"/*;
fi
