# Agent SHELLY

Interroge les équipements **Shelly** (Pro EM50, Pro 3EM, relais…) par leur API HTTP locale.

---

## Rôle

- Relève périodiquement les mesures d'un équipement Shelly : puissance, énergie, tension,
  intensité, état des relais.
- Publie ces grandeurs au domaine.

**Une instance par équipement Shelly.**

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | Équipement Shelly sur le réseau local |
| Réseau | Port **80/TCP** joignable depuis la machine portant l'agent |
| Adressage | Adresse IP fixe de l'équipement |

!!! warning "Figez l'adresse IP du Shelly"
    Les Shelly obtiennent par défaut leur adresse en DHCP. Réservez-leur un bail statique, sinon
    la liaison se coupe silencieusement au renouvellement.

!!! tip "Désactivez le Cloud Shelly"
    Si vous supervisez l'équipement depuis Abls-Habitat, la remontée vers le cloud du fabricant
    est superflue. La désactiver réduit la surface d'exposition.

Vérifier la joignabilité :

```bash
curl -sS http://192.168.1.70/shelly
```

---

## Installation

```bash
sudo apt install abls-agent-shelly
```

---

## Unité systemd

`abls-agent-shelly@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-shelly@SHELLY_COMPTEUR.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `string_id` | `ABLS_STRING_ID` | `--string-id` | chaîne | Identifiant de l'équipement Shelly |

Le `string_id` est l'identifiant renvoyé par l'équipement lui-même :

```bash
curl -sS http://192.168.1.70/shelly | grep -o '"id":"[^"]*"'
```

---

## Enrôlement

```bash
sudo abls-agent-shelly --agent-tech-id SHELLY_COMPTEUR \
                       --string-id     shellypro3em-xxxxxxxxxxxx \
                       --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                       --domain-secret 'votre-secret-ici' \
                       --api-url       api.abls-habitat.fr \
                       --save

sudo systemctl enable --now abls-agent-shelly@SHELLY_COMPTEUR.service
```

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Aucune donnée | Tester `curl http://<ip>/shelly` depuis la machine portant l'agent |
| Données qui s'arrêtent après quelques jours | Bail DHCP renouvelé avec une nouvelle adresse |
| Équipement injoignable par intermittence | Couverture Wi-Fi insuffisante ; rapprocher le point d'accès ou passer en Ethernet |
| Authentification refusée | Protection par mot de passe activée sur le Shelly : la désactiver sur le réseau local |
| Valeurs de puissance négatives | Normal sur un Pro 3EM en cas d'injection (production photovoltaïque) |

```bash
sudo journalctl -u abls-agent-shelly@SHELLY_COMPTEUR.service -f
```

---

## Voir aussi

- [Connecteur Shelly côté technicien](../../../technicien/connecteurs/shelly.md)
