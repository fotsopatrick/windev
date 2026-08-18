# Démarrage pour une IA — coder en WinDev sans inventer

Tu es une IA (ChatGPT, Perplexity, Claude, ou autre) et on te demande d'écrire
du **WLangage** (le langage de WinDev / WEBDEV / WINDEV Mobile). Ce dépôt est ta
trousse. Lis ce fichier en entier avant d'écrire une ligne.

## La règle d'or (la seule qui ne se négocie pas)

**Ne jamais inventer une fonction, une propriété ou une signature WLangage.**
Une syntaxe « plausible » ne se voit pas à la lecture : elle se voit à la
compilation, **chez le client**. Toute fonction que tu écris doit exister dans
le catalogue, et sa forme exacte doit être lue sur sa page de doc.

Marque toujours ton niveau de certitude :
- `[établi]` — lu sur la page de doc, sûr.
- `[dérivé]` — déduit d'une page proche, à confirmer.
- `[comblé]` — tu as bouché un trou faute de mieux : à vérifier absolument.
- `[signature à confirmer]` — le nom existe (catalogue), mais tu n'as pas lu la
  page : n'affirme pas les paramètres.

## Étape 1 — La fonction existe-t-elle ? (le catalogue)

Le dossier `corpus-doc-pcsoft/` contient les catalogues. Cherche le nom exact
(avec ses accents) dedans :

- `catalogue_fonctions.tsv` — les 6 284 fonctions des deux versions : `nom`,
  `id`, `thème`, présence v25 (0/1), v2026 (0/1).
- `catalogue_fonctions_v25.tsv` — vue v25 seule (`nom`, `id`, `thème`), 4 769.
- `catalogue_fonctions_v2026.tsv` — vue 2026 seule, 6 030.
- `nouvelles_fonctions_v2026_vs_v25.tsv` — présentes en 2026, absentes en 25.
- `fonctions_supprimees_apres_v25.tsv` — en 25, disparues en 2026.
- `proprietes_types.tsv` — propriétés (~733) et types de variables (~410).
- `familles_fonctions.tsv` — les pages « sommaire de famille ».

Si le nom n'y est pas : **la fonction n'existe pas** sous cette forme. Ne
l'écris pas. Cherche une famille voisine (colonne `thème`).

## Étape 2 — Quelle est sa signature ? (la page de doc)

Le catalogue donne le `nom`, l'`id`, la version — **pas** la signature. Pour la
signature exacte :

`https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=<version>`

- `verdisp=250` → WinDev **25**. `verdisp=310` → version **2026**.
- La page rend le contenu **seulement avec les cookies de session** du site :
  un fetch externe sans cookies renvoie la page d'accueil. **Passe par un vrai
  navigateur** (session ouverte sur doc.pcsoft.fr), pas par un simple GET.
- Depuis une page du site, tu peux lire n'importe quelle autre :
  `fetch('https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=250',{credentials:'include'})`.
- Le nom anglais est affiché sur chaque page (« En anglais : … »).

La méthode complète est dans `corpus-doc-pcsoft/METHODE_DOC_WINDEV.md`.

## Étape 3 — Les pièges qui coûtent cher (à lire avant d'écrire)

`01-pieges-windev.md` — les pièges déjà payés, tranchés. Exemples :
- `SORTIR` sort d'une **boucle**, `RETOUR` quitte une **procédure** ; `SORTIR`
  hors boucle = erreur de compilation.
- `HeureCourante()` **n'existe pas** ; c'est `HeureSys()` (id 3027019).
- `iImprimanteParDéfaut()` **n'existe pas** ; c'est `iInfoImprimante(Faux)`.
- La propriété `..Mois` d'une date n'accepte pas de valeur négative.

## Étape 4 — Écrire dans l'éditeur et fabriquer une fenêtre

`03-interface-editeur-windev.md` — la carte de l'éditeur WinDev (volets,
actions, boîte à outils des champs). Si tu **pilotes** l'IDE (comme on pilote un
navigateur), c'est fait avec **pywinauto** en **Python 32 bits** ; la méthode en
six gestes est dans `01-pieges-windev.md` §3 et rappelée dans le `README.md` :
`Ctrl+N` pour la fenêtre, clic-palette-puis-zone pour poser un champ, `F2` sur
un champ pour ouvrir son code, `Ctrl+V` pour coller (les accents ne se tapent
pas bien), `F9` pour tester.

## Étape 5 — Tester ce que tu as écrit

`04-tester-en-windev-25.md` — comment tester en v25 avec les vraies fonctions :
`dbgVérifieEgalité`, `dbgAssertion` (assertions dans le code) et `TestVérifie*`,
`TestEcritRésultat` (tests automatiques). Un test **vert lancé** prouve ; un test
seulement écrit ne prouve rien.

## Quelques repères de langage (pour situer, pas pour remplacer la doc)

- WLangage a des **mots-clés en français**, et les noms de fonctions portent des
  **accents** (`HLitPremier`, `ChaîneVersNumérique`). Respecte-les.
- Commentaire : `//`. Fin de procédure : `RETOUR` ; renvoyer une valeur :
  `RENVOYER`. Étiquette de fin de traitement : `FIN :`.
- Déclarer : `n est un entier`, `s est une chaîne`, `d est une Date`.
- Les fonctions de base de données HFSQL commencent par `H` (`HAjoute`,
  `HLitRecherche`, `HModifie`…). Vérifie chacune au catalogue + page.
- Le champ **Chat IA** natif (`<TOOL IA>`) permet à une IA d'exécuter des
  procédures WLangage comme outils — voir `02-index-doc-pcsoft.md`.

## Le résumé en une phrase

Cherche le nom au **catalogue** → lis la **page** `?<id>&verdisp=250` → écris
l'appel → **teste** → marque ton niveau de certitude. Jamais l'inverse, jamais
d'invention.
