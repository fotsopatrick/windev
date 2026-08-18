#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Garde-fou anti-invention.

Lit un ou plusieurs fichiers de code WLangage (ou l'entree standard) et liste
les appels de fonction qui NE SONT PAS dans le catalogue. Un nom inconnu est
soit une fonction inventee (a corriger), soit une de TES procedures locales
(normal). L'outil ne compile pas : il signale, il ne tranche pas a ta place.

Usage :
    outils/verifier-fonctions.py fichier1.wl [fichier2.wl ...]
    cat code.wl | outils/verifier-fonctions.py
Code de sortie : 0 si aucun inconnu, 1 s'il y a au moins un inconnu.
"""
import sys, os, re

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CAT = os.path.join(RACINE, "corpus-doc-pcsoft", "catalogue_fonctions.tsv")

# Mots-cles WLangage a ne jamais signaler comme fonctions.
KEYWORDS = {
    "SI","SINON","SINONSI","FIN","POUR","TOUT","TANTQUE","BOUCLE","SELON",
    "CAS","AUTRECAS","RETOUR","RENVOYER","SORTIR","CONTINUER","PROCEDURE",
    "FONCTION","ET","OU","NON","PAS","VRAI","FAUX","NULL","EST","UN","UNE",
    "DE","LOCAL","GLOBAL","CONSTANT","STRUCTURE","CLASSE",
}

def charger_catalogue(path):
    noms = {}
    with open(path, encoding="utf-8") as f:
        next(f, None)  # entete
        for ligne in f:
            p = ligne.rstrip("\n").split("\t")
            if len(p) >= 5:
                noms[p[0]] = (p[1], p[3], p[4])  # id, v25, v2026
    return noms

def lire_source(args):
    if args:
        textes = []
        for chemin in args:
            with open(chemin, encoding="utf-8", errors="replace") as f:
                textes.append(f.read())
        return "\n".join(textes)
    return sys.stdin.read()

def main():
    if not os.path.isfile(CAT):
        print("Catalogue introuvable : %s" % CAT, file=sys.stderr)
        return 66
    noms = charger_catalogue(CAT)
    source = lire_source(sys.argv[1:])

    # On enleve les commentaires ligne (//) pour ne pas y pecher de faux appels.
    source = re.sub(r"//[^\n]*", "", source)

    # Un appel = un identifiant (lettres unicode, chiffres, _) suivi de '('.
    motif = re.compile(r"([^\W\d]\w*)\s*\(", re.UNICODE)
    candidats = []
    vus = set()
    for m in motif.finditer(source):
        nom = m.group(1)
        if nom in vus:
            continue
        vus.add(nom)
        candidats.append(nom)

    connus, inconnus = [], []
    for nom in candidats:
        if nom in noms:
            connus.append(nom)
        elif nom.upper() in KEYWORDS:
            continue
        else:
            inconnus.append(nom)

    if connus:
        print("== Fonctions trouvees au catalogue ==")
        for nom in sorted(connus):
            idp, v25, v26 = noms[nom]
            tag = ("v25" if v25 == "1" else "   ") + " " + ("v2026" if v26 == "1" else "")
            print("  [ok] %-36s %s  (id %s)" % (nom, tag, idp))
    if inconnus:
        print("\n== A VERIFIER (absents du catalogue) ==")
        print("   Chacun est soit une fonction inventee (a corriger),")
        print("   soit une de TES procedures locales (normal).")
        for nom in sorted(inconnus):
            print("  [??] %s" % nom)
    if not inconnus:
        print("\nAucun appel inconnu. (Les procedures locales, si presentes, sont au catalogue ou sont des mots-cles.)")
    return 1 if inconnus else 0

if __name__ == "__main__":
    sys.exit(main())
