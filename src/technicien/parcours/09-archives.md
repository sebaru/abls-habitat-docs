# Paramétrage des Archives

Le système Abls-Habitat enregistre en continu des données de mesure (valeurs analogiques, états, compteurs…).
La page [/archive](https://console.abls-habitat.fr/archive) permet de configurer la politique de **rétention** de ces données.

---

## Principe des archives

Abls-Habitat utilise deux niveaux de stockage pour les données archivées :

| Niveau | Nom | Résolution | Usage |
|---|---|---|---|
| **Chaud** | *Hot* | Haute résolution | Courbes récentes, diagnostic |
| **Froid** | *Cold* | Basse résolution | Historique long terme |

Les données chaudes sont conservées pendant une durée courte (quelques mois) avec une résolution fine.
Passé ce délai, elles sont compressées et déplacées dans les archives froides, conservées pendant plusieurs années.

---

## Configuration de la rétention

### Archives chaudes

| Paramètre | Description |
|---|---|
| **Durée de rétention chaude** | Durée de conservation des archives chaudes, en **mois** |
| **Nombre d'archives chaudes** | Nombre total d'enregistrements actuellement en base (lecture seule) |
| **Taille des archives chaudes** | Volume de stockage occupé en **Mo** (lecture seule) |

### Archives froides

| Paramètre | Description |
|---|---|
| **Durée de rétention froide** | Durée de conservation des archives froides, en **années** |
| **Nombre d'archives froides** | Nombre total d'enregistrements en archive froide (lecture seule) |
| **Taille des archives froides** | Volume de stockage occupé en **Mo** (lecture seule) |

Après modification, cliquez sur **Save** pour enregistrer la configuration.

!!! warning
    Réduire la durée de rétention entraîne la suppression définitive des données antérieures au nouveau seuil.
    Cette opération est **irréversible**.

---

## Courbes de suivi

La page d'archive affiche également des courbes de supervision permettant de suivre l'évolution du volume d'archives au fil du temps :

- **Fragmentation maximale** : indicateur de la fragmentation de la base de données
- **Nombre d'archives chaudes** : évolution du nombre d'enregistrements en archive chaude

Ces courbes permettent d'anticiper les besoins en stockage et d'ajuster la politique de rétention en conséquence.

---

## Bonnes pratiques

!!! tip
    - Pour un usage courant, une rétention chaude de **3 à 6 mois** et une rétention froide de **5 à 10 ans** est recommandée.
    - Surveillez régulièrement la taille des archives pour anticiper les besoins en espace disque.
    - La fragmentation élevée peut dégrader les performances de lecture des courbes ; un OPTIMIZE TABLE périodique est réalisé automatiquement.
