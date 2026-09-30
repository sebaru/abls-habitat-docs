# Agent TELEINFOEDF

Lit la **téléinformation client (TIC)** d'un compteur électrique français et publie les grandeurs
de consommation.

---

## Rôle

- Décode en continu la trame série émise par le compteur.
- Publie les index, la puissance apparente, l'intensité, la tension, la période tarifaire.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | Interface TIC (optocoupleur) reliée aux bornes I1/I2 du compteur |
| Port | Un périphérique série, typiquement `/dev/ttyUSB0` |
| Permissions | L'agent doit pouvoir ouvrir le port série |

!!! warning "Les bornes I1/I2 ne sont pas dangereuses, le tableau l'est"
    Le signal TIC est en très basse tension, mais il se raccorde dans un tableau électrique.
    Faites intervenir une personne habilitée.

Vérifier la présence du port :

```bash
ls -l /dev/ttyUSB*
dmesg | grep -i tty
```

---

## Installation

```bash
sudo apt install abls-agent-teleinfoedf
```

---

## Unité systemd

`abls-agent-teleinfoedf@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-teleinfoedf@TIC_COMPTEUR.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `port` | `ABLS_PORT` | `--port` | chaîne | Périphérique série, par exemple `/dev/ttyUSB0` |
| `standard` | `ABLS_STANDARD` | `--standard` | booléen | `true` = mode **standard**, `false` = mode **historique** |

!!! danger "Le mode conditionne tout le décodage"
    Un compteur Linky configuré en mode *standard* émet à 9600 bauds avec un jeu d'étiquettes
    différent du mode *historique* (1200 bauds). Se tromper de mode donne une trame illisible et
    aucune donnée.

    Les compteurs électromécaniques et les Linky non reparamétrés sont en mode **historique**.

---

## Fiabiliser le nom du port

`/dev/ttyUSB0` peut changer de numéro au redémarrage si plusieurs adaptateurs USB sont présents.
Utilisez un chemin stable :

```bash
ls -l /dev/serial/by-id/
```

```json
{ "port": "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A50285BI-if00-port0" }
```

---

## Permissions

Ajoutez le groupe `abls` aux ports série, ou posez une règle udev :

```bash
# /etc/udev/rules.d/60-abls-tic.rules
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", GROUP="abls", MODE="0660"
```

---

## Enrôlement

```bash
sudo abls-agent-teleinfoedf --agent-tech-id TIC_COMPTEUR \
                            --port     /dev/ttyUSB0 \
                            --standard \
                            --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                            --domain-secret 'votre-secret-ici' \
                            --api-url       api.abls-habitat.fr \
                            --save

sudo systemctl enable --now abls-agent-teleinfoedf@TIC_COMPTEUR.service
```

Pour le mode historique, retirez `--standard` et vérifiez que la clé n'est pas restée à `true`
dans le fichier de configuration (un drapeau ne sait pas repasser à `false`).

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Aucune trame lue | Polarité I1/I2 inversée, ou interface non alimentée |
| Trames illisibles, caractères parasites | Mauvais mode : basculer `standard` |
| Le port disparaît après redémarrage | Utiliser `/dev/serial/by-id/` |
| Permission refusée sur `/dev/ttyUSB0` | Règle udev manquante |
| Index cohérents mais puissance à zéro | Étiquette absente en mode historique : c'est normal sur certains compteurs |

```bash
sudo journalctl -u abls-agent-teleinfoedf@TIC_COMPTEUR.service -f
```

Lire la trame brute pour lever le doute sur le mode :

```bash
sudo systemctl stop abls-agent-teleinfoedf@TIC_COMPTEUR.service
stty -F /dev/ttyUSB0 1200 cs7 parenb -parodd && cat /dev/ttyUSB0   # historique
stty -F /dev/ttyUSB0 9600 cs7 parenb -parodd && cat /dev/ttyUSB0   # standard
```

---

## Voir aussi

- [Connecteur Téléinfo côté technicien](../../../technicien/connecteurs/teleinfoedf.md)
