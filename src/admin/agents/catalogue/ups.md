# Agent UPS

Surveille un **onduleur** via un serveur NUT (*Network UPS Tools*).

---

## Rôle

- Relève l'état de l'onduleur : présence secteur, charge de la batterie, autonomie estimée,
  puissance, tension.
- Permet au D.L.S de réagir à une coupure secteur (délestage, alerte, arrêt propre).

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | Onduleur supporté par NUT, raccordé en USB ou en réseau |
| Service | Un serveur NUT (`upsd`) en fonctionnement |
| Réseau | Port **3493/TCP** joignable depuis la machine portant l'agent |

!!! note "L'agent n'est pas un pilote d'onduleur"
    Il ne parle pas directement à l'onduleur : il interroge `upsd`. C'est NUT qui porte le
    pilote et la configuration matérielle.

---

## Mettre en place NUT

```bash
sudo apt install nut nut-server nut-client
```

```ini
# /etc/nut/ups.conf
[onduleur]
  driver = usbhid-ups
  port = auto
  desc = "Onduleur baie"
```

```ini
# /etc/nut/upsd.conf
LISTEN 0.0.0.0 3493
```

```ini
# /etc/nut/upsd.users
[abls]
  password = un-mot-de-passe
  upsmon slave
```

```bash
sudo systemctl enable --now nut-server
upsc onduleur@localhost      # doit afficher les variables de l'onduleur
```

!!! warning "N'exposez pas `upsd` au-delà du réseau local"
    Le protocole NUT n'est pas chiffré. Restreignez l'écoute au réseau de confiance.

---

## Installation de l'agent

```bash
sudo apt install abls-agent-ups
```

---

## Unité systemd

`abls-agent-ups@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-ups@UPS_BAIE.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `host` | `ABLS_HOST` | `--host` | chaîne | Adresse du serveur NUT |
| `name` | `ABLS_NAME` | `--name` | chaîne | Nom de l'onduleur dans `ups.conf` |
| `admin_username` | `ABLS_ADMIN_USERNAME` | `--admin-username` | chaîne | Utilisateur NUT (facultatif) |
| `admin_password` | `ABLS_ADMIN_PASSWORD` | `--admin-password` | chaîne | Mot de passe NUT (facultatif) |

Le `name` est le nom de section déclaré dans `/etc/nut/ups.conf` — ici `onduleur`.
Il n'a aucun rapport avec le `agent_tech_id`.

---

## Enrôlement

```bash
sudo abls-agent-ups --agent-tech-id UPS_BAIE \
                    --host  127.0.0.1 \
                    --name  onduleur \
                    --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                    --domain-secret 'votre-secret-ici' \
                    --api-url       api.abls-habitat.fr \
                    --save

sudo systemctl enable --now abls-agent-ups@UPS_BAIE.service
```

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Connexion refusée | `upsd` non démarré, ou `LISTEN` limité à `127.0.0.1` alors que l'agent est distant |
| `Unknown UPS` | Le `name` ne correspond à aucune section de `/etc/nut/ups.conf` |
| Aucune variable remontée | Tester d'abord `upsc <name>@<host>` : si cela échoue, le problème est dans NUT |
| Accès refusé | Renseigner `admin_username` et `admin_password` |
| Autonomie fantaisiste | Batterie vieillissante ou non calibrée ; relève de l'onduleur |

```bash
sudo journalctl -u abls-agent-ups@UPS_BAIE.service -f
upsc onduleur@127.0.0.1
```

---

## Voir aussi

- [Connecteur UPS côté technicien](../../../technicien/connecteurs/ups.md)
