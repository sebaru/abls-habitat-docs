# Agent IMSG

Messagerie instantanée **XMPP (Jabber)**. Envoie les notifications et reçoit les commandes
texte via un compte de messagerie.

---

## Rôle

- Diffuse les messages déclarés en D.L.S avec l'option `notif_chat`.
- Reçoit les commandes texte envoyées au compte et les transforme en entrées D.L.S.

C'est l'alternative gratuite au [SMS](sms.md) : pas de matériel, pas d'abonnement.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Compte | Un JID dédié au domaine, avec son mot de passe |
| Réseau | Accès sortant vers le serveur XMPP (5222/TCP, ou 5223 en TLS direct) |

!!! tip "Créez un compte dédié"
    N'utilisez pas votre compte personnel : l'agent reste connecté en permanence et publie
    des messages automatiques.

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-imsg
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-imsg
    ```

---

## Unité systemd

`abls-agent-imsg@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-imsg@IMSG_MAISON.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `jabber_id` | `ABLS_JABBER_ID` | `--jabber_id` | chaîne | JID du compte, par exemple `maison@exemple.org` |
| `jabber_password` | `ABLS_JABBER_PASSWORD` | `--jabber_password` | chaîne | Mot de passe du compte |

!!! note "Ces deux options s'écrivent avec un souligné"
    `--jabber_id` et `--jabber_password`, et non `--jabber-id`. C'est une exception parmi les
    options des agents.

---

## Enrôlement

```bash
sudo tee /etc/abls/abls-agent-imsg@IMSG_MAISON.conf >/dev/null <<'EOF'
{
  "agent_tech_id":   "IMSG_MAISON",
  "domain_uuid":     "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "domain_secret":   "votre-secret-ici",
  "api_url":         "api.abls-habitat.fr",
  "jabber_id":       "maison@exemple.org",
  "jabber_password": "mot-de-passe-du-compte"
}
EOF
sudo chown root:abls /etc/abls/abls-agent-imsg@IMSG_MAISON.conf
sudo chmod 0640      /etc/abls/abls-agent-imsg@IMSG_MAISON.conf

sudo systemctl enable --now abls-agent-imsg@IMSG_MAISON.service
```

---

## Qui reçoit les messages ?

Les destinataires sont les **utilisateurs du domaine** ayant renseigné leur JID dans leur profil
et demandé à être notifiés. Chacun doit également **accepter la demande de contact** émise par
le compte de l'agent.

!!! warning "L'acceptation du contact est indispensable"
    Sans acceptation mutuelle, le serveur XMPP refuse la délivrance des messages. C'est la
    cause la plus fréquente de « je ne reçois rien » alors que l'agent est connecté.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Connexion refusée | JID ou mot de passe incorrect, ou serveur exigeant TLS |
| Agent connecté mais personne ne reçoit rien | Demandes de contact non acceptées par les utilisateurs |
| Déconnexions répétées | Un autre client utilise le même JID avec la même ressource |
| Commandes texte ignorées | L'expéditeur n'est pas un utilisateur du domaine, ou son niveau d'habilitation est insuffisant |

```bash
sudo journalctl -u abls-agent-imsg@IMSG_MAISON.service -f
```

---

## Voir aussi

- [Connecteur XMPP côté technicien](../../../technicien/connecteurs/imsg.md)
- [Être notifié](../../../utilisateur/notifications.md)
