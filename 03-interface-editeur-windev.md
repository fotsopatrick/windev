# Interface de l'editeur WinDev (carte des capacites)

Capture reelle de WINDEV 28 Express, projet FEN_test ouvert, le 07/08/2026,
depuis le poste de Patrick avec pywinauto en Python 32 bits. Cette carte dit
CE QUE PERMET L'EDITEUR : les volets, les actions, les champs disponibles.

## Fenetre principale

- Titre : « WINDEV 28 Express - [FEN_test *] » (le `*` = modifications non
  sauvegardees sur l'element ouvert).
- Classe : « WinDev 28 Exp » — application 32 bits, processus WDExpress.exe.
- Pas de menu standard Win32 (GetMenu vide) : les menus/barres sont des
  controles MFC maison (classes Afx*, WinDevObject). Pour les ouvrir : clic
  ou raccourci clavier, pas l'API menu.
- Pilotage : pywinauto (backend win32) avec un Python 32 BITS (le 64 bits ne
  voit presque rien des controles internes). Le projet courant est
  « C:\Mes projets\MonProjet\MonProjet.wdp » (bouton visible dans l'IDE).

## Volets de l'editeur (panneaux dockables)

- Explorateur de projet — l'arbre du projet (elements, procedures, classes).
- Navigateur de code — navigation dans le code courant.
- Arbre de code — les traitements/evenements de l'element courant.
- Aide syntaxique — l'aide contextuelle pendant la saisie.
- Briques de Code — snippets collables.
- Favoris, Zoom interactif, Modifieur.
- Erreurs de compilation — LE volet des erreurs (F12 = erreur suivante).
- Rechercher - Remplacer — recherche dans le projet / l'element courant.
- Visualisation contextuelle du code.
- Debogueur + Trace du debogueur.
- Exemples unitaires, Resultats des tests, Centre de Controle Qualite.
- Messagerie, Liste des taches, Regles metier, Dictionnaire, Commandes,
  Analyse UML, Catalogue d'images, Documents ouverts, Apercu position fenetres.

## Actions de l'editeur (boutons observes, groupes)

- Fichier : Nouveau, Ouvrir, Enregistrer, Fermer, Imprimer, Fermer tout.
- Edition : Annuler, Retablir, Rejouer, Couper, Copier, Coller, Dupliquer.
- Rechercher : Rechercher, Rechercher - Remplacer, dans l'aide.
- Projet / GDS / Git : Créer une branche, Commit, Push, Pull, Revert,
  Historique, Resoudre les conflits, tout recuperer / reintegrer,
  Fusionner une branche, Importer depuis le GDS.
- Generation : Generer, Recompiler et synchroniser, Configuration courante,
  Nouvelles configurations, Generer la bibliotheque, RAD Application complete,
  Procedure d'installation, Patch, Generer le site (Webiser, Deployer le site),
  Plan de navigation, Referencement, Traduire, Telemtrie, Audit statique,
  Analyser les performances.
- Test / Debogage : Exécuter le test, Executer l'ensemble, Voir les resultats,
  Mode test, Point d'arret, Pas a pas, Pas a pas detaille, Executer jusqu'au
  curseur, Pause, Continuer, Terminer le test, Sortir, Definir l'instruction
  suivante, Mode strict, Ignorer les timers, Ignorer les points d'arret,
  Tracer le projet.
- Styles / interface : Appliquer un style, Copier le style, Charte, Feuille
  de styles, Modeles, Menus (Menu principal, Menus contextuels, Barres).
- Outils systeme WD* : WDInst, WD Diagramme, WDTestSite, WDAdminSaaS,
  WDStatistique, WDDeploie, WDAdmin, WDScript, WDApi, WDZip, WDXView,
  WDFAdmin, WDOutil, WDDiag. Cnx., WDTrans, WDJournal, WDOptimiseur, WDSql,
  WDHFDiff, WDMap, Maintenance de la base, WDBal (messagerie), Suivi de
  Projets, Controle Utilisateur, HFSQL, Replication, Etat des sources de
  donnees, Dump de debogage, Elements du systeme.
- Aide : Tutoriels, Information sur le Web, Aide, Options, Volets, Fenetre.

## Boite a outils de conception de fenetres (champs disponibles)

Champs standard : Bouton, Saisie, Libelle, Combo, Selecteur, Interrupteur,
Image, Images animees, Spin, Potentiometre, Temps, Jauge, Graphe, Notation,
TreeMap, Code-barres, Carte, Video et capture.
Conteneurs : Cellule, Flexbox, Disposition, Tableau de bord, Fenetre interne,
Onglet et associes, Superchamp, Modele de champs, Zone multiligne,
Zone repetee, Table et Liste, Arbre, Separateur, Ascenseur.
Avances : Active X, OLE, Carrousel, Cube, HTML, .Net, XAML, Page WEBDEV,
Conteneur natif, Champs Metier, Note reposi.
Positionnement : Ancrage, Bulle, Mode 9 images, Alignement (gauche/droite/
haut/bas, centrer, meme espacement, meme largeur/hauteur), Agrandir/Aerer,
Arbre positionnement, Grouper la selection.

## Le projet de test FEN_test

La fenetre en cours contient deja les champs : « test », « &Bouton », « met »,
BtnValide, BtnAnnule (boutons de validation). Le champ texte affiche 0,00.
C'est la fenetre ouverte dans l'IDE le jour de la capture — ne pas la confondre
avec un projet reel du client.

## Pilotage automatise (recette pywinauto, Python 32 bits)

- Se connecter : Desktop(backend="win32").window(title_re="WINDEV 28 Express").
- La fenetre repond : set_focus, minimize/restore, clic (click coords).
- Les boutons ont des textes lisibles (BM_GETTEXT) : on peut viser un bouton
  par son texte (« Enregistrer », « Generer »...). Attention aux doublons :
  2 boutons « Enregistrer » et plusieurs « Annuler » — desambiguiser par la
  position ou le volet parent.
- Les volets sont des enfants Afx:00EE0000:b:... et WinDevObject avec un
  libelle (Explorateur de projet, Arbre de code, Erreurs de compilation...).
- Raccourcis cles (doc PC SOFT 3085002) : F9 tester l'element, Ctrl+F9 tester
  le projet, Alt+F9 tracer, F12 erreur suivante, Ctrl+F12 erreur courante,
  Maj+F5 arreter le test, Ctrl+S enregistrer, Ctrl+D dupliquer la ligne,
  Ctrl+L supprimer la ligne, Ctrl+/ commenter, F2 aller dans le code.
- Le volet « Erreurs de compilation » affiche les erreurs : c'est lui qu'il
  faut lire apres un F9 pour la boucle generer -> compiler -> corriger.

## Limites observees

- Python 64 bits : quasi aveugle sur les controles internes. Utiliser le
  32 bits installe sur le poste.
- Les menus de niveau superieur ne s'ouvrent pas par l'API standard : passer
  par les boutons/barres ou les raccourcis clavier documentes.
- Le texte du code dans l'editeur n'est pas lu directement (controle
  proprietaire) : pour verifier, compiler (F9) et lire le volet des erreurs,
  ou lire les fichiers .w du projet.
