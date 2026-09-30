# Agent GPIOD

Pilote les **broches GPIO** d'une carte Linux (Raspberry Pi et compatibles) via `libgpiod`.

---

## Rôle

- Lit l'état des broches configurées en entrée et les publie sur le bus.
- Positionne les broches configurées en sortie sur réception d'une consigne `SET_DO/`.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | Carte exposant `/dev/gpiochip*` |
| Bibliothèque | `libgpiod` **version 2.0 ou supérieure** |
| Permissions | L'agent doit pouvoir ouvrir `/dev/gpiochip*` |

!!! danger "`libgpiod` 1.x n'est pas compatible"
    L'agent utilise l'API v2 de `libgpiod`. Sur une distribution ne fournissant que la 1.x,
    le paquet ne s'installera pas ou l'agent échouera à l'ouverture du contrôleur.
    Debian Bookworm et supérieures fournissent la 2.x.

Vérifier la présence du matériel :

```bash
ls -l /dev/gpiochip*
gpiodetect
gpioinfo
```

---

## Installation

```bash
sudo apt install abls-agent-gpiod
```

---

## Unité systemd

`abls-agent-gpiod@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-gpiod@GPIOD_PORTAIL.service
```

---

## Permissions d'accès aux GPIO

L'unité tourne en `DynamicUser` avec le groupe supplémentaire `abls`.
Sur Raspberry Pi OS, l'accès aux `gpiochip` est généralement réservé au groupe `gpio`.
Si l'agent échoue à l'ouverture, ajoutez une règle udev :

```bash
# /etc/udev/rules.d/60-abls-gpio.rules
SUBSYSTEM=="gpio", KERNEL=="gpiochip*", GROUP="abls", MODE="0660"
```

```bash
sudo udevadm control --reload-rules && sudo udevadm trigger
```

---

## Paramètres spécifiques

Aucune option de ligne de commande supplémentaire : l'agent découvre les contrôleurs présents et
reçoit la configuration de ses broches depuis l'API.

Le choix des broches, leur sens (entrée ou sortie) et leur mapping se font **depuis la Console**,
page [Agents GPIOD](https://console.abls-habitat.fr/agents/gpiod).

---

## Enrôlement

```bash
sudo abls-agent-gpiod --agent-tech-id GPIOD_PORTAIL \
                      --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                      --domain-secret 'votre-secret-ici' \
                      --api-url       api.abls-habitat.fr \
                      --save

sudo systemctl enable --now abls-agent-gpiod@GPIOD_PORTAIL.service
```

---

## Précautions de câblage

!!! danger "Les GPIO du Raspberry Pi sont en 3,3 V"
    Appliquer 5 V sur une broche détruit le SoC. Interposez systématiquement un optocoupleur ou
    un module relais isolé entre la carte et le monde extérieur.

!!! warning "État des sorties au démarrage"
    Entre la mise sous tension de la carte et le démarrage de l'agent, l'état des broches n'est
    pas maîtrisé. Câblez vos actionneurs de sorte que l'état par défaut soit l'état sûr.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| `Unable to open gpiochip` | Permissions : voir la règle udev ci-dessus |
| Aucun contrôleur détecté | `gpiodetect` ne renvoie rien : matériel ou noyau incompatible |
| Erreur de version de `libgpiod` | Distribution fournissant la 1.x ; monter en version |
| Une broche lue reste figée | Broche déjà réservée par un autre processus (`gpioinfo` indique `used`) |
| Rebonds sur une entrée | Filtrage à faire côté D.L.S avec une [temporisation](../../../technicien/dls/objets/tempos.md) |

```bash
sudo journalctl -u abls-agent-gpiod@GPIOD_PORTAIL.service -f
```

---

## Voir aussi

- [I/O GPIO côté technicien](../../../technicien/connecteurs/gpiod.md)
