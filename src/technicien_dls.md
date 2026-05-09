# Étape 3 — Créer et coder les modules D.L.S

Le **D.L.S** (Domain Logic Script) est le langage de programmation d'Abls-Habitat.
Chaque module D.L.S contient la logique d'automatisation d'une zone ou d'une fonction du domaine.
Il est écrit dans l'éditeur intégré à la console, compilé, puis exécuté en temps réel par le moteur.

!!! info "Position dans le workflow"
    Cette étape peut être réalisée avant ou après le mapping I/O, selon votre approche.
    → Étape précédente : [Configurer les threads](technicien_threads.md)
    → Étape suivante : [Configurer le mapping I/O ↔ D.L.S](technicien_mapping.md)

---

## 1. Accéder à la liste des modules D.L.S

Depuis la console, accédez à la page [/dls](https://console.abls-habitat.fr/dls).

La liste affiche tous les modules D.L.S du domaine avec leur état de compilation et d'exécution.

| Colonne | Description |
|---|---|
| **TechID** | Identifiant technique unique du module |
| **ShortName** | Nom court affiché dans l'interface |
| **Description** | Description libre du module |
| **Synoptique** | Page de visualisation associée |
| **Package** | Groupe logique de modules |
| **Statut** | Compilation OK / Erreur / Arrêté |

---

## 2. Créer un nouveau module D.L.S

### Étape 2.1 — Ouvrir le formulaire

Cliquez sur le bouton **Ajouter un DLS** en haut de la liste.

### Étape 2.2 — Renseigner le formulaire

| Champ | Description | Exemple |
|---|---|---|
| **TechID** | Identifiant unique, en MAJUSCULES, sans espaces (max 32 caractères) | `CHAUFFAGE_RDC` |
| **ShortName** | Nom court affiché dans l'interface | `Chauffage RDC` |
| **Package source** | Nom du package regroupant ce module | `chauffage` |
| **Description** | Description libre | `Gestion du chauffage du rez-de-chaussée` |
| **Synoptique** | Synoptique parent auquel ce module est rattaché | `plan_rdc` |

!!! warning "Le TechID est définitif"
    Le **TechID** identifie le module dans tout le système. Il ne peut pas être modifié après création.
    Choisissez-le avec soin, en utilisant une convention de nommage cohérente (ex : `<FONCTION>_<ZONE>`).

Cliquez sur **Valider** pour créer le module.

---

## 3. Écrire le code D.L.S

### Étape 3.1 — Ouvrir l'éditeur de source

Depuis la liste des modules, cliquez sur l'icône **Éditer le source** (icône crayon) du module souhaité.
Vous accédez à l'éditeur [/dls/source](https://console.abls-habitat.fr/dls/source).

### Étape 3.2 — Comprendre la structure d'un module D.L.S

Un module D.L.S est composé de blocs logiques décrivant des automatismes. Exemple minimal :

```dls
/* Module : Chauffage RDC */

/* Déclaration des mnémoniques */
- Tempo:CHAUFFAGE_RDC:TEMPO_ARRET:         "Tempo arrêt chauffage":       60;
- Bistable:CHAUFFAGE_RDC:CMD_CHAUFFE:      "Commande chauffage";
- Sortie_TOR:CHAUFFAGE_RDC:SORTIE_CHAUFFE: "Sortie relais chauffage";

/* Logique */
SORTIE_CHAUFFE = CMD_CHAUFFE and not SYS:MAINTENANCE;
```

Consultez la [documentation complète du D.L.S](dls.md) pour la syntaxe détaillée.

### Étape 3.3 — Conseils d'écriture

- Déclarez en tête du module **tous les mnémoniques** que vous allez utiliser (bistables, monostables, tempos, entrées, sorties, registres…)
- Donnez des **noms explicites** aux mnémoniques : ils seront visibles dans la console et les synoptiques
- Utilisez des **commentaires** (`/* ... */`) pour documenter la logique

!!! tip "Mnémoniques automatiquement créés"
    Lors de la compilation, tous les mnémoniques déclarés dans le code sont automatiquement créés en base.
    Ils apparaissent ensuite dans la page [/mnemos](https://console.abls-habitat.fr/mnemos).

---

## 4. Compiler le module

### Étape 4.1 — Lancer la compilation

Depuis l'éditeur, cliquez sur le bouton **Compiler**.

Le résultat de la compilation s'affiche en bas de l'éditeur :
- **Compilation OK** : le code est syntaxiquement correct
- **Erreurs** : les lignes en erreur sont indiquées avec le message d'erreur correspondant

### Étape 4.2 — Corriger les erreurs

Lisez attentivement les messages d'erreur. Les erreurs courantes sont :

| Erreur | Cause probable |
|---|---|
| `Mnémonique inconnu` | Mnémonique utilisé mais non déclaré en tête |
| `Syntaxe incorrecte` | Faute de frappe ou opérateur manquant |
| `TechID non trouvé` | Référence à un module ou thread inexistant |

Corrigez le code et recompilez jusqu'à obtenir une compilation sans erreur.

---

## 5. Démarrer et superviser le module

### Étape 5.1 — Redémarrer le module

Après une modification et recompilation réussies, cliquez sur **Restart** dans l'éditeur.
Le module recharge son code compilé et reprend l'exécution.

### Étape 5.2 — Activer / désactiver depuis la liste

Depuis la liste [/dls](https://console.abls-habitat.fr/dls), vous pouvez :

- Cliquer sur **Activer** pour démarrer un module arrêté
- Cliquer sur **Désactiver** pour arrêter un module sans le supprimer

### Étape 5.3 — Vue d'exécution temps réel (RUN)

Cliquez sur le bouton **RUN** dans l'éditeur (ou depuis la liste) pour accéder à la page [/dls/run](https://console.abls-habitat.fr/dls/run).

Cette vue affiche en temps réel :
- La **valeur instantanée** de chaque mnémonique du module
- Le **statut de calcul** (actif, erreur, arrêté)
- Les **compteurs** de cycles d'exécution

!!! tip "Utiliser la vue RUN pour debugger"
    La vue RUN est votre outil principal pour vérifier que la logique fonctionne comme attendu.
    Observez les valeurs des mnémoniques pendant que vous agissez sur les entrées physiques.

---

## 6. Compiler tous les modules d'un coup

Depuis la liste [/dls](https://console.abls-habitat.fr/dls), un bouton **Tout compiler** permet de recompiler l'ensemble des modules du domaine.
Utilisez-le après une modification affectant plusieurs modules (changement d'un mnémonique partagé, mise à jour d'un package…).

---

## 7. Gérer les packages D.L.S

Les **packages** regroupent logiquement plusieurs modules D.L.S.
Depuis la page [/dls/packages](https://console.abls-habitat.fr/dls/packages), vous pouvez :
- Lister les packages existants
- Associer un package à plusieurs modules
- Synchroniser un package depuis un dépôt Git (si un repository est configuré dans le domaine)

---

## 8. Gérer les paramètres D.L.S

La page [/dls/params](https://console.abls-habitat.fr/dls/params) permet de définir des **paramètres** (constantes configurables) utilisables dans les modules D.L.S.

Ces paramètres permettent de rendre le code D.L.S configurable sans avoir à le modifier directement.

Exemple : un seuil de température, une durée de tempo paramétrée depuis l'interface.

---

## Résumé des actions

```
1. Aller sur /dls et cliquer sur "Ajouter un DLS"
2. Renseigner TechID, ShortName, Package, Description, Synoptique
3. Ouvrir l'éditeur et écrire le code D.L.S
4. Compiler → corriger les erreurs → recompiler
5. Cliquer sur Restart pour prendre en compte le nouveau code
6. Vérifier l'exécution dans la vue RUN
7. → Passer à l'étape suivante : mapping I/O ↔ D.L.S
```

**Page suivante : [Configurer le mapping I/O ↔ D.L.S](technicien_mapping.md)**
