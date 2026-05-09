# Étape 2 — Configurer les threads (connecteurs)

Un **thread** est une instance de connecteur exécutée au sein d'un agent. Il représente la connexion active entre Abls-Habitat et un équipement physique ou un service externe (automate Modbus, GPIO Raspberry Pi, module audio, SMS, etc.).

!!! info "Position dans le workflow"
    Cette étape nécessite qu'au moins un agent soit déjà actif.
    → Étape précédente : [Ajouter un agent](technicien_agents.md)
    → Étape suivante : [Créer les modules D.L.S](technicien_dls.md)

---

## 1. Accéder à la configuration des connecteurs

Depuis la console, accédez à la page [/io/config](https://console.abls-habitat.fr/io/config).

Cette page présente toutes les familles de connecteurs disponibles sous forme de cartes illustrées.

| Connecteur | Usage | Page |
|---|---|---|
| **I/O Wago Modbus** | Automates Wago 750 via Modbus TCP | [/modbus](https://console.abls-habitat.fr/modbus) |
| **Raspberry PI GPIO** | Entrées/sorties GPIO | [/gpiod](https://console.abls-habitat.fr/gpiod) |
| **Phidget** | Modules I/O USB | [/phidget](https://console.abls-habitat.fr/phidget) |
| **Audio** | Diffusion audio multizone | [/audio](https://console.abls-habitat.fr/audio) |
| **GSM / SMS** | Notifications par SMS | [/smsg](https://console.abls-habitat.fr/smsg) |
| **Messagerie XMPP** | Messagerie instantanée | [/imsgs](https://console.abls-habitat.fr/imsgs) |
| **Téléinfo EDF** | Compteur Linky | [/teleinfoedf](https://console.abls-habitat.fr/teleinfoedf) |
| **SHELLY** | Modules domotiques Wi-Fi | [/shelly](https://console.abls-habitat.fr/shelly) |
| **Onduleurs UPS** | Surveillance via NUT | [/ups](https://console.abls-habitat.fr/ups) |
| **Météo API** | Données météo en ligne | [/meteo](https://console.abls-habitat.fr/meteo) |
| **Caméras** | Flux vidéo IP | [/cameras](https://console.abls-habitat.fr/cameras) |

---

## 2. Créer un thread Modbus (exemple pas à pas)

L'exemple ci-dessous détaille la création d'un thread **Wago Modbus TCP**, le connecteur le plus courant dans les installations Abls-Habitat.

### Étape 2.1 — Ouvrir la configuration Modbus

Depuis [/io/config](https://console.abls-habitat.fr/io/config), cliquez sur la carte **I/O Wago Modbus**.
Vous arrivez sur la page [/modbus](https://console.abls-habitat.fr/modbus).

### Étape 2.2 — Ajouter un nouveau thread Modbus

Cliquez sur **Ajouter un Modbus**.

Renseignez le formulaire :

| Champ | Description | Exemple |
|---|---|---|
| **Agent** | Agent qui portera ce thread | `serveur-principal` |
| **Tech_ID** | Identifiant unique du thread (MAJUSCULES, sans espace) | `WAGO_RDC` |
| **Hostname / IP** | Adresse IP ou nom DNS de l'automate | `192.168.1.10` |
| **Description** | Libellé lisible pour ce connecteur | `Wago RDC - bâtiment principal` |

!!! tip "Nommez clairement vos Tech_IDs"
    Le **Tech_ID** est utilisé dans tout le système pour référencer ce connecteur.
    Utilisez une convention cohérente, par exemple : `WAGO_<ZONE>` → `WAGO_RDC`, `WAGO_ETAGE1`.

Cliquez sur **Valider** pour créer le thread.

### Étape 2.3 — Vérifier la connexion

Après création, le thread apparaît dans la liste. Vérifiez les indicateurs :

| Indicateur | Valeur souhaitée |
|---|---|
| **Enable** | `Actif` (pastille verte) |
| **Connexion** | `Connecté` |
| **MQTT** | `Connecté` |

Si la connexion est en erreur, vérifiez l'adresse IP de l'automate et la disponibilité réseau.

---

## 3. Activer / désactiver un thread

Depuis la liste des threads ([/threads](https://console.abls-habitat.fr/threads)) :

- Cliquez sur **Actif** pour désactiver un thread temporairement (maintenance)
- Cliquez sur **Désactivé** pour le réactiver

!!! warning "Impact de la désactivation"
    Désactiver un thread interrompt toutes les communications avec l'équipement correspondant.
    Les mnémoniques D.L.S associés ne seront plus mis à jour.

---

## 4. Activer le mode debug

Le **mode debug** permet de voir les échanges détaillés entre l'agent et l'équipement dans les logs système.
Il est utile lors de la mise en service pour diagnostiquer des problèmes de communication.

Depuis [/threads](https://console.abls-habitat.fr/threads) :

1. Trouvez le thread concerné
2. Cliquez sur **Activer le debug**
3. Consultez les logs de l'agent (`journalctl -u watchdogd -f` sur le serveur)

!!! tip "Désactivez le debug en production"
    Le mode debug génère un volume important de logs. Pensez à le désactiver une fois la mise en service terminée.

---

## 5. Consulter la liste globale des threads

La page [/threads](https://console.abls-habitat.fr/threads) donne une vue consolidée de **tous les threads** de tous les agents du domaine.

Pour chaque thread sont affichés :

| Colonne | Description |
|---|---|
| **Tech_ID** | Identifiant du thread (lien vers le module D.L.S associé) |
| **Agent** | Nom du serveur portant ce thread |
| **Classe** | Type de connecteur (modbus, gpiod, audio…) |
| **Enable** | Actif ou désactivé |
| **Connexion** | État de connexion avec l'équipement |
| **MQTT** | Connexion avec le broker MQTT interne |
| **Debug** | Mode debug actif ou non |
| **Description** | Libellé du thread |

---

## 6. Supprimer un thread

Depuis la page de configuration du connecteur concerné (ex : [/modbus](https://console.abls-habitat.fr/modbus)) :

1. Trouvez le thread à supprimer
2. Cliquez sur l'icône **Supprimer**
3. Confirmez la suppression dans la boîte de dialogue

!!! danger "Suppression irréversible"
    La suppression d'un thread efface sa configuration et désactive tous les mappings I/O associés.
    Les mnémoniques D.L.S correspondants restent en base mais ne seront plus alimentés.

---

## Résumé des actions

```
1. Aller sur /io/config et sélectionner le type de connecteur
2. Ajouter un thread via le formulaire (Tech_ID, agent, paramètres réseau)
3. Vérifier l'état dans /threads (Connecté, Actif)
4. Activer le debug si besoin pour diagnostiquer
5. → Passer à l'étape suivante : créer les modules D.L.S
```

**Page suivante : [Créer les modules D.L.S](technicien_dls.md)**
