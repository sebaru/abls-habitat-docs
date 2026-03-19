# La Console Abls-Habitat

La **Console** est l'interface web d'administration et de configuration d'un domaine Abls-Habitat.
Elle est accessible à l'adresse [https://console.abls-habitat.fr](https://console.abls-habitat.fr).

---

## Tableau de bord

Après connexion et sélection d'un domaine, la console affiche un **tableau de bord** synthétique qui présente en temps réel l'état de votre domaine :

| Indicateur | Description |
|---|---|
| **Synoptiques** | Nombre de synoptiques, de motifs et de liens |
| **D.L.S** | Nombre de modules, erreurs de compilation, lignes, bistables, monostables |
| **Agents** | Nombre d'agents et de threads actifs |
| **Entrées/Sorties** | Nombre d'entrées/sorties TOR et analogiques |
| **Messages** | Messages actifs et historique |
| **Utilisateurs** | Nombre d'utilisateurs et entrées dans le journal d'audit |

Des **courbes temps réel** complètent le tableau de bord et permettent de suivre les performances du moteur D.L.S :

- Tours par seconde et bits par seconde traités
- Temps d'attente du moteur
- Nombre de motifs, plugins, erreurs et lignes compilées
- Consommation mémoire (Max RSS)
- Journalisation par minute

---

## Navigation principale

La console est organisée autour de plusieurs rubriques accessibles depuis la barre de navigation :

- [Synoptiques](console_synoptiques.md) — Création et gestion des synoptiques de visualisation
- [D.L.S](console_dls.md) — Gestion des modules de logique D.L.S
- [Connecteurs](console_connecteurs.md) — Configuration des équipements connectés
- [Archives](console_archives.md) — Paramétrage de la rétention des données
- [Domaine](console_domaine.md) — Configuration et sélection du domaine
- [Utilisateurs](console_utilisateurs.md) — Gestion et invitation des utilisateurs
