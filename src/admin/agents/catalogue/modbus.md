# Agent MODBUS

Client **Modbus TCP**. Interroge un automate (Wago 750-8xx et compatibles) et expose ses
entrées/sorties au domaine.

---

## Rôle

- Lit cycliquement les entrées T.O.R et analogiques de l'automate.
- Écrit les sorties sur réception d'une consigne `SET_DO/` ou `SET_AO/`.
- Entretient un **watchdog** côté automate : si l'agent cesse de le rafraîchir, l'automate
  bascule de lui-même en position de repli.

**Une instance par automate.**

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | Automate Modbus TCP joignable |
| Réseau | Port **502/TCP** ouvert vers l'automate |
| Adressage | Adresse IP fixe de l'automate (bail DHCP statique au minimum) |

!!! warning "Ne mettez pas l'automate sur une adresse dynamique"
    Un changement d'IP coupe silencieusement la liaison. Figez l'adresse côté automate ou côté
    serveur DHCP.

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-modbus
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-modbus
    ```

---

## Unité systemd

`abls-agent-modbus@.service` — unité **templatée**. L'instance est le `tech_id`.

```bash
sudo systemctl enable --now abls-agent-modbus@MODBUS_CHAUFFERIE.service
```

Plusieurs automates sur la même machine :

```bash
sudo systemctl enable --now abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo systemctl enable --now abls-agent-modbus@MODBUS_GARAGE.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `hostname` | `ABLS_HOSTNAME` | `--hostname` | chaîne | Adresse IP ou nom de l'automate |
| `description` | `ABLS_DESCRIPTION` | `--description` | chaîne | Libellé affiché dans la Console |
| `watchdog` | `ABLS_WATCHDOG` | `--watchdog` | entier | Délai de sécurité, en **dixièmes de seconde** |

!!! warning "`watchdog` s'exprime en 1/10 de seconde"
    `--watchdog 50` vaut 5 secondes, pas 50. Une valeur trop faible provoque des replis
    intempestifs de l'automate ; une valeur trop élevée retarde la mise en sécurité.

---

## Enrôlement

```bash
sudo abls-agent-modbus --agent-tech-id MODBUS_CHAUFFERIE \
                       --hostname      192.168.1.50 \
                       --description   "Automate chaufferie" \
                       --watchdog      50 \
                       --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                       --domain-secret 'votre-secret-ici' \
                       --api-url       api.abls-habitat.fr \
                       --save

sudo systemctl enable --now abls-agent-modbus@MODBUS_CHAUFFERIE.service
```

---

## Première mise en service

Démarrez en [`--dry-run`](../parametres-communs.md#fonctionnement-du-moteur) : l'agent lit les
entrées et les publie, mais n'actionne aucune sortie. Vous pouvez valider le câblage et le
mapping sans risque avant de basculer en mode réel.

```bash
sudo systemctl stop abls-agent-modbus@MODBUS_CHAUFFERIE.service
sudo -u abls abls-agent-modbus --agent-tech-id MODBUS_CHAUFFERIE --dry-run
```

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Aucune donnée ne remonte | `ping` l'automate, puis tester le port : `nc -vz 192.168.1.50 502` |
| Connexion qui se coupe périodiquement | Automate limitant le nombre de connexions simultanées ; vérifier qu'un seul agent l'interroge |
| L'automate retombe en repli régulièrement | `watchdog` trop court, ou réseau instable |
| Les sorties ne bougent pas | Vérifier `SET_DO/<tech_id>/#` sur le bus local, et que `dry_run` est inactif |
| Valeurs analogiques aberrantes | Problème d'échelle ou de type : relève du [mapping](../../../technicien/connecteurs/modbus.md) |

```bash
sudo journalctl -u abls-agent-modbus@MODBUS_CHAUFFERIE.service -f
```

---

## Voir aussi

- [I/O Modbus côté technicien](../../../technicien/connecteurs/modbus.md)
- [Configuration et précédence](../configuration.md)
