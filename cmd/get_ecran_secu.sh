#!/bin/bash
set -euo pipefail

read -r _ file < <(caller)
if [[ ! -f "$file" ]] || [[ ! "$file" =~ /spipsh$ ]]; then
    echo "Ce script doit être appelé par spipsh." 1>&2;
    exit 2;
fi

check_program "wget"

wget --output-document=config/ecran_securite.php https://zone.spip.org/trac/spip-zone/browser/_core_/securite/ecran_securite.php?format=txt
