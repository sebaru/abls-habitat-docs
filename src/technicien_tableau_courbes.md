# Ajouter un tableau de courbes sur un synoptique

Les **tableaux de courbes** permettent d'afficher l'**historique d'une grandeur** directement sur un synoptique, pour suivre l'évolution d'un capteur, d'une puissance, d'une température ou d'un autre mnémonique archivé.

Ils sont particulièrement utiles pour les vues techniques, les tableaux de bord de supervision ou les pages de suivi énergétique.

!!! info "Position dans le workflow"
    Cette fonctionnalité s'utilise après avoir :
    - créé le synoptique,
    - compilé les modules D.L.S,
    - activé l'archivage sur les mnémoniques concernés.
    → Étape précédente : [Utiliser l'atelier graphique](technicien_atelier.md)
    → Voir aussi : [Gérer les mnémoniques](technicien_mnemos.md)

---

## 1. À quoi sert un tableau de courbes ?

Un tableau de courbes affiche une série chronologique à partir des valeurs archivées d'un ou plusieurs mnémoniques.

Il permet de :

- visualiser l'évolution d'une mesure dans le temps,
- comparer plusieurs grandeurs sur la même vue,
- diagnostiquer un dysfonctionnement ou une dérive,
- surveiller l'usage d'une installation depuis une vue de synthèse.

Les usages typiques sont :

| Cas d'usage | Exemple de mnémonique archivé |
|---|---|
| Suivi thermique | `TEMP_SALON`, `TEMP_EXT` |
| Suivi énergétique | `PUISSANCE`, `CONSOMMATION` |
| Analyse de ventilation | `DEBIT_AIR`, `PRESSION` |
| Diagnostic de production | `NIVEAU`, `PRESSION_POMPE` |

---

## 2. Prérequis

Avant d'ajouter un tableau de courbes, vérifiez que :

1. le synoptique cible existe bien dans la console,
2. le mnémonique à afficher est bien en **archivage actif**,
3. l'atelier du synoptique est ouvert,
4. les données historiques sont déjà disponibles dans la base d'archivage.

!!! tip "Archivage obligatoire"
    Sans archivage, il n'y a pas de série exploitable pour un tableau de courbes.
    Consultez la section [Gérer les mnémoniques](technicien_mnemos.md) pour activer l'archivage avant de créer la vue.

---

## 3. Ouvrir l'atelier et ajouter le tableau

Depuis la console :

1. Ouvrez la page [/synoptiques](https://console.abls-habitat.fr/synoptiques)
2. Sélectionnez le synoptique cible
3. Cliquez sur l'icône **Atelier**
4. Dans l'atelier, utilisez le bouton **Ajouter un motif** (ou équivalent dans votre version)
5. Choisissez le **type de visuel** correspondant à un **tableau de courbes** / **graphique historique**

Le widget apparaît alors dans la zone de travail de l'atelier.

---

## 4. Positionner et dimensionner le tableau

Comme tout autre motif du synoptique :

- glissez le widget pour le placer à l'emplacement voulu,
- redimensionnez la zone pour lui donner une taille adaptée,
- respectez la grille de l'atelier pour conserver un alignement propre,
- veillez à laisser suffisamment d'espace pour la lisibilité des courbes.

!!! note "Taille recommandée"
    Pour un suivi technique lisible, prévoyez un espace large et horizontal.
    Une zone trop petite rend la lecture difficile et masque les détails de la courbe.

---

## 5. Configurer le tableau de courbes

Une fois le widget sélectionné, le panneau de propriétés affiche les paramètres du tableau.

Les réglages à renseigner sont généralement les suivants :

| Paramètre | Description |
|---|---|
| **Tech_ID** | Module D.L.S source du mnémonique |
| **Acronyme** | Nom du mnémonique archivé |
| **Libellé** | Titre affiché dans le graphique |
| **Unité** | `°C`, `%`, `kWh`, `W`, etc. |
| **Période** | Fenêtre de temps affichée (30 min, 6 h, 24 h, 7 j… ) |
| **Couleur** | Couleur de la courbe |
| **Echelle** | Plage manuelle ou automatique de l'axe Y |
| **Plusieurs séries** | Ajout d'autres mnémoniques sur le même graphique |

### Exemple

Pour afficher la température extérieure sur un synoptique technique :

- **Tech_ID** : `CLIMAT`
- **Acronyme** : `TEMP_EXT`
- **Unité** : `°C`
- **Période** : `24h`
- **Couleur** : bleu

Le système affiche alors la courbe d'évolution de cette valeur sur la fenêtre temporelle choisie.

---

## 6. Afficher plusieurs courbes sur un même tableau

La plupart des tableaux de courbes permettent d'associer **plusieurs séries** à une même zone de suivi.

C'est utile pour :

- comparer une température extérieure et une température intérieure,
- mettre en regard un seuil de consigne et la valeur réelle,
- suivre une mesure et son moyenne glissante.

Dans ce cas, chaque série est généralement associée à :

- un mnémonique différent,
- une couleur distincte,
- une légende explicite,
- une échelle compatible avec la grandeur mesurée.

!!! warning "Échelle et unités"
    Si plusieurs séries ont des unités très différentes, il est préférable de les afficher séparément pour éviter une lecture trompeuse.

---

## 7. Lecture et navigation de la courbe

Le graphique historique offre normalement les interactions suivantes :

- zoom sur une période précise,
- déplacement dans l'historique,
- affichage de la valeur au point courant,
- mise à jour automatique selon la période choisie,
- sélection d'un intervalle de temps pour une analyse détaillée.

La lecture doit se faire en gardant à l'esprit :

- la **période affichée**,
- la **résolution d'archivage** de la donnée,
- l'**unité** de la courbe,
- la **date/heure** de la dernière mesure.

---

## 8. Bonnes pratiques de conception

### Utiliser des courbes quand c'est utile

Privilégiez un tableau de courbes pour les données qui évoluent dans le temps et qui ont un intérêt fonctionnel, par exemple :

- température,
- consommation,
- puissance,
- niveau,
- pression,
- débit.

Évitez d'en surcharger la page lorsque l'information n'a pas besoin d'un historique.

### Préparer les données

Avant d'ajouter le visuel :

- activez l'archivage sur les mnémoniques pertinents,
- vérifiez qu'ils remontent correctement dans la page [mnemos](https://console.abls-habitat.fr/mnemos),
- choisissez des mnémoniques stables et utiles à l'usage opérationnel.

### Garder les pages lisibles

- limitez le nombre de courbes par widget,
- donnez des libellés clairs,
- choisissez un fond et une couleur qui restent lisibles,
- n'affichez pas des données trop bruitées et non pertinentes.

---

## 9. Procédure rapide de mise en place

```
1. Vérifier que le mnémonique est archivé
2. Ouvrir l'atelier du synoptique
3. Ajouter le visuel de tableau de courbes
4. Positionner le widget dans la page
5. Choisir le Tech_ID et l'Acronyme du mnémonique
6. Sélectionner l'unité, la période et la couleur
7. Ajouter d'autres séries si nécessaire
8. Sauvegarder le synoptique
9. Contrôler le rendu dans la vue finale
```

---

## 10. Vérification finale

Une fois le widget ajouté :

1. quittez l'atelier si vous êtes dans le mode édition,
2. ouvrez la vue du synoptique dans l'interface utilisateur,
3. vérifiez que la courbe se charge correctement,
4. confirmez que les données remontent sur la période souhaitée,
5. ajustez la taille, la période ou la configuration si la lecture n'est pas satisfaisante.

!!! success "Objectif"
    Un tableau de courbes bien positionné doit permettre à un technicien de diagnostiquer rapidement l'évolution d'une donnée sans quitter le synoptique.

**Voir aussi :** [Utiliser l'atelier graphique](technicien_atelier.md) • [Gérer les mnémoniques](technicien_mnemos.md)
