# Pièges WinDev déjà rencontrés et tranchés

Toute découverte qui a coûté du temps ou une erreur s'ajoute ici. Un piège
écrit est un piège payé une seule fois. À lire AVANT d'écrire la moindre ligne
de WLangage et AVANT de piloter l'IDE.

## 1. Pièges de langage WLangage

- **SORTIR** quitte la boucle, **RETOUR** quitte la procédure. `SORTIR` est
  interdit hors boucle (erreur de compilation).
- **La propriété `..Mois` d'une date n'accepte pas de valeur négative** : faire
  le report en arithmétique entière, jamais par soustraction directe.
- **Une source de données reçue d'une grille contient les valeurs AVANT
  sauvegarde** : relire en base avant de mapper vers une API.
- **`iImprimanteParDéfaut()` n'existe pas** : c'est `iInfoImprimante(Faux)` qui
  renvoie l'imprimante par défaut ; `iListeImprimante` est au singulier.
- **`HeureCourante()` n'existe pas** (vérifié au catalogue le 07/08) : la
  fonction native est **`HeureSys()`** (id 3027019, v25+v2026), assignable à
  une variable de type Heure. Pour afficher l'heure formatée avec zéros de
  tête : **`HeureVersChaîne(HeureSys(), "HH:MM:SS")`** (id 3027023).
- **Ne jamais inventer une signature WLangage** : une syntaxe « plausible » se
  voit à la compilation, chez le client. Toute fonction doit être cherchée
  dans le catalogue (catalogue_fonctions.tsv), toute propriété dans
  proprietes_types.tsv. Marquer [établi] / [dérivé] / [comblé].

## 2. Pièges de pilotage de l'IDE (pywinauto, poste de Patrick)

- **Python 32 bits OBLIGATOIRE** pour piloter WinDev (application 32 bits,
  processus WDExpress.exe). Avec un Python 64 bits, presque tous les contrôles
  internes sont invisibles. Le poste a un Python 3.12 32 bits dédié avec
  pywinauto 0.6.9 + pillow.
- **Pas de menu standard** : `GetMenu(hwnd)` renvoie vide, `Alt+lettre`
  n'ouvre pas les menus. Les barres sont des contrôles MFC maison (classes
  Afx*, WinDevObject) sans texte ni nom accessibles. Ne pas compter dessus
  pour automatiser les menus.
- **Les contrôles `WinDevObject` ne s'exposent pas** : pas de texte, pas de
  nom, pas d'arbre accessible. Ce qu'on lit, ce sont les `Button`, `Edit`,
  `Static`, `ComboBox`, `ListBox` classiques (texte via window_text /
  BM_GETTEXT) et les rectangles.
- **L'assistant « Nouvelle fenêtre »** (Ctrl+N → Fenêtre → Valide) est une
  boîte aux champs propriétaires illisibles : on ne peut pas taper le nom de
  la fenêtre ni choisir le gabarit à l'aveugle de façon fiable. Créer la
  fenêtre demande un coup de main humain ou du clic à coordonnées.
- **Après création, les champs posés portent des noms par défaut** selon le
  schéma `PRÉFIXE + nom de fenêtre + numéro` : BTN_SansNom1, BTN_SansNom2
  (boutons), LIB_SansNom1, LIB_SansNom2 (libellés), SAI_SansNom1 (saisie),
  TIM_… (timer). On peut adapter le code à ces noms au lieu de renommer.
- **Poser un champ dans la zone de conception** : cliquer sur l'outil de la
  palette (barre de conception, ex. « Bouton ») puis cliquer dans la zone.
  La zone de conception est l'enfant `Afx:00EE0000:b:…` portant le nom de la
  fenêtre (ex. « FEN_SansNom1 * »), pas le WinDevObject du titre.
- **F2 sur un élément sélectionné ouvre son éditeur de code** (l'événement
  par défaut, ex. « Clic sur BTN_SansNom1 »). C'est LA porte d'entrée pour
  mettre du code : sélectionner le champ (clic dans la zone), F2, coller.
- **Coller le code via le presse-papier (Ctrl+V)** : `type_keys` ne tape pas
  fi fiablement les accents (ê, â) et certains symboles. Mettre le code dans
  le presse-papier (Set-Clipboard) puis Ctrl+V.
- **`type_keys` peut lever `ElementNotEnabled`** sur la fenêtre WinDev quand
  l'éditeur de code est actif : la fenêtre se déclare non « enabled ». Ne pas
  bloquer là-dessus ; relancer un set_focus, ou passer par un envoi global de
  touches, ou faire le geste par clic.
- **Le code collé est visible dans l'éditeur** : pour vérifier ce qui est
  écrit, essayer Ctrl+A puis Ctrl+C puis lire le presse-papier ; si le focus
  est perdu (presse-papier vide), relire plutôt le fichier `.wdw` enregistré.

## 3. Méthode validée le 07/08 (dashboard dans WinDev Express)

1. Le moteur `windev` (DeepSeek) génère un module `.w` de procédures, chaque
   fonction vérifiée au corpus ; il REFUSE d'inventer et le dit ([comblé]).
2. Dans l'IDE : Ctrl+N → Fenêtre (la création de la fenêtre a demandé un clic
   humain sur Valide — l'assistant n'est pas lisible par pywinauto).
3. Poser les champs : clic outil de palette puis clic dans la zone de
   conception.
4. Pour chaque bouton : clic dessus → F2 → coller le code de l'événement
   (Ctrl+V) → Ctrl+S.
5. Adapter les noms de champs du code aux noms par défaut réels (BTN_/LIB_/
   SAI_ + fenêtre + numéro).
6. Tester : F9 (tester l'élément) — les erreurs tombent dans le volet
   « Erreurs de compilation » (F12 = erreur suivante).
