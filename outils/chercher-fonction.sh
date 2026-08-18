#!/usr/bin/env bash
# Cherche une fonction WLangage dans le catalogue et donne son id + URL de doc.
# Usage : outils/chercher-fonction.sh <nom-ou-fragment>
set -euo pipefail
RACINE="$(cd "$(dirname "$0")/.." && pwd)"
CAT="$RACINE/corpus-doc-pcsoft/catalogue_fonctions.tsv"
[ -f "$CAT" ] || { echo "Catalogue introuvable : $CAT" >&2; exit 66; }
motif="${1:-}"
[ -z "$motif" ] && { echo "Usage : $0 <nom-ou-fragment>"; exit 2; }

awk -F'\t' -v m="$motif" '
NR==1 { next }
index(tolower($1), tolower(m)) {
  v25 = ($4=="1") ? "v25" : "   "
  v26 = ($5=="1") ? "v2026" : "     "
  printf "%-40s  %s %s  id=%-12s  %s\n", $1, v25, v26, $2, $3
  printf "    doc v25   : https://doc.pcsoft.fr/fr-FR/?%s&verdisp=250\n", $2
  printf "    doc 2026  : https://doc.pcsoft.fr/fr-FR/?%s&verdisp=310\n", $2
  n++
}
END {
  if (n+0 == 0) {
    print "Aucune fonction ne contient : " m
    print "=> sous cette forme, elle n existe probablement pas. Cherche une famille voisine (colonne theme)."
    exit 1
  }
  printf "\n%d resultat(s).\n", n
}' "$CAT"
