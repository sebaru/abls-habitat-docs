# Étape 1 — Ajouter et gérer les agents

Un **agent** (`Watchdogd`) est le processus logiciel qui s'exécute sur votre serveur et qui fait le lien entre l'API centrale Abls-Habitat et vos équipements physiques.
Avant toute mise en service, au moins un agent doit être déployé et lié au domaine.

!!! info "Position dans le workflow"
    Cette étape est la **première** à réaliser. Sans agent actif, aucun connecteur ne peut fonctionner.
    → Étape suivante : [Configurer les threads (connecteurs)](technicien_threads.md)

---

## 1. Récupérer les informations de liaison

Avant de déployer un agent, récupérez les identifiants du domaine depuis la console :

1. Connectez-vous sur [https://console.abls-habitat.fr](https://console.abls-habitat.fr)
2. Sélectionnez votre domaine depuis la page [/domains](https://console.abls-habitat.fr/domains)
3. Allez dans **Configuration du domaine** → [/domain/edit](https://console.abls-habitat.fr/domain/edit)
4. Notez :
    - le **Domain UUID** (identifiant unique du domaine)
    - le **Domain Secret Key** (clé secrète — ne jamais partager !)

!!! danger "Confidentialité du Domain Secret"
    Le **Domain Secret Key** est une donnée sensible. Ne le communiquez jamais par email ou messagerie.
    Il permet à n'importe quel agent de se connecter à votre domaine.

---

## 2. Déployer un agent via container (recommandé)

C'est la méthode la plus simple et la plus reproductible.

### Prérequis
- Podman ou Docker installé sur le serveur cible
- Accès réseau vers `api.abls-habitat.fr` (port 5559)

### Commande de déploiement

La console génère automatiquement la commande adaptée à votre domaine.
Rendez-vous sur [/agent/add](https://console.abls-habitat.fr/agent/add) et copiez la commande affichée :

```bash
podman run -d \
  --name abls-agent \
  --restart always \
  --tz local \
  -p 5559:5559 \
  -v /dev/log:/dev/log \
  --env ABLS_API_URL=api.abls-habitat.fr \
  --env ABLS_DOMAIN_UUID=<domain_uuid> \
  --env ABLS_DOMAIN_SECRET=<domain_secret> \
  --group-add keep-groups \
  docker.io/sebaru/abls-agent:latest
```

Remplacez `<domain_uuid>` et `<domain_secret>` par vos valeurs réelles.

!!! tip "Utiliser la page /agent/add"
    La page [/agent/add](https://console.abls-habitat.fr/agent/add) génère automatiquement la commande avec vos valeurs de domaine pré-remplies. C'est le moyen le plus simple d'éviter les erreurs de copie.

---

## 3. Déployer un agent en natif

Si vous préférez une installation native sur Debian/Fedora/RaspiOS :

### Installation

```bash
sudo bash -c "$(wget https://raw.githubusercontent.com/sebaru/Watchdog/main/INSTALL.sh -q -O -)"
```

### Liaison au domaine

Une fois installé, liez l'agent :

```bash
sudo Watchdogd --save --domain-uuid <domain_uuid> --domain-secret <domain_secret>
```

### Démarrage du service

```bash
sudo systemctl enable --now watchdogd
```

---

## 4. Vérifier que l'agent est bien lié

Depuis la console, rendez-vous sur [/agents](https://console.abls-habitat.fr/agents).

La liste affiche tous les agents connus du domaine. Votre nouvel agent doit apparaître avec :

| Colonne | Valeur attendue |
|---|---|
| **Hostname** | Nom du serveur |
| **Version** | Version de Watchdogd |
| **État** | `Actif` (pastille verte) |
| **Master** | `Oui` si c'est le seul agent ou le principal |

!!! warning "L'agent n'apparaît pas ?"
    Vérifiez que :
    - Le service tourne bien (`systemctl status watchdogd` ou `podman ps`)
    - Le serveur peut atteindre `api.abls-habitat.fr` sur le port 5559
    - Le `domain_uuid` et le `domain_secret` sont corrects

---

## 5. Actions disponibles sur un agent

Depuis la liste des agents ([/agents](https://console.abls-habitat.fr/agents)), plusieurs actions sont disponibles :

| Action | Description |
|---|---|
| **Redémarrer** | Relance le processus Watchdogd sur le serveur distant |
| **Mettre à jour** | Télécharge et installe la dernière version de l'agent |
| **Promouvoir en Master** | Désigne cet agent comme agent principal du domaine |
| **Mettre à jour tous les slaves** | Met à jour en masse tous les agents secondaires |

!!! tip "Agent Master vs Slave"
    Dans un déploiement multi-agents, un agent est désigné **Master** : il gère les tâches centrales.
    Les autres agents (**Slaves**) portent des connecteurs supplémentaires (GPIO, Modbus sur un autre réseau…).

---

## Résumé des actions

```
1. Récupérer Domain UUID et Domain Secret depuis /domain/edit
2. Se rendre sur /agent/add pour obtenir la commande de déploiement
3. Exécuter la commande sur le serveur cible
4. Vérifier l'apparition de l'agent dans /agents
5. → Passer à l'étape suivante : configurer les threads
```

**Page suivante : [Configurer les threads (connecteurs)](technicien_threads.md)**
