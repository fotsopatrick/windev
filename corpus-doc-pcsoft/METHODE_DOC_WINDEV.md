# Doc WinDev 25 / 2026 — méthode de consultation et corpus local

Établi le 2026-07-22 par récolte directe sur doc.pcsoft.fr (navigateur Chrome, fetch same-origin).
Tout ce qui suit est **établi** (vérifié à l'écran ou par fetch), sauf mention contraire.

## 1. URLs — ce qui marche et ce qui ne marche pas (vérifié)

- **Résolution par ID numérique : fiable.** `https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=<v>`
  Ex. : `https://doc.pcsoft.fr/fr-FR/?3044147&verdisp=250` → « HAjoute (Fonction) », version 25.
- **`verdisp` = version affichée** : `250` = WINDEV/WEBDEV/Mobile 25 ; `310` = version 2026.
  Autres valeurs vues dans le sélecteur du site : 240, 260, 270, 280, puis millésimes 2024, 2025, 2026 (→ 290, 300, 310).
- **Résolution par `name=` seul : NE marche PAS** (`?name=hajoute_fonction` ou `?name=HAjoute` → page d'accueil).
  Les URLs complètes `?<id>&name=<slug>&verdisp=<v>` marchent grâce à l'ID ; le `name` est décoratif.
- **Le contenu des pages doc est rendu côté serveur** mais **uniquement avec les cookies de session** :
  un fetch same-origin depuis une page du site (credentials include) renvoie le HTML complet ;
  un fetch externe sans cookies renvoie le gabarit d'accueil. Conséquence : **passer par le navigateur (Claude in Chrome), pas par WebFetch**.

## 2. Procédure de lookup d'une fonction (pour une session future)

1. Chercher le nom dans `catalogue_fonctions.tsv` (nom → id, présence v25/v2026).
   Normalisation nom→recherche : le nom FR exact avec accents y figure (colonne `nom`).
2. Naviguer/fetcher `https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=250` (v25) ou `&verdisp=310` (v2026).
3. Depuis une page du site, fetch same-origin possible pour tout autre ID :
   `fetch('https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=310',{credentials:'include'})`.
4. Le nom anglais de chaque fonction est affiché sur sa page (« En anglais : HDeleteAll »).
5. Pages non trouvées dans le catalogue : page « Plan du site » = `?100&name=plan_site_documentation_soft&verdisp=<v>`
   → contient TOUS les liens de la doc de cette version (~9 700 pages v25, ~11 600 v2026), rendus serveur.

## 3. Corpus local livré (récolte du 2026-07-22)

| Fichier | Contenu | Lignes |
|---|---|---|
| `catalogue_fonctions.tsv` | Toutes les pages fonction des 2 versions : nom, id, thème, v25 (0/1), v2026 (0/1) | 6 284 |
| `catalogue_fonctions_v25.tsv` | Vue filtrée v25 : nom, id, thème | 4 769 |
| `catalogue_fonctions_v2026.tsv` | Vue filtrée v2026 : nom, id, thème | 6 030 |
| `nouvelles_fonctions_v2026_vs_v25.tsv` | Fonctions présentes en 2026, absentes en 25 : nom, id, thème, description | 1 515 |
| `fonctions_supprimees_apres_v25.tsv` | Fonctions de la v25 absentes de la 2026 : nom, id, thème, description v25 | 254 |
| `proprietes_types.tsv` | Propriétés (~733 en 2026) et types de variables (~410) des 2 versions, avec flags v25/v2026 | 1 379 |
| `familles_fonctions.tsv` | Pages « sommaire de famille » (id → « Fonctions Xxx »), flags v25/v2026 | 354 |

Notes de périmètre :
- « Fonctions » inclut les pages **syntaxe préfixée** (noms commençant par `<...>`, ex. `<Source>.SupprimeTout`) : pages distinctes avec leur propre id.
- Thème = titre de la page famille, nettoyé du préfixe « Fonctions de gestion … ». Couverture desc/thème : 98 % (v2026), 97 % (v25) ; le reste a un thème vide.
- Les chiffres « nouvelles/supprimées » comparent la **présence d'une page** dans le plan du site des deux versions ; une disparition peut être un renommage de page (à vérifier au cas par cas sur le site).
- Les catalogues couvrent WINDEV + WEBDEV + WINDEV Mobile (la doc est commune ; la page de chaque fonction précise la disponibilité par produit).

## 4. Pages de référence utiles (ids vérifiés ou issus du plan)

- Plan du site : `?100&name=plan_site_documentation_soft`
- Fonctions de gestion HFSQL : `?3044156`
- Nouveautés WLangage : pages `windev_25_nouveautes_wlangage` (id 9000001) et `windev_2026_nouveautes_wlangage` (id via plan) ; équivalents webdev/mobile.
- Recherche interactive du site : boîte de recherche sur doc.pcsoft.fr (POST, non scriptable par URL simple).

## 5. Récolte reproductible (procédé validé)

Depuis un onglet Chrome sur n'importe quelle page doc.pcsoft.fr :
```js
// liste complète des pages d'une version
const raw = await fetch('https://doc.pcsoft.fr/fr-FR/?100&name=plan_site_documentation_soft&verdisp=310',{credentials:'include'}).then(r=>r.text());
// liens : /\?(\d+)&name=([^&"']+)/ sur les <a> ; pages fonction = slug finissant par _fonction
```
Les pages « famille » (`familles_fonctions.tsv`) listent leurs fonctions en `<table>` : TD1 = lien (nom, id, slug), TD2 = description d'une ligne.

## 6. Règle d'usage (rappel des préférences utilisateur)

Le corpus local donne le **nom, l'id, la version et le thème** — pas la signature.
Avant d'affirmer une syntaxe : ouvrir la page exacte (`?<id>&verdisp=<v>`) dans la bonne version.
Sans consultation de la page : marquer [SIGNATURE NON VÉRIFIÉE].
