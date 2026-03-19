# Modules D.L.S dans la Console

La console permet de gérer l'intégralité du cycle de vie des **modules D.L.S** (Domain Logic Script) :
création, édition du code source, compilation, démarrage et supervision en temps réel.

Pour une description complète du langage D.L.S, consultez la section [D.L.S](dls.md).

---

## Liste des modules D.L.S

La page [/dls](https://console.abls-habitat.fr/dls) affiche l'ensemble des modules D.L.S du domaine.

Pour chaque module sont indiqués :

| Colonne | Description |
|---|---|
| **TechID** | Identifiant technique unique du module (ex : `CHAUFFAGE`) |
| **ShortName** | Nom court affiché dans l'interface |
| **Description** | Description libre du module |
| **Synoptique** | Synoptique auquel ce module est rattaché |
| **Package** | Package source contenant le code |
| **Statut** | État de compilation et d'exécution |

---

## Ajouter un module D.L.S

Cliquez sur **Ajouter un DLS** pour créer un nouveau module.

| Champ | Description |
|---|---|
| **TechID** | Identifiant technique unique, en majuscules, sans espaces (max 32 caractères) |
| **ShortName** | Nom court du module |
| **Package source** | Nom du package auquel appartient le module |
| **Description** | Description libre |
| **Synoptique** | Synoptique parent du module |

!!! warning
    Le **TechID** est l'identifiant principal utilisé dans tout le système pour référencer ce module.
    Il ne peut pas être modifié après création.

---

## Éditer le code source

Depuis la liste, cliquez sur l'icône **Éditer le source** pour accéder à l'éditeur de code D.L.S.

L'éditeur ([/dls/source](https://console.abls-habitat.fr/dls/source)) propose :

- Un **éditeur de texte** avec coloration syntaxique (CodeMirror)
- Un bouton **Compiler** : compile le code et affiche les erreurs éventuelles
- Un bouton **Restart** : redémarre le module après modification
- Un bouton **RUN** : accède à la vue d'exécution temps réel du module
- Un bouton **Messages** : accède à l'historique des messages générés par ce module

Le résultat de la compilation s'affiche en bas de l'éditeur : erreurs de syntaxe, avertissements, etc.

---

## Vue d'exécution (RUN)

La page [/dls/run](https://console.abls-habitat.fr/dls/run) affiche l'**état temps réel** d'un module D.L.S en cours d'exécution :

- Valeur instantanée de chaque mnémonique (bits internes, monostables, registres, messages…)
- Statut d'exécution (actif, erreur, arrêté)
- Informations de débogage

---

## Packages D.L.S

Les modules D.L.S peuvent être regroupés en **packages** pour faciliter la réutilisation et le déploiement.

La page [/dls/packages](https://console.abls-habitat.fr/dls/packages) liste les packages disponibles.
Un package peut être associé à plusieurs modules D.L.S d'un même domaine.

---

## Paramètres D.L.S

Certains modules D.L.S exposent des **paramètres configurables** sans qu'il soit nécessaire de modifier le code source.

La page [/dls/params](https://console.abls-habitat.fr/dls/params) permet de consulter et modifier ces paramètres.

---

## Statut global des modules

La page [/dls/status](https://console.abls-habitat.fr/dls/status) présente une vue synthétique de l'état de compilation et d'exécution de l'ensemble des modules D.L.S du domaine.

!!! tip
    En cas d'erreur de compilation, le nombre d'erreurs est affiché sur le tableau de bord.
    Naviguez vers cette page pour identifier rapidement les modules en erreur.
