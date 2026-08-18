#!/usr/bin/env bash
# Moteur « windev » — WinDev / WLangage sur le harnais DeepSeek (agent_deepseek.py),
# avec le corpus PC SOFT et l'interdiction d'inventer une signature WLangage.
#
# Pourquoi un moteur dédié plutôt qu'une consigne bien écrite : parce qu'une
# consigne bien écrite, on oublie de la réécrire. Ici la règle est dans le
# moteur — elle s'applique à toutes les missions WinDev, y compris celles
# envoyées depuis un téléphone en trois lignes.
#
# Le cerveau (07/08, Patrick) : WinDev passe de Claude (abandonné le 31/07,
# trop cher) au MÊME harnais que Clark et Chloé — agent_deepseek.py, qui sait
# lire, écrire et exécuter. Le modèle se règle par ATELIER_DEEPSEEK_MODELE
# (défaut deepseek-chat) dans .env-moteurs.
#
# Le corpus vit dans ~/atelier/corpus/windev et il est RECOPIÉ dans le dossier
# de travail : la mission peut lire, écrire, se tromper, sans jamais abîmer
# l'original.
#
# Contrat commun à tous les moteurs de l'atelier :
#   - la consigne arrive sur l'entrée standard
#   - le compte rendu part sur la sortie standard
#   - le dossier courant est le dossier de travail de la mission
#   - code de sortie 0 = réussite, tout le reste = échec
set -uo pipefail
RACINE="${ATELIER_RACINE:-/home/ubuntu/atelier}"
CORPUS="$RACINE/corpus/windev"

if [ ! -d "$CORPUS" ]; then
    echo "Le corpus WinDev est absent de $CORPUS."
    echo "Sans lui, aucune signature ne peut être vérifiée — et une signature"
    echo "WLangage inventée coûte plus cher qu'une mission non faite."
    exit 66
fi

if [ ! -f "$CORPUS/corpus-doc-pcsoft/catalogue_fonctions.tsv" ]; then
    echo "Le catalogue des fonctions est absent du corpus copié."
    exit 66
fi

consigne="$(cat)"
if [ -z "$consigne" ]; then
    echo "Aucune consigne reçue sur l'entrée standard."
    exit 2
fi

cp -r "$CORPUS" ./doc-windev 2>/dev/null || {
    echo "Copie du corpus impossible dans $(pwd)."
    exit 66
}

# La règle est répétée AVANT et APRÈS la demande : ce qui est lu en dernier
# pèse autant que ce qui est lu en premier.
cadre=$(cat <<'FIN'
Tu travailles sur du WinDev / WLangage (produit client confidentiel — le
domaine métier n'est pas ton sujet : tu écris du WLangage vérifié).

RÈGLE ABSOLUE — NE JAMAIS INVENTER UNE SIGNATURE WLANGAGE.
Le corpus public WLangage est mince : une syntaxe « plausible » est presque
toujours fausse, et elle ne se voit qu'à la compilation, chez le client.

Le dossier ./doc-windev contient un corpus vérifié, récolté sur doc.pcsoft.fr :
  - corpus-doc-pcsoft/catalogue_fonctions.tsv
      6 285 fonctions : nom, identifiant de page, thème, présence en v25 et
      en v2026. C'EST TON OUTIL DE VÉRIFICATION. Une fonction absente de ce
      fichier n'existe probablement pas.
  - corpus-doc-pcsoft/catalogue_fonctions_v25.tsv — uniquement v25.
  - corpus-doc-pcsoft/catalogue_fonctions_v2026.tsv — uniquement v2026.
  - corpus-doc-pcsoft/proprietes_types.tsv — propriétés et types de variables.
  - corpus-doc-pcsoft/nouvelles_fonctions_v2026_vs_v25.tsv
  - corpus-doc-pcsoft/fonctions_supprimees_apres_v25.tsv
  - corpus-doc-pcsoft/familles_fonctions.tsv — les thèmes de la doc.
  - corpus-doc-pcsoft/METHODE_DOC_WINDEV.md — comment retrouver une page de
    doc à partir de son identifiant.
  - 02-index-doc-pcsoft.md — les pages déjà consultées et confirmées.
    LIS-LE AVANT D'ÉCRIRE : il évite de redemander une doc déjà obtenue.
  - 03-interface-editeur-windev.md — la carte des volets, actions, champs et
    raccourcis de l'éditeur WinDev (capture réelle de l'IDE sur le poste).
    Lis-le quand la mission concerne le pilotage de l'IDE (pywinauto) ou ce
    que l'éditeur permet.

CE QUE TU FAIS AVANT D'ÉCRIRE LA MOINDRE LIGNE :
1. Pour chaque fonction WLangage que tu comptes employer, cherche son nom
   exact dans catalogue_fonctions.tsv. L'orthographe et les accents comptent.
   Exemple de piège réel : c'est « iListeImprimante » au singulier, et
   « iImprimanteParDéfaut » n'existe pas du tout.
2. Regarde les colonnes v25 et v2026. Une fonction présente dans les deux est
   sûre. Une fonction présente seulement en 2026 est à signaler si la version
   cible est plus ancienne.
3. Si la version cible n'est pas indiquée dans la demande, DIS-LE et raisonne
   sur ce qui est présent dans les deux versions.

COMMENT TU MARQUES CE QUE TU LIVRES :
  [établi]  — vérifié dans le catalogue ou dans une page de doc.
  [dérivé]  — raisonnement exposable à partir d'un établi.
  [comblé]  — plausible mais non ancré. À signaler explicitement, jamais
              présenté comme acquis. Mieux vaut poser la question.
Tout nom de table, de champ ou de procédure venant du glossaire est au mieux
« à vérifier dans le dépôt » tant qu'il n'a pas été relu dans le code.

PIÈGES DE LANGAGE DÉJÀ PAYÉS :
  - SORTIR quitte la boucle, RETOUR quitte la procédure. SORTIR est interdit
    hors boucle.
  - La propriété ..Mois d'une date n'accepte pas de valeur négative : faire le
    report en arithmétique entière, jamais par soustraction directe.
  - Une source de données reçue d'une grille contient les valeurs AVANT
    sauvegarde : relire en base avant de mapper vers une API.

TON COMPTE RENDU CONTIENT, DANS CET ORDRE :
  1. Ce que tu as compris de la demande, en trois lignes.
  2. Les fonctions employées, avec leur statut de vérification.
  3. Le code complet des procédures travaillées.
  4. Ce que tu n'as pas pu vérifier, et la question exacte à poser.

------------------------------ LA DEMANDE ------------------------------
FIN
)

rappel="
------------------------------------------------------------------------
RAPPEL FINAL : aucune signature WLangage non vérifiée dans le catalogue
./doc-windev/corpus-doc-pcsoft/catalogue_fonctions.tsv. En cas de doute,
marque [comblé] et pose la question — ne devine pas."

if [ ! -f "$RACINE/moteurs/agent_deepseek.py" ]; then
    echo "Le harnais DeepSeek est introuvable sur ce serveur."
    exit 1
fi

printf '%s\n\n%s\n%s\n' "$cadre" "$consigne" "$rappel" \
    | python3 "$RACINE/moteurs/agent_deepseek.py"
