# Synoptiques

Les **synoptiques** sont des pages de visualisation graphique qui permettent de représenter l'état de vos installations sous forme de schémas interactifs.
Chaque synoptique est composé de **motifs** (visuels graphiques) et de **liens** entre eux, reflétant l'état temps réel du domaine.

---

## Liste des synoptiques

La page [/synoptiques](https://console.abls-habitat.fr/synoptiques) affiche l'ensemble des synoptiques du domaine sous forme de tableau.

Pour chaque synoptique sont indiqués :

- Le **nom de la page** (`page`) : identifiant interne unique
- Le **libellé** : titre affiché à l'utilisateur
- Le **synoptique parent** : permet d'organiser une hiérarchie de pages
- Le **niveau d'accès** (`access_level`) : contrôle qui peut voir ou modifier le synoptique
- Le **mode d'affichage** : *Simple* ou *Full*

---

## Ajouter un synoptique

Cliquez sur le bouton **Ajouter un Synoptique** pour créer un nouveau synoptique.

Le formulaire de création demande :

| Champ | Description |
|---|---|
| **Page du Parent** | Synoptique hiérarchiquement supérieur (optionnel) |
| **Nom de la Page** | Identifiant interne, utilisé dans les URL |
| **Level** | Niveau d'habilitation requis (0 à 9) |
| **Mode d'Affichage** | *Mode Simple* : barre de navigation réduite / *Mode Full* : plein écran |
| **Libellé** | Nom affiché dans l'interface utilisateur |

---

## Éditer un synoptique

Depuis la liste, cliquez sur l'icône d'édition d'un synoptique pour modifier ses propriétés.

!!! note
    La modification du **niveau d'accès** contrôle la visibilité du synoptique pour les utilisateurs.
    Un utilisateur de niveau *N* voit les synoptiques de niveau inférieur ou égal à *N*.

---

## Hiérarchie des synoptiques

Les synoptiques peuvent être organisés en **arborescence** grâce au champ *Page du Parent*.
Cette structure permet de créer une navigation entre les différentes vues de votre installation (ex : vue générale → étage → pièce).

La page [/syn/child](https://console.abls-habitat.fr/syn/child) affiche les synoptiques enfants d'un synoptique donné.

---

## Éditeur graphique

Depuis la liste des synoptiques, l'**atelier** permet d'éditer graphiquement le contenu d'un synoptique :

- Ajout, déplacement et suppression de **motifs visuels** (boutons, jauges, icônes, commentaires…)
- Association d'un motif à un **mnémonique D.L.S** pour afficher l'état temps réel
- Organisation de la mise en page

!!! tip
    Les motifs disponibles sont définis dans l'[inventaire des visuels](visuels.md).
    Chaque motif peut être lié à un bit interne, une entrée, une sortie ou tout autre mnémonique D.L.S.
