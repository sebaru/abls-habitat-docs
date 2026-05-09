# Étape 6 — Utiliser l'atelier graphique

L'**atelier** est l'éditeur graphique intégré à la console. Il permet de peupler les synoptiques avec des **motifs visuels** (pictogrammes, boutons, jauges, commentaires…) et de les associer en temps réel à des mnémoniques D.L.S.

!!! info "Position dans le workflow"
    L'atelier s'utilise après avoir créé les synoptiques et compilé les modules D.L.S.
    → Étape précédente : [Créer les synoptiques](technicien_synoptiques.md)
    → Étape suivante : [Gérer les mnémoniques](technicien_mnemos.md)

---

## 1. Accéder à l'atelier

Depuis la liste des synoptiques ([/synoptiques](https://console.abls-habitat.fr/synoptiques)), cliquez sur l'icône **Atelier** (pinceau/crayon) du synoptique à éditer.

L'atelier s'ouvre directement sur ce synoptique : [/atelier/\<page\>](https://console.abls-habitat.fr/atelier)

!!! tip "L'atelier est propre à chaque synoptique"
    Chaque synoptique a son propre espace de travail dans l'atelier.
    Un motif ajouté sur le synoptique `plan_rdc` n'apparaît que sur cette page.

---

## 2. Présentation de l'interface de l'atelier

L'atelier est composé de :

| Zone | Description |
|---|---|
| **Barre d'outils (haut)** | Actions : sauvegarder, ajouter des motifs, gérer les calques |
| **Trame (zone centrale)** | Surface de travail SVG avec grille magnétique |
| **Panneau de propriétés (droite)** | Paramètres du motif sélectionné (position, taille, rotation, mnémonique) |

La trame est quadrillée avec un **pas de grille** de 25 pixels. Les motifs se positionnent automatiquement sur cette grille pour faciliter l'alignement.

---

## 3. Ajouter un motif visuel

### Étape 3.1 — Ouvrir le catalogue de visuels

Dans la barre d'outils, cliquez sur **Ajouter un motif** (ou **+Visuel**).
Un catalogue de visuels disponibles s'affiche.

Les visuels sont organisés par catégorie :

| Catégorie | Exemples de visuels |
|---|---|
| **Éclairage** | Ampoule, LED, plafonnier, variateur |
| **Chauffage** | Radiateur, thermostat, flamme |
| **Volets / Stores** | Volet roulant, store, porte |
| **Sécurité** | Alarme, détecteur, caméra |
| **Énergie** | Prise, disjoncteur, compteur |
| **Eau** | Robinet, vanne, pompe, chauffe-eau |
| **Contrôle** | Bouton, interrupteur, nacelle |
| **Affichage** | Cadran, jauge, texte, commentaire |

### Étape 3.2 — Choisir et placer le visuel

Cliquez sur le visuel souhaité dans le catalogue.
Il apparaît au centre de la trame. Faites-le glisser à l'emplacement voulu.

!!! tip "Grille magnétique"
    Les motifs s'accrochent automatiquement à la grille (pas de 25px).
    Cela facilite l'alignement de plusieurs motifs entre eux.

### Étape 3.3 — Associer le motif à un mnémonique D.L.S

Cliquez sur le motif pour le sélectionner. Le panneau de propriétés s'affiche à droite.

Renseignez :

| Champ | Description | Exemple |
|---|---|---|
| **Tech_ID** | Identifiant du module D.L.S | `CHAUFFAGE_RDC` |
| **Acronyme** | Nom du mnémonique dans ce module | `CMD_CHAUFFE` |

Le motif est désormais lié à ce mnémonique. Son affichage changera automatiquement en fonction de la valeur du mnémonique en temps réel.

---

## 4. Types de visuels et leur comportement

### Visuels binaires (by_mode)

Ces visuels affichent une image différente selon que le mnémonique est `vrai` ou `faux`.

**Exemple** : une ampoule allumée/éteinte selon l'état d'un bistable D.L.S.

### Visuels colorés (by_color)

Ces visuels changent de couleur en fonction de la valeur du mnémonique.

**Exemple** : un voyant rouge/orange/vert selon un registre d'état.

### Visuels combinés (by_mode_color)

Combinent le changement d'image et de couleur selon l'état du mnémonique.

### Cadrans (cadran)

Les cadrans affichent une valeur numérique (registre ou entrée analogique).

| Type | Description |
|---|---|
| **Cadran texte** | Affiche la valeur numérique brute avec son unité |
| **Cadran horaire** | Affiche l'heure ou la durée |

Pour un cadran, renseignez en plus :
- L'**unité** (°C, %, kWh…)
- La **valeur min** et **valeur max** pour calibrer l'affichage

### Boutons

Les boutons permettent à l'utilisateur d'interagir avec le domaine (commande manuelle d'une sortie, envoi d'une commande D.L.S).

### Commentaires

Les commentaires sont des zones de texte statiques permettant d'étiqueter des zones du synoptique.

---

## 5. Déplacer, redimensionner et orienter un motif

Cliquez sur un motif pour le sélectionner. Le panneau de droite affiche :

| Propriété | Description |
|---|---|
| **Position X** | Position horizontale en pixels depuis le bord gauche |
| **Position Y** | Position verticale en pixels depuis le bord haut |
| **Échelle** | Facteur de zoom du motif (1.0 = taille normale) |
| **Angle** | Rotation du motif en degrés (0–360) |

Modifiez ces valeurs directement dans le panneau ou faites glisser le motif sur la trame.

---

## 6. Gérer les calques (ordre d'affichage)

Quand plusieurs motifs se superposent, l'ordre d'affichage (calque) détermine quel motif est au premier plan.

Utilisez les boutons de la barre d'outils :

| Bouton | Action |
|---|---|
| **Monter** | Passe le motif sélectionné un niveau vers l'avant |
| **Descendre** | Passe le motif sélectionné un niveau vers l'arrière |
| **Premier plan** | Passe le motif tout en avant |
| **Arrière-plan** | Passe le motif tout en arrière |

---

## 7. Sauvegarder le synoptique

!!! danger "N'oubliez pas de sauvegarder !"
    Les modifications dans l'atelier ne sont **pas sauvegardées automatiquement**.
    Cliquez sur le bouton **Sauvegarder** de la barre d'outils avant de quitter l'atelier.

Cliquez sur **Sauvegarder** (icône disquette ou bouton dédié) pour enregistrer la disposition des motifs.
Un message de confirmation s'affiche en cas de succès.

---

## 8. Supprimer un motif

Cliquez sur le motif à supprimer pour le sélectionner, puis cliquez sur le bouton **Supprimer** dans le panneau de propriétés (ou appuyez sur la touche `Suppr`).

!!! note "La suppression est locale à la session"
    La suppression d'un motif ne prend effet que lors de la sauvegarde. Si vous quittez sans sauvegarder, le motif est conservé.

---

## 9. Visualiser le résultat

Pour voir le synoptique tel qu'il apparaît à l'utilisateur final, quittez l'atelier et accédez à la page de visualisation de votre synoptique depuis l'interface [Home](https://home.abls-habitat.fr).

Les motifs liés à des mnémoniques se mettent à jour en temps réel selon l'état du domaine.

---

## Résumé des actions

```
1. Depuis /synoptiques, cliquer sur l'icône Atelier du synoptique
2. Ajouter un motif via le catalogue
3. Le placer à l'emplacement souhaité sur la trame
4. Associer le motif au Tech_ID et à l'Acronyme D.L.S souhaités
5. Ajuster la position, l'échelle et l'angle si nécessaire
6. Répéter pour chaque point à visualiser
7. Sauvegarder obligatoirement avant de quitter
```

**Référence des visuels disponibles : [Inventaire des visuels](visuels.md)**

**Page suivante : [Gérer les mnémoniques](technicien_mnemos.md)**
