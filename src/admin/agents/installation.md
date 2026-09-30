# Installer les agents et gérer les services

Cette page décrit l'installation des paquets et le cycle de vie des services `systemd`.
Elle suppose que les [dépôts de paquets](depots.md) sont déjà déclarés.

---

## Choisir les paquets à installer

Un paquet par classe d'agent. Le nom suit toujours la forme `abls-agent-<classe>`.

| Paquet | Rôle | À installer sur |
|---|---|---|
| `abls-agent-server` | Superviseur local, embarque le moteur D.L.S | Le serveur **master** du site |
| `abls-agent-dls` | Moteur D.L.S autonome | Rarement : déjà embarqué dans `server` |
| `abls-agent-modbus` | Automates Modbus TCP (Wago…) | Machine ayant accès au réseau automate |
| `abls-agent-gpiod` | GPIO Linux (Raspberry Pi) | La carte portant les GPIO |
| `abls-agent-phidget` | Modules Phidget USB | La machine où est branché le HUB |
| `abls-agent-audio` | Annonces vocales et sons | La machine reliée aux enceintes |
| `abls-agent-sms` | Envoi/réception SMS | Machine avec modem GSM, ou passerelle OVH |
| `abls-agent-imsg` | Messagerie instantanée XMPP | N'importe quelle machine connectée |
| `abls-agent-teleinfoedf` | Téléinformation client E.D.F | Machine reliée au TIC par liaison série |
| `abls-agent-shelly` | Équipements Shelly | Machine sur le réseau des Shelly |
| `abls-agent-ups` | Onduleur via NUT | Machine ayant accès au serveur `upsd` |
| `abls-agent-meteo` | Prévisions Météo-Concept | N'importe quelle machine connectée |

Le détail de chaque classe figure dans le [catalogue](catalogue/index.md).

!!! tip "Commencez toujours par `abls-agent-server`"
    C'est lui qui désigne le serveur au domaine, porte le broker MQTT local et exécute la logique
    D.L.S. Les autres agents s'y raccordent.

---

## Installer

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-server
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-server
    ```

L'installation crée le groupe système `abls` et le répertoire `/etc/abls/`.

!!! note "Aucun service n'est démarré automatiquement"
    Les paquets n'activent ni ne redémarrent aucun service. C'est volontaire : un agent non
    enrôlé s'arrêterait immédiatement. Enrôlez d'abord, activez ensuite.

---

## Enrôler avant de démarrer

Un agent a besoin d'un `agent_tech_id` et des identifiants du domaine pour fonctionner.
Cette étape est décrite en détail dans [Enrôlement sur le domaine](enrolement.md).

En résumé :

```bash
sudo abls-agent-server --agent-tech-id SERVER_MAISON \
                       --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                       --domain-secret 'votre-secret-ici' \
                       --api-url       api.abls-habitat.fr \
                       --save
```

---

## Deux familles d'unités systemd

Les agents se répartissent en deux familles, ce qui change la commande de démarrage.

### Unités simples

Un seul exemplaire par machine, pas de `tech_id` dans le nom du service.

| Agent | Unité |
|---|---|
| `server` | `abls-agent-server.service` |
| `dls` | `abls-agent-dls.service` |

```bash
sudo systemctl enable --now abls-agent-server.service
```

!!! warning "Le `tech_id` doit venir de la configuration"
    Ces unités ne passent **pas** `--agent-tech-id` sur la ligne de commande.
    Le `agent_tech_id` doit donc impérativement figurer dans `/etc/abls/abls-agent.conf`
    ou dans l'environnement du service, sinon l'agent quitte au démarrage avec
    `There is no 'agent_tech_id', in config, exiting.`

    Le plus simple est de l'avoir enregistré via `--save`, ce qui écrit
    `/etc/abls/abls-agent-server@SERVER_MAISON.conf`… mais **ce fichier n'est lu qu'après** que le
    `tech_id` soit connu. Pour ces deux agents, placez donc `agent_tech_id` dans
    `/etc/abls/abls-agent.conf` :

    ```json
    { "agent_tech_id": "SERVER_MAISON" }
    ```

### Unités templatées

Plusieurs instances par machine, le `tech_id` est l'instance après le `@`.

| Agent | Unité |
|---|---|
| `modbus` | `abls-agent-modbus@.service` |
| `gpiod` | `abls-agent-gpiod@.service` |
| `phidget` | `abls-agent-phidget@.service` |
| `sms` | `abls-agent-sms@.service` |
| `imsg` | `abls-agent-imsg@.service` |
| `teleinfoedf` | `abls-agent-teleinfoedf@.service` |
| `shelly` | `abls-agent-shelly@.service` |
| `ups` | `abls-agent-ups@.service` |
| `meteo` | `abls-agent-meteo@.service` |
| `audio` | `abls-agent-audio@.service` (unité **utilisateur**) |

```bash
sudo systemctl enable --now abls-agent-modbus@MODBUS_CHAUFFERIE.service
```

L'unité passe automatiquement `--agent-tech-id %i` au binaire : l'instance **est** le `tech_id`.

Deux automates Modbus sur la même machine :

```bash
sudo systemctl enable --now abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo systemctl enable --now abls-agent-modbus@MODBUS_GARAGE.service
```

Chacun lit son propre `/etc/abls/abls-agent-modbus@<tech_id>.conf` et dispose de son propre
répertoire d'état sous `/var/lib/abls-agent-modbus/<tech_id>/`.

!!! warning "Caractères autorisés dans le nom d'instance"
    systemd n'accepte pas tous les caractères dans un nom d'instance. Restez sur
    `[A-Za-z0-9_]`. Un `/` devrait être échappé en `-`, ce qui casserait la correspondance avec
    le `tech_id` attendu par l'API.

### Cas particulier : l'agent AUDIO

L'agent audio doit accéder au serveur de son de la session, il tourne donc en **service
utilisateur**, pas en service système.

```bash
# Activer le modèle pour tous les utilisateurs
sudo systemctl --global enable abls-agent-audio@AUDIO_SALON.service

# Permettre à la session de survivre à la déconnexion
sudo loginctl enable-linger monutilisateur

# Démarrer
sudo -iu monutilisateur systemctl --user daemon-reload
sudo -iu monutilisateur systemctl --user start abls-agent-audio@AUDIO_SALON.service
```

Les journaux se consultent alors avec `journalctl --user -u ...` en tant que cet utilisateur.

---

## Cycle de vie d'un service

```bash
sudo systemctl start    abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo systemctl stop     abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo systemctl restart  abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo systemctl status   abls-agent-modbus@MODBUS_CHAUFFERIE.service
```

!!! note "L'arrêt peut prendre du temps"
    À l'arrêt, un agent sauvegarde son état vers l'API. Comptez jusqu'à plusieurs minutes pour
    `abls-agent-server` sur un domaine chargé. Ne forcez pas avec `SIGKILL`.

Toutes les unités redémarrent automatiquement en cas d'échec
(`Restart=on-failure`, ou `Restart=always` pour `server`).

---

## Ce que le paquet installe

| Chemin | Contenu |
|---|---|
| `/usr/bin/abls-agent-<classe>` | Le binaire |
| `/lib/systemd/system/abls-agent-<classe>*.service` | L'unité |
| `/etc/abls/` | Répertoire des fichiers de configuration |
| `/var/lib/abls-agent-<classe>/[<tech_id>/]` | État persistant (`StateDirectory`) |

Les agents tournent sous un utilisateur dédié ou en `DynamicUser`, toujours membre du groupe
supplémentaire `abls`. C'est ce groupe qui donne accès aux fichiers de configuration en `0640`.

---

## Lister ce qui est installé et actif

```bash
# Paquets Abls installés
dpkg -l 'abls-*'          # Debian
rpm -qa 'abls-*'          # Fedora

# Services Abls actifs
systemctl list-units 'abls-agent-*' --all
```

---

## Réinstaller un agent de zéro

Pour repartir d'une configuration vierge :

```bash
sudo systemctl stop abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo rm /etc/abls/abls-agent-modbus@MODBUS_CHAUFFERIE.conf
```

Puis refaites l'[enrôlement](enrolement.md).

!!! tip "Conserver le `server_uuid`"
    Si vous réinstallez une machine existante, notez son `server_uuid` avant d'effacer la
    configuration et repassez-le avec `--server-uuid`. Sinon l'API verra un nouveau serveur et
    vous devrez re-rattacher les agents dans la Console.

---

## Étape suivante

- [Enrôlement sur le domaine](enrolement.md)
- [Configuration et précédence](configuration.md)
- [Journaux et diagnostic](../exploitation/journaux.md)
