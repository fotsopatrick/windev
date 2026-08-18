# Index des pages PC SOFT déjà consultées

Pages de la doc en ligne PC SOFT tirées dans l'historique. **Ne pas se fier à un
résumé : re-fetch la page** avant d'affirmer une signature. Version doc : 2026
(WinDev 31, XXA311075 — à confirmer). Rappel utile : chaque page PC SOFT porte en bas
des liens « Voir Aussi » vers des pages connexes — les suivre pour la doc complémentaire.

| Domaine | Fonction / notion | Ce qui a été confirmé |
|---|---|---|
| Impression | `iInfoImprimante`, `iListeImprimante` | Existent. `iImprimanteParDéfaut()` **n'existe pas** sous cette forme — ne pas l'appeler. |
| Instructions structurées | `FIN :` (étiquette), `RETOUR`, `RENVOYER` | `FIN :` = code exécuté en fin de traitement, y compris sur `RETOUR`/`RENVOYER` (sauf exception `ExceptionDéclenche`). |
| Boucles | `POUR TOUT`, `SORTIR`, `RETOUR` | `SORTIR` sort de la boucle ; `RETOUR` quitte la procédure. `SORTIR` interdit hors boucle. |
| Types / propriétés | Propriété/type `Procédure`, `Description de procédure`, `hTâchePlanifiée` | Page « Procédure (Type de variable) » consultée. |
| Champ Chat IA | Champ Chat IA natif + `<TOOL IA>` | Peut exécuter des actions applicatives via procédures WLangage passées en outils (ouvrir fenêtre, remplir champs, requêter). Nécessite clé API (OpenAI/Anthropic/…). |
| Raccourcis clavier (IDE, page 3085002) | « Les raccourcis clavier » — sommaire complet | **Compilation/test** : `F9` tester l'élément, `Ctrl+F9` tester le projet, `Alt+F9` tracer, `Ctrl+Maj+F9` paramétrer le mode test, `Maj+F5` arrêter le test. **Erreurs** : `F12` erreur suivante, `Maj+F12` précédente, `Ctrl+F12` erreur courante, `Ctrl+P` imprimer les erreurs. **Édition de code** : `Ctrl+D` dupliquer la ligne, `Ctrl+L` supprimer la ligne, `Ctrl+/` commenter, `Ctrl+R` ré-indenter, `Alt+Flèche haut/bas` déplacer une ligne. **Navigation** : `F2` aller dans le code, `Alt+F2` ouvrir l'élément, `Ctrl+F2` revenir à la procédure précédente. **Aide/saisie** : `Ctrl+F1` saisie assistée, `F5` compléter depuis le glossaire, `Maj+F1` assistant de code. Pour piloter l'IDE avec pywinauto : `send_keystrokes("{F9}")` = compiler+tester. |

**À compléter au fil de l'eau** : chaque nouvelle page PC SOFT re-fetchée pour une
correction rejoint ce tableau, avec la version et la date de consultation. C'est le
registre qui évite de redemander une doc déjà obtenue.
