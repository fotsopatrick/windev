# Piloter WinDev sans confisquer la souris de Patrick

Problème posé le 19/08/2026 : quand l'agent pilote l'IDE, il prend la souris
et le clavier du poste. Patrick ne peut plus rien faire pendant ce temps —
et un geste humain au mauvais moment casse la séquence.

Ce document dit **pourquoi** c'est ainsi, **ce qui peut** s'en passer, et
**ce qui ne pourra jamais**. Lis-le avant d'écrire un script de pilotage.

---

## 1. La cause, en une phrase

**Windows n'a qu'un seul curseur par session ouverte.**

Les outils habituels (`pyautogui`, `robotgo`, `SendInput`, et `click_input()`
de pywinauto) ne cliquent pas *sur un bouton* : ils **déplacent le vrai
curseur** puis appuient sur le vrai bouton de la souris. Le système ne voit
aucune différence avec la main de Patrick. Deux mains sur une seule souris :
il n'y a pas de réglage qui répare ça, c'est la forme même de l'outil.

Pour comparaison — l'extension qui pilote le navigateur Chrome **ne touche
jamais la souris** : elle envoie l'événement *à l'intérieur* de l'onglet, par
le canal de mise au point du navigateur. Le curseur ne bouge pas, le focus ne
change pas, on peut travailler ailleurs pendant ce temps. WinDev n'a pas de
canal équivalent — mais une partie de son interface peut être atteinte
autrement, et c'est là-dessus qu'on joue. [établi pour Chrome, dérivé pour la
suite]

---

## 2. Voie 1 — parler à la fenêtre, pas à l'écran

On demande au contrôle d'agir **lui-même**, au lieu de viser des pixels.
Aucun curseur ne bouge, aucun focus n'est volé.

Deux dialectes, à essayer dans cet ordre :

| Dialecte | Ce que ça fait | En pywinauto |
|---|---|---|
| Messages Win32 | `BM_CLICK` appuie le bouton, `WM_SETTEXT` écrit dans un champ | backend `win32` : `.click()`, `.set_text()`, `.set_edit_text()` |
| UI Automation | `InvokePattern` déclenche, `ValuePattern` remplit | backend `uia` : `.invoke()`, `.set_text()` |

**La règle qui décide de tout :**

> Les méthodes **sans** `_input` parlent à la fenêtre. Les méthodes **avec**
> `_input` passent par le vrai matériel.

    bouton.click()          # parle a la fenetre — la souris reste libre
    bouton.click_input()    # bouge la VRAIE souris — confisque le poste

    champ.set_text("x")     # ecrit dans le controle — clavier libre
    champ.type_keys("x")    # tape sur le VRAI clavier — confisque le poste

Une seule ligne fautive suffit à reprendre le poste. Quand un script mélange
les deux, il se comporte bien pendant vingt gestes puis vole la souris au
vingt-et-unième : cherche d'abord les `_input` avant de chercher ailleurs.

### Ce qui répond à cette voie dans WinDev [établi, relevé dans ce dépôt]

Les contrôles Windows classiques, déjà repérés par la carte de l'éditeur
(`03-interface-editeur-windev.md`) : `Button`, `Edit`, `Static`, `ComboBox`,
`ListBox`. Leur texte se lit (`window_text`, `BM_GETTEXT`), donc on peut les
viser par leur nom — en désambiguïsant les doublons (deux « Enregistrer »,
plusieurs « Annuler ») par le volet parent ou la position.

### Ce qui n'y répondra jamais [établi, payé le 07/08]

- Les contrôles **`WinDevObject`** : ni texte, ni nom, ni arbre accessible.
  WinDev les dessine lui-même ; pour Windows ce sont des rectangles peints.
- La **zone de conception** des fenêtres (`Afx:00EE0000:b:…`) : y poser un
  champ demande de cliquer sur l'outil de la palette puis dans la zone.
- Les **assistants** (Ctrl+N → Fenêtre → Valide) : champs propriétaires
  illisibles.
- Les **menus de niveau supérieur** : `GetMenu` rend vide, `Alt+lettre`
  n'ouvre rien.

Ce n'est pas un manque d'astuce : il n'y a rien à qui parler. Aucune
bibliothèque ne changera ça.

### Le contournement qui évite le plus de clics

**Les raccourcis clavier.** `send_keystrokes` / `type_keys` envoient au
clavier — donc ils prennent le focus — mais ils ne demandent **pas** la
souris, et un raccourci remplace souvent une longue promenade dans les menus
inaccessibles : `F9` teste, `F12` erreur suivante, `Ctrl+S` enregistre, `F2`
ouvre le code de l'élément sélectionné (liste complète dans
`02-index-doc-pcsoft.md`, page PC SOFT 3085002).

C'est un demi-gain, à dire clairement : le clavier est pris pendant l'envoi,
la souris non. Sur un poste où Patrick lit un document, c'est déjà vivable ;
pendant qu'il tape, non.

---

## 3. Voie 2 — donner à l'agent son propre bureau

Pour tout ce que la voie 1 ne peut pas atteindre — c'est-à-dire **la
conception de fenêtres**, la partie la plus visuelle du travail — il faut du
clic à coordonnées. Alors la seule sortie honnête est que ces clics aient
lieu **ailleurs que sur le bureau de Patrick**.

Trois formes, de la plus légère à la plus sûre :

1. **Un deuxième compte Windows** sur la même machine, avec sa propre session
   ouverte. Chaque session a son curseur. [à vérifier : selon l'édition de
   Windows, deux sessions interactives simultanées ne sont pas toujours
   permises]
2. **Une machine virtuelle** avec WinDev installé. C'est la voie qui marche à
   tous les coups, au prix d'une licence et de mémoire vive.
3. **Une deuxième machine** physique, pilotée par le réseau.

Dans tous les cas la règle est la même : **l'agent monopolise une souris,
mais pas celle de Patrick.** On n'a pas supprimé le problème — on l'a déplacé
là où il ne coûte rien.

> Piège nommé : ne pas piloter par un bureau à distance qu'on **regarde** en
> même temps. Réduire la fenêtre du bureau distant ou verrouiller la session
> distante gèle souvent les contrôles, et le script échoue sans raison
> visible. La session pilotée doit rester ouverte et déverrouillée.
> [dérivé — à confirmer sur le poste]

---

## 4. Quel geste, quelle voie

| Geste | Voie | Souris de Patrick |
|---|---|---|
| Lire les erreurs de compilation | 1 — lire le volet | libre |
| Cliquer « Enregistrer », « Générer » | 1 — `.click()` | libre |
| Remplir un champ de saisie standard | 1 — `.set_text()` | libre |
| Compiler et tester (`F9`) | raccourci | libre, clavier pris |
| Ouvrir le code d'un élément (`F2`) | raccourci | libre, clavier pris |
| Coller du code (presse-papier + `Ctrl+V`) | raccourci | libre, clavier pris |
| **Poser un champ dans la fenêtre** | **2** | **prise** |
| **Passer un assistant** | **2** | **prise** |
| **Ouvrir un menu du haut** | **2** | **prise** |

Lis ce tableau à l'envers : **la boucle « écrire du code → compiler → lire
les erreurs → corriger » tient entièrement dans la voie 1 et les
raccourcis.** C'est la boucle qui tourne cent fois par jour. Seule la
création initiale des fenêtres réclame la voie 2 — une fois, au début.

Donc la bonne façon de travailler : **Patrick crée la coquille de la fenêtre
à la main** (c'est déjà ce qui s'est passé le 07/08), et l'agent vit ensuite
dans la voie 1, sans jamais lui reprendre la souris.

---

## 5. Le contrôle à lancer avant de croire ce document

Sur le poste, WinDev ouvert, avec le **Python 32 bits** (le 64 bits est
quasi aveugle sur ces contrôles — voir `01-pieges-windev.md`) :

```python
from pywinauto import Desktop

for backend in ("win32", "uia"):
    f = Desktop(backend=backend).window(title_re=".*WINDEV.*")
    print("=" * 20, backend)
    f.print_control_identifiers(depth=3)
```

Comment lire le résultat :

- Des `Button`, `Edit`, `ComboBox` **avec leur texte** → voie 1 pour eux.
- Uniquement des `WinDevObject` et des `Afx:…` sans texte → voie 2, et
  aucune bibliothèque n'y changera rien.
- Le backend `uia` montre parfois des contrôles que `win32` rate (et
  l'inverse) : **essaie les deux avant de conclure**, c'est gratuit.

Puis, pour prouver que la souris reste libre — **le seul essai qui compte** :

```python
b = f.child_window(title="Enregistrer", control_type="Button")
b.click()            # PAS click_input()
```

Bouge ta souris pendant l'appel. Si ton curseur ne saute pas et que le bouton
répond, la voie 1 est ouverte sur ce poste. C'est vérifié, plus supposé.

---

## 6. Ce qui reste ouvert

- Deux sessions Windows interactives en même temps : permis ou non selon
  l'édition installée. **Non vérifié sur le poste.**
- Le backend `uia` sur WinDev : jamais essayé ici. Tout le dépôt parle du
  backend `win32`. Il peut ne rien apporter — mais l'essai coûte deux minutes.
- WinDev sait exposer des services web. Piloter l'**application** par une API
  plutôt que son **interface** supprimerait la question entière. Piste non
  explorée, la plus prometteuse à long terme. [comblé — à instruire]
