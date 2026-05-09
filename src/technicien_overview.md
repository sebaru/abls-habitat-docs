# Guide du Technicien — Vue d'ensemble

Ce guide s'adresse aux **techniciens** en charge de l'installation, de la configuration et de la mise en service d'un domaine Abls-Habitat.
Il présente le workflow complet de mise en œuvre, de la première connexion jusqu'à la supervision en temps réel.

---

## Prérequis

Avant de commencer, assurez-vous de disposer de :

- Un compte Abls-Habitat avec un **niveau d'habilitation ≥ 6** sur le domaine concerné
- Un ou plusieurs **serveurs** (physiques, VM ou Raspberry Pi) sur lesquels déployer les agents
- Les équipements physiques à connecter (automates Wago, modules GPIO, Phidget, etc.)
- L'accès à la [Console Abls-Habitat](https://console.abls-habitat.fr)

!!! tip "Niveau minimum requis"
    Un technicien doit avoir au minimum le **niveau 6** pour accéder aux fonctions de configuration.
    Demandez à l'administrateur du domaine (niveau 9) de vous attribuer ce niveau.

---

## Le workflow global

La mise en service d'un domaine suit un enchaînement logique en **7 étapes** :

```
Étape 1 : Ajouter un agent
     ↓
Étape 2 : Configurer un connecteur (thread)
     ↓
Étape 3 : Créer les modules D.L.S
     ↓
Étape 4 : Écrire et compiler le code D.L.S
     ↓
Étape 5 : Configurer le mapping I/O ↔ D.L.S
     ↓
Étape 6 : Créer les synoptiques
     ↓
Étape 7 : Peupler les synoptiques dans l'atelier
```

Chaque étape est détaillée dans une page dédiée. Suivez l'ordre recommandé pour une mise en service sans accroc.

---

## Vue d'ensemble des pages du guide

| Étape | Page | Description |
|---|---|---|
| 1 | [Ajouter un agent](technicien_agents.md) | Déployer et lier un agent au domaine |
| 2 | [Configurer les threads](technicien_threads.md) | Créer et activer les connecteurs matériels |
| 3–4 | [Modules D.L.S](technicien_dls.md) | Créer, coder, compiler et tester les modules D.L.S |
| 5 | [Mapping I/O ↔ D.L.S](technicien_mapping.md) | Relier les E/S physiques aux mnémoniques D.L.S |
| 6 | [Synoptiques](technicien_synoptiques.md) | Créer la structure des pages de visualisation |
| 7 | [Atelier graphique](technicien_atelier.md) | Placer les visuels sur les synoptiques |
| — | [Mnémoniques](technicien_mnemos.md) | Consulter et gérer les variables du domaine |

---

## Concepts clés à retenir

### Agent
Un **agent** est un processus logiciel (`Watchdogd`) qui s'exécute sur un serveur et communique avec l'API centrale.
Il porte les **threads** (connecteurs) qui dialoguent avec les équipements physiques.

### Thread (Connecteur)
Un **thread** est une instance de connecteur au sein d'un agent. Il peut s'agir d'une connexion Modbus, d'un GPIO Raspberry Pi, d'un module audio, d'une interface SMS, etc.
Chaque thread est identifié par un **Tech_ID** unique.

### Module D.L.S
Un **module D.L.S** (Domain Logic Script) contient la logique d'automatisation du domaine.
Il est écrit dans le langage D.L.S, compilé et exécuté en temps réel par le moteur.

### Mnémonique
Un **mnémonique** est une variable interne du domaine (bit interne, entrée, sortie, registre, compteur…).
Les mnémoniques sont créés automatiquement lors de la compilation du code D.L.S et du mapping des E/S.

### Synoptique
Un **synoptique** est une page de visualisation graphique permettant à l'utilisateur de voir et d'interagir avec l'état du domaine.

---

## Accéder à la console

Rendez-vous sur [https://console.abls-habitat.fr](https://console.abls-habitat.fr), connectez-vous et sélectionnez votre domaine.

!!! note "Sélection du domaine"
    Après connexion, la page [/domains](https://console.abls-habitat.fr/domains) vous invite à choisir le domaine sur lequel travailler.
    Toutes les actions portent sur le **domaine actif** sélectionné.

---

## Aide-mémoire rapide

| Action | Chemin dans la console |
|---|---|
| Lister les agents | [/agents](https://console.abls-habitat.fr/agents) |
| Ajouter un agent | [/agent/add](https://console.abls-habitat.fr/agent/add) |
| Lister les threads | [/threads](https://console.abls-habitat.fr/threads) |
| Configurer les connecteurs | [/io/config](https://console.abls-habitat.fr/io/config) |
| Lister les modules D.L.S | [/dls](https://console.abls-habitat.fr/dls) |
| Éditer le code D.L.S | [/dls/source](https://console.abls-habitat.fr/dls/source) |
| Vue temps réel D.L.S | [/dls/run](https://console.abls-habitat.fr/dls/run) |
| Mnémoniques | [/mnemos](https://console.abls-habitat.fr/mnemos) |
| Synoptiques | [/synoptiques](https://console.abls-habitat.fr/synoptiques) |
| Atelier graphique | [/atelier](https://console.abls-habitat.fr/atelier) |
| Tableau de bord | [/dashboard](https://console.abls-habitat.fr/dashboard) |
