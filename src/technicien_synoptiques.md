# Étape 5 — Créer et organiser les synoptiques

Les **synoptiques** sont les pages de visualisation graphique d'Abls-Habitat.
Ils permettent à l'utilisateur final de visualiser l'état du domaine et d'interagir avec les équipements (commander des sorties, visualiser des capteurs…).

Un synoptique est d'abord créé comme une **page** (une entrée dans la liste), puis son contenu graphique est défini dans l'[atelier](technicien_atelier.md).

!!! info "Position dans le workflow"
    Les synoptiques sont créés **après** que les modules D.L.S existent et sont compilés.
    Leur contenu graphique est défini à l'étape suivante dans l'atelier.
    → Étape précédente : [Configurer le mapping I/O ↔ D.L.S](technicien_mapping.md)
    → Étape suivante : [Peupler les synoptiques dans l'atelier](technicien_atelier.md)

---

## 1. Accéder à la liste des synoptiques

Depuis la console, accédez à la page [/synoptiques](https://console.abls-habitat.fr/synoptiques).

La liste affiche tous les synoptiques du domaine avec leurs propriétés :

| Colonne | Description |
|---|---|
| **Page** | Identifiant interne (utilisé dans les URL) |
| **Libellé** | Titre affiché à l'utilisateur |
| **Parent** | Synoptique hiérarchiquement supérieur |
| **Niveau d'accès** | Niveau d'habilitation requis pour le voir |
| **Mode** | *Simple* ou *Full* |

---

## 2. Concevoir l'arborescence des synoptiques

Avant de créer les synoptiques, réfléchissez à leur **organisation hiérarchique**.
Une bonne arborescence suit la structure physique ou fonctionnelle de l'installation.

### Exemple d'arborescence pour une maison

```
accueil (page racine)
├── plan_rdc          (Plan du rez-de-chaussée)
│   ├── salon         (Détail du salon)
│   └── cuisine       (Détail de la cuisine)
├── plan_etage        (Plan du premier étage)
│   ├── chambre1      (Détail chambre 1)
│   └── chambre2      (Détail chambre 2)
└── technique         (Vue technique)
    ├── chauffage      (Supervision chauffage)
    └── electricite    (Supervision électrique)
```

!!! tip "Un synoptique par zone"
    Créez un synoptique par zone fonctionnelle ou physique.
    Les synoptiques enfants permettent de "zoomer" depuis une vue générale vers une vue détaillée.

---

## 3. Créer un synoptique

### Étape 3.1 — Ouvrir le formulaire

Cliquez sur le bouton **Ajouter un Synoptique** en haut de la liste.

### Étape 3.2 — Renseigner le formulaire

| Champ | Description | Exemple |
|---|---|---|
| **Page du Parent** | Synoptique hiérarchiquement supérieur | `accueil` |
| **Nom de la Page** | Identifiant interne (lettres, chiffres, tirets, underscores) | `plan_rdc` |
| **Level** | Niveau d'habilitation requis pour voir ce synoptique (0 à 9) | `1` |
| **Mode d'Affichage** | *Mode Simple* : navigation visible / *Mode Full* : plein écran | `Mode Simple` |
| **Libellé** | Titre affiché dans l'interface utilisateur | `Plan RDC` |

!!! warning "Le nom de la page doit être unique"
    Le **nom de la page** est l'identifiant interne du synoptique. Il doit être unique dans le domaine.
    Il ne peut contenir que des lettres, chiffres, tirets et underscores.

Cliquez sur **Valider** pour créer le synoptique.

---

## 4. Comprendre les niveaux d'accès

Le **niveau d'accès** d'un synoptique détermine qui peut le consulter :

| Niveau | Qui peut voir ce synoptique |
|---|---|
| **0** | Tous les utilisateurs du domaine |
| **1–5** | Utilisateurs ayant au moins ce niveau |
| **6** | Techniciens et administrateurs seulement |
| **7–9** | Administrateurs uniquement |

!!! tip "Synoptiques publics vs techniques"
    Mettez les synoptiques de supervision technique à un niveau ≥ 6.
    Les synoptiques destinés aux habitants peuvent rester à niveau 0 ou 1.

---

## 5. Modifier un synoptique existant

Depuis la liste, cliquez sur l'icône d'**édition** (crayon) du synoptique à modifier.

Les champs modifiables sont les mêmes que lors de la création, à l'exception du **nom de la page** qui ne peut pas être changé.

!!! note "Modifier le synoptique racine"
    Le synoptique d'identifiant `1` (page principale) ne peut pas changer de parent.
    Il est la racine de l'arborescence du domaine.

---

## 6. Organiser les synoptiques enfants

La page [/syn/child](https://console.abls-habitat.fr/syn/child) affiche les enfants directs d'un synoptique donné.
Elle est utile pour vérifier l'arborescence et naviguer entre les niveaux.

---

## 7. Associer un module D.L.S à un synoptique

Lors de la [création d'un module D.L.S](technicien_dls.md), vous avez renseigné le champ **Synoptique**.
Ce lien permet au moteur D.L.S de savoir sur quelle page visualiser l'état de ce module.

Depuis la liste des synoptiques, vous pouvez voir quels modules D.L.S sont rattachés à chaque page.

---

## 8. Bonnes pratiques

- **Créez d'abord la structure**, puis peuplez les synoptiques dans l'atelier
- **Nommez les pages** avec des identifiants stables (ils apparaissent dans les URL partagées)
- **Utilisez le mode Full** pour les synoptiques de type tableau de bord ou vue panoramique
- **Limitez la profondeur** de l'arborescence à 3–4 niveaux pour rester navigable
- **Rattachez chaque module D.L.S** au synoptique correspondant à sa zone physique

---

## Résumé des actions

```
1. Concevoir l'arborescence des synoptiques sur papier ou tableau
2. Créer le synoptique racine (parent = "Aucun")
3. Créer les synoptiques enfants en spécifiant leur parent
4. Définir les niveaux d'accès appropriés
5. → Passer à l'étape suivante : peupler les synoptiques dans l'atelier
```

**Page suivante : [Utiliser l'atelier graphique](technicien_atelier.md)**
