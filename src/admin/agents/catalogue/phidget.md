# Agent PHIDGET

Pilote les modules **Phidget** (HUB, capteurs et actionneurs USB ou réseau) via `libphidget22`.

---

## Rôle

- Expose les entrées et sorties, T.O.R et analogiques, des modules Phidget raccordés à un HUB.
- Gère aussi bien les HUB branchés en USB que les HUB réseau (VINT Network Hub).

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | HUB Phidget (HUB0000, HUB5000…) et ses capteurs |
| Bibliothèque | `libphidget22` |
| Permissions | Accès au périphérique USB, ou accès réseau au HUB |

Vérifier la détection :

```bash
lsusb | grep -i phidget
```

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-phidget
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-phidget
    ```

---

## Unité systemd

`abls-agent-phidget@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-phidget@PHIDGET_ATELIER.service
```

---

## Paramètres spécifiques

Ces paramètres concernent les **HUB réseau**. Un HUB branché en USB local n'en a pas besoin.

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `hostname` | `ABLS_HOSTNAME` | `--hostname` | chaîne | Adresse du HUB réseau |
| `password` | `ABLS_PASSWORD` | `--password` | chaîne | Mot de passe du HUB réseau |
| `description` | `ABLS_DESCRIPTION` | `--description` | chaîne | Libellé affiché dans la Console |
| `serial` | `ABLS_SERIAL` | `--serial` | entier | Numéro de série du HUB |

!!! tip "Renseignez toujours le numéro de série"
    Sur une machine portant plusieurs HUB, le numéro de série est le seul moyen fiable
    d'attacher une instance d'agent à un HUB donné. Sans lui, l'attribution dépend de l'ordre
    d'énumération USB et peut changer à chaque démarrage.

---

## Permissions USB

L'accès aux périphériques Phidget en USB nécessite généralement une règle udev :

```bash
# /etc/udev/rules.d/99-libphidget22.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="06c2", MODE="0660", GROUP="abls"
```

```bash
sudo udevadm control --reload-rules && sudo udevadm trigger
```

---

## Enrôlement

=== "HUB USB local"

    ```bash
    sudo abls-agent-phidget --agent-tech-id PHIDGET_ATELIER \
                            --serial        123456 \
                            --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                            --domain-secret 'votre-secret-ici' \
                            --api-url       api.abls-habitat.fr \
                            --save
    ```

=== "HUB réseau"

    ```bash
    sudo abls-agent-phidget --agent-tech-id PHIDGET_ATELIER \
                            --hostname      192.168.1.60 \
                            --password      'mot-de-passe-hub' \
                            --serial        123456 \
                            --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                            --domain-secret 'votre-secret-ici' \
                            --api-url       api.abls-habitat.fr \
                            --save
    ```

```bash
sudo systemctl enable --now abls-agent-phidget@PHIDGET_ATELIER.service
```

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Aucun module détecté en USB | Vérifier `lsusb` et la règle udev |
| HUB réseau injoignable | Contrôler l'adresse, le mot de passe et l'activation du serveur sur le HUB |
| Les canaux changent d'affectation après redémarrage | Renseigner `serial` |
| Valeurs analogiques bruitées | Capteur mal alimenté ou câble trop long ; lisser côté D.L.S |

```bash
sudo journalctl -u abls-agent-phidget@PHIDGET_ATELIER.service -f
```

---

## Voir aussi

- [I/O Phidget côté technicien](../../../technicien/connecteurs/phidget.md)
