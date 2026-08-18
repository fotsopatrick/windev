# Tester en WinDev 25

But de ce document : donner à une IA (ou un humain) de quoi **écrire et lancer
des tests** en WinDev 25 **sans inventer une seule fonction**. Toutes les
fonctions citées ici sont **présentes dans le catalogue v25**
(`corpus-doc-pcsoft/catalogue_fonctions_v25.tsv`), avec leur `id`. La signature
exacte (paramètres, valeur de retour) se lit sur la page de doc :
`https://doc.pcsoft.fr/fr-FR/?<id>&verdisp=250` (250 = version 25).

> Règle d'or du dépôt : le catalogue donne le **nom + id + version**, jamais la
> signature. Avant d'écrire l'appel exact, **ouvrir la page `?<id>&verdisp=250`**.
> Tant que la page n'est pas lue, marquer `[signature à confirmer]`.

## 1. Les trois façons de tester en WinDev 25

1. **Assertions dans le code courant** — famille `dbg*` (thème « gestion du
   débogage »). On sème des vérifications dans le code ; elles ne parlent qu'en
   mode test/débogage et se taisent dans l'application livrée.
2. **Tests automatiques** — famille `Test*` (thème « Test »). Un test
   automatique est un **scénario** (du code WLangage) rangé dans le projet, qui
   pilote l'application et vérifie les résultats. Il se crée dans l'éditeur et
   se lance depuis le **Centre de Contrôle Qualité**.
3. **Le lancement direct** — `F9` teste l'élément courant (la fenêtre),
   `Ctrl+F9` teste le projet entier, `Maj+F5` arrête le test. Le débogueur
   (points d'arrêt, pas à pas) sert à observer.

## 2. Assertions dans le code — famille `dbg*` (v25)

| Fonction | id (page `?<id>&verdisp=250`) | Ce qu'elle fait |
|---|---|---|
| `dbgAssertion` | 3014022 | Vérifie qu'une condition est vraie ; sinon, signale en mode test. |
| `dbgActiveAssertion` | 3014021 | Active / désactive la prise en compte des assertions. |
| `dbgVérifieEgalité` | 1000019776 | Vérifie que deux valeurs sont égales. |
| `dbgVérifieDifférence` | 1000019777 | Vérifie que deux valeurs diffèrent. |
| `dbgVérifieVrai` | 1000019780 | Vérifie qu'une expression est vraie. |
| `dbgVérifieFaux` | 1000019781 | Vérifie qu'une expression est fausse. |
| `dbgVérifieNull` | 1000019778 | Vérifie qu'une valeur est Null. |
| `dbgVérifieNonNull` | 1000019779 | Vérifie qu'une valeur n'est pas Null. |
| `dbgSurErreur` | 1000020722 | Branche un traitement sur erreur de débogage. |
| `dbgErreur` | 1000020526 | Provoque/signale une erreur de débogage. |
| `dbgInfo` | 3014024 | Écrit une information de trace. |

Autres de la même famille utiles : `dbgActiveAudit` (1000018835),
`dbgEtatAudit` (1000018836), `dbgActiveLog` (1000017137),
`dbgSauveDumpDébogage` (1000018834).

Forme attendue (à confirmer sur la page) :

```wlangage
// [signature à confirmer sur ?3014022&verdisp=250]
dbgAssertion(nSolde >= 0, "Le solde ne doit jamais être négatif")
// [signature à confirmer sur ?1000019776&verdisp=250]
dbgVérifieEgalité(Résultat, 42, "Le calcul doit rendre 42")
```

## 3. Tests automatiques — famille `Test*` (v25)

Fonctions à utiliser **dans un scénario de test** (thème « Test ») :

| Fonction | id | Ce qu'elle fait |
|---|---|---|
| `TestVérifie` | 1000017023 | Vérifie une condition dans un test automatique. |
| `TestVérifieEgalité` | 1000023398 | Vérifie l'égalité de deux valeurs. |
| `TestVérifieDifférence` | 1000023397 | Vérifie que deux valeurs diffèrent. |
| `TestVérifieVrai` | 1000023402 | Vérifie qu'une expression est vraie. |
| `TestVérifieFaux` | 1000023399 | Vérifie qu'une expression est fausse. |
| `TestVérifieNull` | 1000023401 | Vérifie qu'une valeur est Null. |
| `TestVérifieNonNull` | 1000023400 | Vérifie qu'une valeur n'est pas Null. |
| `TestEcritRésultat` | 1000013001 | Écrit un résultat dans le compte rendu du test. |
| `TestAjouteItération` | 1000017015 | Ajoute une itération (test rejoué sur plusieurs jeux de données). |
| `TestErreur` | 1000023506 | Signale une erreur dans le test. |
| `TestSurErreur` | 1000023507 | Branche un traitement sur erreur de test. |

Savoir si on tourne sous test : `EnModeTestAutomatique` (id 3014027).

Forme attendue d'un test de procédure (à confirmer sur les pages) :

```wlangage
// Test automatique de la procédure CalculeTVA
// [signatures à confirmer : ?1000023398 et ?1000013001, verdisp=250]
PROCEDURE test_CalculeTVA()
nHT est un réel = 100
nAttendu est un réel = 120  // TVA 20 %
TestVérifieEgalité(CalculeTVA(nHT), nAttendu, "TVA 20 % sur 100 = 120")
TestEcritRésultat("CalculeTVA : OK")
```

## 4. Créer et lancer un test dans l'éditeur (v25)

1. **Créer un test unitaire** : clic droit sur une procédure ou une classe →
   l'assistant propose de créer son **test automatique**. WinDev génère le
   squelette du scénario ; on le remplit avec les `TestVérifie*`.
2. **Créer un test d'interface** : on **enregistre** un scénario (les clics et
   saisies dans l'application), puis on ajoute des `TestVérifie*` aux endroits
   clés.
3. **Lancer** : le volet **Centre de Contrôle Qualité** (ou « Résultats des
   tests ») liste les tests ; on les exécute et on lit le vert/rouge.
4. **Raccourcis** (voir `02-index-doc-pcsoft.md`) : `F9` tester la fenêtre,
   `Ctrl+F9` tester le projet, `Ctrl+Maj+F9` paramétrer le mode test,
   `Maj+F5` arrêter, `F12` erreur de compilation suivante.

## 5. Quand piloter l'éditeur (pywinauto), le test se pose comme le code

La méthode du dépôt (voir `01-pieges-windev.md` et
`03-interface-editeur-windev.md`) : sélectionner l'élément → `F2` ouvre son
code → coller par presse-papier (`Ctrl+V`) → `Ctrl+S`. Le code d'un **test
automatique** se colle de la même façon dans l'éditeur de l'élément « test ».
Puis `F9` pour lancer, et lire le volet des résultats.

## 6. Récapitulatif de la discipline

- Une vérification = une fonction `Test*` (dans un scénario) ou `dbg*` (dans le
  code courant). **Jamais une fonction inventée.**
- Chaque fonction : nom trouvé au catalogue v25, signature lue sur
  `?<id>&verdisp=250` avant d'écrire l'appel.
- Le résultat d'un test se lit **à l'exécution** (volet Résultats), pas en
  relisant le code : un test vert prouve, un test qu'on n'a pas lancé ne prouve
  rien.
