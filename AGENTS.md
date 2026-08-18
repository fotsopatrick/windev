# AGENTS.md — instructions pour un agent qui code en WinDev

Ce fichier est lu automatiquement par opencode (et sert de consigne à toute IA
agentique). Il dit la règle, où sont les données, et quels outils lancer. Il est
le miroir local du moteur `moteur-windev.sh` de l'atelier de la tour.

## La règle absolue

**NE JAMAIS INVENTER une fonction, une propriété ou une signature WLangage.**
Le corpus public WLangage est mince : une syntaxe « plausible » est presque
toujours fausse, et elle ne se voit qu'à la compilation, chez le client. Toute
fonction employée DOIT exister dans le catalogue, et sa forme exacte se lit sur
sa page de doc.

## Ce que tu fais AVANT d'écrire la moindre ligne

1. **Cherche chaque fonction dans le catalogue.** Outil fourni :
   `outils/chercher-fonction.sh <nom-ou-fragment>` — rend l'id, la présence
   v25/v2026, le thème et les URL de doc. Sans outil, grep direct :
   `grep -i '<nom>' corpus-doc-pcsoft/catalogue_fonctions.tsv`.
   L'orthographe et les accents comptent (`HeureSys`, pas `HeureSYS`).
2. **Lis la page de doc** pour la signature exacte :
   `https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=250` (250 = v25 ; 310 = 2026).
   La page n'a de contenu qu'avec les cookies de session du site : passe par un
   navigateur connecté, pas un simple GET (voir
   `corpus-doc-pcsoft/METHODE_DOC_WINDEV.md`).
3. **Regarde les colonnes v25 et v2026.** Présente dans les deux = sûre.
   Présente seulement en 2026 = à signaler si la cible est plus ancienne. Si la
   version cible n'est pas donnée, DIS-LE et raisonne sur ce qui est dans les
   deux.

## Ce que tu fais APRÈS avoir écrit

Passe le garde-fou anti-invention sur ton code :
`outils/verifier-fonctions.py <ton-fichier.wl>` — il liste les appels qui ne
sont PAS au catalogue. Un nom inconnu est soit une fonction inventée (à
corriger), soit une de TES procédures locales (normal). À toi de trancher, nom
par nom.

## Comment tu marques ce que tu livres

- `[établi]` — vérifié au catalogue ou sur une page de doc.
- `[dérivé]` — raisonnement exposable à partir d'un établi.
- `[comblé]` — plausible mais non ancré : à signaler, jamais présenté comme
  acquis. Mieux vaut poser la question.
- `[signature à confirmer]` — le nom existe, mais tu n'as pas lu la page.

Tout nom de table, de champ ou de procédure est « à vérifier dans le dépôt »
tant qu'il n'a pas été relu dans le code réel du projet.

## Pièges de langage déjà payés (détail dans 01-pieges-windev.md)

- `SORTIR` quitte la boucle, `RETOUR` quitte la procédure ; `SORTIR` hors
  boucle = erreur de compilation.
- `HeureCourante()` n'existe pas → `HeureSys()` (id 3027019).
- `iImprimanteParDéfaut()` n'existe pas → `iInfoImprimante(Faux)`.
- La propriété `..Mois` d'une date n'accepte pas de valeur négative.

## Les documents du dépôt

- `00-DEMARRAGE-IA.md` — le pas-à-pas complet (à lire en premier).
- `01-pieges-windev.md` — pièges langage + pilotage de l'IDE.
- `02-index-doc-pcsoft.md` — pages de doc déjà confirmées.
- `03-interface-editeur-windev.md` — carte de l'éditeur (volets, champs,
  raccourcis) pour piloter l'IDE à pywinauto.
- `04-tester-en-windev-25.md` — comment tester (`dbg*`, `Test*`).
- `corpus-doc-pcsoft/` — les catalogues (nom, id, thème, v25, v2026).
- `moteur-windev.sh` — le moteur de l'atelier (contrat : consigne sur l'entrée,
  compte rendu sur la sortie, code 0 = réussi).
- `outils/` — les outils déterministes (voir ci-dessus).

## Ton compte rendu, dans cet ordre

1. Ce que tu as compris de la demande, en trois lignes.
2. Les fonctions employées, avec leur statut de vérification.
3. Le code complet des procédures.
4. Ce que tu n'as pas pu vérifier, et la question exacte à poser.

## Ce qui n'est PAS dans ce dépôt

Le script `.py` de **pilotage** de l'IDE tourne sur le poste Windows (là où est
`WDExpress.exe`), pas ici. Ce dépôt te donne le savoir (corpus + méthode +
tests) ; le pilotage réel se fait sur la machine qui a WinDev installé.
