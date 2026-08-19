# windev — pilotage de WINDEV 28 Express + corpus WLangage vérifié

Dépôt privé dédié. Ce que la tour sait faire sur WinDev, rassemblé ici.

## Ce qui a été fait (07/08/2026, depuis le poste de Patrick)

WINDEV 28 Express a été **piloté comme on pilote un navigateur** : avec
**pywinauto** en **Python 3.12 32 bits** (le 64 bits ne voit pas les contrôles
internes de WinDev, application 32 bits, processus `WDExpress.exe`).

Résultat atteint : un **tableau de bord** construit dans l'éditeur — code écrit
dans la fenêtre de code **et** fenêtre fabriquée à la palette de champs.

## Les deux briques

1. **Le moteur `moteur-windev.sh`** (DeepSeek) : écrit le WLangage, chaque
   fonction **vérifiée au catalogue** des 6 284 fonctions. Il REFUSE d'inventer
   une signature et le dit (`[comblé]`). Une signature WLangage inventée se voit
   à la compilation, chez le client — c'est le défaut que ce moteur existe pour
   tuer.
2. **Le pilotage de l'IDE** (pywinauto) : ouvrir les volets, poser les champs,
   coller le code. La carte des capacités de l'éditeur est dans
   `03-interface-editeur-windev.md`.

   **Sans confisquer la souris de Patrick** : les méthodes pywinauto **sans**
   `_input` parlent à la fenêtre et laissent le poste libre ; celles **avec**
   `_input` bougent le vrai matériel. La boucle écrire → compiler → lire les
   erreurs → corriger tient entièrement sans la souris ; seule la création des
   fenêtres la réclame. Voir `05-piloter-sans-monopoliser-la-souris.md`.

## La méthode validée le 07/08 (six gestes)

1. Le moteur `windev` génère le module de procédures, tout vérifié au corpus.
2. Dans l'IDE : `Ctrl+N → Fenêtre`. La création demande **un clic humain** sur
   *Valide* — l'assistant n'est pas lisible par pywinauto.
3. Poser un champ : clic sur l'outil de la palette, puis clic dans la zone de
   conception.
4. Mettre du code sur un bouton : le sélectionner → **F2** (ouvre son éditeur de
   code) → **Ctrl+V** (coller par le presse-papier : `type_keys` rate les
   accents) → **Ctrl+S**.
5. Adapter le code aux noms par défaut réels : `BTN_…`, `LIB_…`, `SAI_…`,
   `TIM_…` (préfixe + nom de fenêtre + numéro).
6. Tester : **F9**. Les erreurs tombent dans le volet « Erreurs de
   compilation », **F12** = erreur suivante.

## Pièges déjà payés

Tout est dans `01-pieges-windev.md` : pièges du langage WLangage (ex. `SORTIR`
vs `RETOUR`, `HeureSys()` et non `HeureCourante()`) ET pièges de pilotage
(Python 32 bits obligatoire, contrôles `WinDevObject` invisibles, `type_keys`
qui lève `ElementNotEnabled`, coller par presse-papier).

## Contenu

- `01-pieges-windev.md` — pièges tranchés, langage + pilotage.
- `02-index-doc-pcsoft.md` — index de la doc PC SOFT.
- `03-interface-editeur-windev.md` — carte des capacités de l'éditeur (relevée
  à pywinauto le 07/08).
- `corpus-doc-pcsoft/` — le catalogue des fonctions (v25 + v2026), les
  propriétés, les nouveautés et suppressions.
- `moteur-windev.sh` — le moteur de l'atelier (contrat : consigne sur l'entrée,
  compte rendu sur la sortie, code 0 = réussi).

## Ce qui manque encore ici

Le **script `.py` de pilotage** lui-même : il tourne sur le poste Windows de
Patrick (là où est `WDExpress.exe`), pas sur le VPS. À ajouter depuis le poste.

## Pour un agent (opencode, IA agentique)

Commence par **`AGENTS.md`** (chargé automatiquement par opencode) : la règle,
les données, les outils. Puis `00-DEMARRAGE-IA.md` pour le pas-à-pas.

Outils déterministes dans `outils/` :
- `outils/chercher-fonction.sh <nom>` — id + présence v25/v2026 + URL de doc.
- `outils/verifier-fonctions.py <code.wl>` — liste les appels absents du
  catalogue (garde-fou anti-invention).
