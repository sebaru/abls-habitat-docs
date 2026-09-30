# Connecteurs dans la Console

La console regroupe la configuration de l'ensemble des **connecteurs** (également appelés *threads*) dans une page dédiée.
Les connecteurs sont les interfaces entre le moteur D.L.S et les équipements physiques ou services externes.

Pour une description technique des connecteurs, consultez la section [Connecteurs](../connecteurs/index.md).

---

## Page des Connecteurs et Mappings

La page [/io/config](https://console.abls-habitat.fr/io/config) est le point d'entrée de la configuration des connecteurs.
Elle présente l'ensemble des familles de connecteurs disponibles sous forme de cartes illustrées.

### Connecteurs disponibles

| Connecteur | Description | Page de configuration |
|---|---|---|
| **I/O Wago Modbus** | Automates Wago série 750 via Modbus TCP | [/agents/modbus](https://console.abls-habitat.fr/agents/modbus) |
| **Raspberry PI GPIO** | Entrées/sorties GPIO d'un Raspberry Pi | [/agents/gpiod](https://console.abls-habitat.fr/agents/gpiod) |
| **Phidget** | Modules I/O USB Phidget | [/agents/phidget](https://console.abls-habitat.fr/agents/phidget) |
| **Audio** | Diffusion audio (zones et sources) | [/agents/audio](https://console.abls-habitat.fr/agents/audio) |
| **GSM / SMS** | Envoi de SMS via modem GSM | [/agents/sms](https://console.abls-habitat.fr/agents/sms) |
| **Messagerie XMPP** | Messagerie instantanée XMPP | [/agents/imsg](https://console.abls-habitat.fr/agents/imsg) |
| **Téléinfo EDF** | Lecture du compteur Linky via téléinfo | [/agents/teleinfoedf](https://console.abls-habitat.fr/agents/teleinfoedf) |
| **SHELLY** | Modules domotiques SHELLY | [/agents/shelly](https://console.abls-habitat.fr/agents/shelly) |
| **Onduleurs UPS** | Surveillance des onduleurs via NUT | [/agents/ups](https://console.abls-habitat.fr/agents/ups) |
| **Météo API** | Données météorologiques en ligne | [/agents/meteo](https://console.abls-habitat.fr/agents/meteo) |
| **Caméras** | Flux vidéo IP | [/cameras](https://console.abls-habitat.fr/cameras) |

---

## Gestion des Agents

Les connecteurs sont exécutés par des **agents** — des processus s'exécutant sur vos serveurs ou équipements.

La page [/agents](https://console.abls-habitat.fr/agents) liste les agents enregistrés sur le domaine et leur état.

### Ajouter un agent

La page [/agent/add](https://console.abls-habitat.fr/agent/add) fournit les instructions et commandes pour :

- Déployer un agent via **container** (Podman/Docker)
- Installer un agent **natif** sur un serveur Linux

### Threads

Chaque agent exécute un ou plusieurs **threads**, correspondant aux instances de connecteurs actifs.

La page [/threads](https://console.abls-habitat.fr/threads) affiche l'état temps réel de tous les threads actifs sur le domaine :
statut, version, temps de fonctionnement, messages de débogage.

---

## Mapping Connecteur ↔ D.L.S

Le **mapping** définit la correspondance entre les entrées/sorties physiques d'un connecteur et les mnémoniques D.L.S.

Consultez la section [Mapping](../parcours/03-mapping.md) pour une description détaillée.

---

## Mnémoniques

La page [/mnemos](https://console.abls-habitat.fr/mnemos) liste l'ensemble des **mnémoniques** (variables) du domaine :
bits internes, entrées, sorties, registres, monostables, compteurs, messages, etc.

Elle permet de rechercher un mnémonique et de visualiser ses propriétés et son état courant.
