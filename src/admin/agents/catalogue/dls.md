# Agent DLS

Le **moteur d'exécution des modules D.L.S** : il compile et exécute en temps réel la logique
d'automatisation du domaine.

!!! warning "Vous n'avez probablement pas besoin de l'installer"
    Depuis l'intégration du moteur dans `abls-agent-server`, le paquet `abls-agent-dls` n'est
    plus nécessaire dans une installation standard : le serveur master embarque déjà le moteur.

    N'installez cet agent séparément que sur instruction explicite, par exemple pour isoler le
    moteur sur une machine dédiée.

---

## Rôle

- Charge les modules D.L.S compilés depuis l'API.
- Exécute la logique à la fréquence définie par `tps` (50 tours par seconde par défaut).
- Publie les consignes de sortie sur le bus MQTT local (`SET_DO/`, `SET_AO/`).
- Alimente l'historique, les messages et les visuels.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | 2 cœurs, 1 Go de RAM |
| Réseau | Accès au broker MQTT local et à l'API |
| Rôle | La machine doit être désignée **master** du domaine |

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-dls
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-dls
    ```

---

## Unité systemd

`abls-agent-dls.service` — unité **simple**, non templatée.

!!! danger "Le `tech_id` doit venir du fichier commun"
    Comme pour [`server`](server.md), l'unité ne passe pas `--agent-tech-id`.
    Placez `agent_tech_id` dans `/etc/abls/abls-agent.conf`.

---

## Paramètres spécifiques

Aucune option de ligne de commande supplémentaire.

Le paramètre commun le plus structurant ici est **`tps`** :

| Valeur | Effet |
|---|---|
| 50 (défaut) | Un tour toutes les 20 ms |
| Plus élevé | Meilleure réactivité, charge CPU accrue |
| Plus faible | Économie de CPU, temporisations moins précises |

!!! warning "Ne changez pas `tps` sans prévenir le technicien"
    Certaines temporisations et compteurs d'impulsions sont dimensionnés en tours.
    Modifier `tps` change leur comportement.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Aucun module ne s'exécute | Vérifier que la machine est bien désignée master dans la Console |
| Erreurs de compilation signalées dans la Console | Le problème est dans le code D.L.S : voir le technicien |
| Tours par seconde sous la consigne | Machine saturée, `log_level` trop verbeux, ou module coûteux |
| Deux moteurs en concurrence | `abls-agent-dls` et `abls-agent-server` tournent tous deux : désactivez `abls-agent-dls` |

```bash
sudo journalctl -u abls-agent-dls.service -f
```

---

## Voir aussi

- [Agent SERVER](server.md)
- [Le langage D.L.S](../../../technicien/dls/index.md) — côté technicien
