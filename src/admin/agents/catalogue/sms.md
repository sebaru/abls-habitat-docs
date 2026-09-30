# Agent SMS

Envoie et reçoit des **SMS**, soit par un modem GSM local, soit par l'API SMS d'OVH.

---

## Rôle

- Envoie les notifications déclarées en D.L.S avec l'option `notif_sms`.
- Reçoit les **commandes texte** envoyées par les utilisateurs et les transforme en entrées
  D.L.S (option `map_sms`).

---

## Deux modes de fonctionnement

=== "Modem GSM local"

    | Élément | Exigence |
    |---|---|
    | Matériel | Clé ou module GSM avec carte SIM active |
    | Logiciel | `ModemManager` |
    | Accès | D-Bus système |

    ```bash
    sudo apt install modemmanager
    mmcli -L        # le modem doit apparaître
    ```

=== "Passerelle OVH"

    | Élément | Exigence |
    |---|---|
    | Compte | Service SMS OVH actif et crédité |
    | Identifiants | Clés d'application et clé consommateur, créées sur le portail OVH |
    | Réseau | Accès HTTPS sortant vers l'API OVH |

    Pas de matériel requis, mais pas de réception de commandes entrantes.

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-sms
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-sms
    ```

---

## Unité systemd

`abls-agent-sms@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-sms@SMS_MAISON.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `ovh_service_name` | `ABLS_OVH_SERVICE_NAME` | `--ovh-service-name` | chaîne | Nom du service SMS OVH |
| `ovh_application_key` | `ABLS_OVH_APPLICATION_KEY` | `--ovh-application-key` | chaîne | Clé d'application OVH |
| `ovh_application_secret` | `ABLS_OVH_APPLICATION_SECRET` | `--ovh-application-secret` | chaîne | Secret d'application OVH |
| `ovh_consumer_key` | `ABLS_OVH_CONSUMER_KEY` | `--ovh-consumer-key` | chaîne | Clé consommateur OVH |
| `read_interval` | `ABLS_READ_INTERVAL` | `--read-interval` | entier | Période d'interrogation du modem, en **dixièmes de seconde** |

!!! danger "Les clés OVH sont des secrets"
    Ne les passez pas en ligne de commande sur une machine partagée : elles seraient visibles
    dans `ps`. Écrivez-les directement dans le fichier de configuration en `0640`.

---

## Enrôlement

=== "Modem GSM local"

    ```bash
    sudo abls-agent-sms --agent-tech-id SMS_MAISON \
                        --read-interval 50 \
                        --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                        --domain-secret 'votre-secret-ici' \
                        --api-url       api.abls-habitat.fr \
                        --save
    ```

=== "Passerelle OVH"

    ```bash
    sudo tee /etc/abls/abls-agent-sms@SMS_MAISON.conf >/dev/null <<'EOF'
    {
      "agent_tech_id":          "SMS_MAISON",
      "domain_uuid":            "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "domain_secret":          "votre-secret-ici",
      "api_url":                "api.abls-habitat.fr",
      "ovh_service_name":       "sms-xx12345-1",
      "ovh_application_key":    "...",
      "ovh_application_secret": "...",
      "ovh_consumer_key":       "..."
    }
    EOF
    sudo chown root:abls /etc/abls/abls-agent-sms@SMS_MAISON.conf
    sudo chmod 0640      /etc/abls/abls-agent-sms@SMS_MAISON.conf
    ```

```bash
sudo systemctl enable --now abls-agent-sms@SMS_MAISON.service
```

---

## Qui reçoit les SMS ?

Les destinataires ne se configurent pas ici : ce sont les **utilisateurs du domaine** ayant
renseigné leur numéro de téléphone et demandé à être notifiés.
Voir [Être notifié](../../../utilisateur/notifications.md).

De même, les **commandes texte** acceptées sont définies en D.L.S par les objets portant
l'option `map_sms`, et les droits d'émission dépendent du niveau d'habilitation de
l'utilisateur.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| `mmcli -L` ne voit pas le modem | Câble, alimentation, ou modem non supporté par ModemManager |
| Modem détecté mais SMS non envoyés | Carte SIM verrouillée par un code PIN, ou crédit épuisé |
| Réception très lente | `read_interval` trop élevé (rappel : en dixièmes de seconde) |
| Erreur d'authentification OVH | Clés incorrectes, ou droits insuffisants sur l'application OVH |
| Aucun SMS reçu par les utilisateurs | Numéros non renseignés, ou notification non demandée dans le profil |

```bash
sudo journalctl -u abls-agent-sms@SMS_MAISON.service -f
```

---

## Voir aussi

- [Connecteur SMS côté technicien](../../../technicien/connecteurs/sms.md)
- [Commander par SMS](../../../utilisateur/commandes-sms.md)
