# Pré-requis

Avant toute installation, vérifiez que la machine cible remplit ces conditions.

---

## Systèmes d'exploitation supportés

Les agents sont construits, testés et publiés pour :

| Système | Versions | Architectures |
|---|---|---|
| Debian | Bookworm (12), Trixie (13) | `amd64`, `arm64`, `armhf` |
| Raspberry Pi OS | Basé Bookworm ou Trixie | `arm64`, `armhf` |
| Fedora | Server ou Workstation, 38 et supérieures | `x86_64`, `aarch64` |

!!! note "Autres distributions"
    Rien n'interdit de compiler les agents ailleurs (les sources sont sur
    [GitHub](https://github.com/sebaru?tab=repositories)), mais aucun paquet n'est publié et
    aucune assistance n'est assurée.

---

## Droits requis

- Un accès `root`, directement ou via `sudo`.
- `--save` et l'installation des paquets échouent sans `root`.

---

## Dimensionnement

Les agents sont légers. Les ordres de grandeur ci-dessous couvrent une installation domestique.

| Rôle de la machine | CPU | RAM | Disque |
|---|---|---|---|
| Agent simple (modbus, gpiod, ups…) | 1 cœur | 256 Mo | 1 Go |
| Serveur master (`abls-agent-server` + moteur D.L.S) | 2 cœurs | 1 Go | 4 Go |
| Socle auto-hébergé (API + MariaDB + MQTT) | 2 cœurs | 4 Go | 20 Go + croissance des archives |

!!! tip "Un Raspberry Pi 4 suffit"
    Un Raspberry Pi 4 (2 Go) fait tourner confortablement `abls-agent-server` et plusieurs agents
    pour un domaine domestique. Privilégiez un SSD USB plutôt qu'une carte SD pour la longévité.

---

## Réseau

### Flux sortants nécessaires (mode Cloud)

| Destination | Port | Protocole | Usage |
|---|---|---|---|
| `api.abls-habitat.fr` | 443 | HTTPS | Enrôlement et appels d'exécution |
| Broker MQTT de l'API | 1883 ou 8883 | MQTT / MQTT+TLS | Bus temps réel, adresse fournie par l'API |
| `pkgs.abls-habitat.fr` | 443 | HTTPS | Dépôt de paquets |

### Flux internes au site

| Source → destination | Port | Usage |
|---|---|---|
| Agents → serveur master | 1883 | Bus MQTT local |
| Agent Modbus → automates | 502 | Modbus TCP |
| Agent UPS → serveur NUT | 3493 | Interrogation onduleur |
| Agent Shelly → équipements | 80 | API HTTP des Shelly |

!!! warning "Horloge système"
    Les requêtes vers l'API sont signées avec un horodatage. Une horloge décalée de plusieurs
    minutes fait échouer l'enrôlement. Vérifiez que la synchronisation est active :

    ```bash
    timedatectl status
    ```

    Sur un Raspberry Pi sans pile RTC, assurez-vous que `systemd-timesyncd` ou `chrony` démarre
    avant les agents.

### Résolution DNS

Les agents résolvent `api_url` et `master_hostname` par DNS. Sur un site isolé, prévoyez des
entrées `/etc/hosts` cohérentes sur toutes les machines.

---

## Pré-requis matériels par technologie

| Agent | Matériel ou service requis |
|---|---|
| `modbus` | Automate Modbus TCP joignable (Wago 750-8xx, etc.) |
| `gpiod` | `/dev/gpiochip*` présent, `libgpiod` ≥ 2.0 |
| `phidget` | HUB Phidget branché en USB, pilote `libphidget22` |
| `audio` | Carte son avec PipeWire/WirePlumber, `gtts-cli` et `mpg123` |
| `sms` | Modem GSM géré par ModemManager, **ou** compte OVH SMS |
| `imsg` | Compte XMPP (JID + mot de passe) |
| `teleinfoedf` | Interface TIC sur port série (`/dev/ttyUSB0`) |
| `shelly` | Équipements Shelly sur le même réseau |
| `ups` | Serveur NUT (`upsd`) accessible |
| `meteo` | Jeton d'API Météo-Concept et code INSEE de la commune |

Le détail figure dans le [catalogue des agents](agents/catalogue/index.md).

---

## Compte et domaine

Avant de commencer, vous devez disposer :

- d'un compte sur [console.abls-habitat.fr](https://console.abls-habitat.fr) ;
- d'un **domaine** créé, dont vous êtes propriétaire (niveau 9) ;
- du `domain_uuid` et du `domain_secret` de ce domaine.

Voir [les habilitations](habilitations.md) pour la grille des niveaux d'accès.

---

## Liste de contrôle avant installation

- [ ] La distribution et l'architecture sont supportées
- [ ] L'accès `root` est disponible
- [ ] L'horloge est synchronisée
- [ ] Les flux réseau sortants sont ouverts
- [ ] Le matériel de la technologie visée est branché et reconnu
- [ ] Le domaine existe et ses identifiants sont en main

Tout est prêt : passez aux [dépôts de paquets](agents/depots.md).
