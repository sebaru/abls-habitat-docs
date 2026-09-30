# Catalogue des agents

Une page par classe d'agent, sur un gabarit commun : rôle, pré-requis matériels, paquet, unité
systemd, paramètres spécifiques et dépannage.

!!! note "Ce que vous ne trouverez pas ici"
    Les **I/O exposées** par chaque technologie et la façon de les mapper vers des mnémoniques
    relèvent du technicien : voir [Connecteurs et I/O](../../../technicien/connecteurs/index.md).

    Cette section ne traite que de l'installation et de la configuration système.

---

## Vue d'ensemble

| Classe | Paquet | Unité systemd | Technologie |
|---|---|---|---|
| [server](server.md) | `abls-agent-server` | `abls-agent-server.service` | Superviseur local, moteur D.L.S |
| [dls](dls.md) | `abls-agent-dls` | `abls-agent-dls.service` | Moteur D.L.S autonome |
| [modbus](modbus.md) | `abls-agent-modbus` | `abls-agent-modbus@.service` | Modbus TCP |
| [gpiod](gpiod.md) | `abls-agent-gpiod` | `abls-agent-gpiod@.service` | GPIO Linux |
| [phidget](phidget.md) | `abls-agent-phidget` | `abls-agent-phidget@.service` | Modules Phidget |
| [audio](audio.md) | `abls-agent-audio` | `abls-agent-audio@.service` (utilisateur) | Synthèse vocale et sons |
| [sms](sms.md) | `abls-agent-sms` | `abls-agent-sms@.service` | SMS (modem GSM ou OVH) |
| [imsg](imsg.md) | `abls-agent-imsg` | `abls-agent-imsg@.service` | Messagerie XMPP |
| [teleinfoedf](teleinfoedf.md) | `abls-agent-teleinfoedf` | `abls-agent-teleinfoedf@.service` | Téléinformation E.D.F |
| [shelly](shelly.md) | `abls-agent-shelly` | `abls-agent-shelly@.service` | Équipements Shelly |
| [ups](ups.md) | `abls-agent-ups` | `abls-agent-ups@.service` | Onduleur via NUT |
| [meteo](meteo.md) | `abls-agent-meteo` | `abls-agent-meteo@.service` | Prévisions Météo-Concept |

---

## Ce qui est commun à toutes les classes

Avant de consulter une page particulière, sachez que **tous** les agents partagent :

- les mêmes [dépôts de paquets](../depots.md) ;
- la même procédure d'[enrôlement](../enrolement.md) ;
- le même [mécanisme de configuration et la même précédence](../configuration.md) ;
- les mêmes [paramètres communs](../parametres-communs.md).

Les pages de ce catalogue ne décrivent donc que ce qui **s'ajoute** à ce socle commun.

---

## Connaître les options d'une classe

L'aide générée par le binaire fait toujours foi :

```bash
abls-agent-modbus --help
```

Elle liste les options communes et les options spécifiques à la classe.
