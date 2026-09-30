# Broker MQTT

Abls-Habitat utilise **deux bus MQTT distincts**. Les confondre est une source classique de
confusion.

| Bus | Où il tourne | Qui s'y connecte | Contenu |
|---|---|---|---|
| **MQTT API** | À côté de l'API | Tous les agents du domaine, l'API, les navigateurs | État des agents, visuels, historique |
| **MQTT local** | Sur le serveur **master** de chaque site | Les agents du site | Commandes `SET_DO/` et `SET_AO/` vers les sorties |

Le bus local reste fonctionnel même si la liaison vers l'API est coupée : les automatismes du
site continuent de fonctionner.

---

## Le bus MQTT local

Il est fourni par le paquet `abls-agent-server` sur le serveur master. Les agents en obtiennent
l'adresse (`master_hostname`) dans la réponse d'[enrôlement](../agents/enrolement.md) : aucune
configuration locale n'est nécessaire.

Port : `1883`, en clair, sur le réseau du site.

!!! warning "Ne pas exposer le bus local"
    Ce bus n'est pas authentifié. Il doit rester confiné au réseau local. N'ouvrez jamais le port
    1883 du master vers Internet.

Topics utiles pour le diagnostic :

```bash
mosquitto_sub -h <master> -t '#' -v
```

| Topic | Sens | Contenu |
|---|---|---|
| `SET_DO/<tech_id>/<numéro>` | D.L.S → agent | Consigne d'une sortie T.O.R |
| `SET_AO/<tech_id>/<numéro>` | D.L.S → agent | Consigne d'une sortie analogique |

---

## Le bus MQTT de l'API (socle auto-hébergé)

Seuls les administrateurs d'un socle auto-hébergé ont à l'installer.

### Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install mosquitto mosquitto-clients
    sudo systemctl enable --now mosquitto
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install mosquitto
    sudo systemctl enable --now mosquitto
    ```

### Comptes

Deux familles de comptes sont attendues :

| Compte | Utilisé par | Mot de passe |
|---|---|---|
| `api` | L'API elle-même | Clé `mqtt_password` de `/etc/abls-habitat-api.conf` |
| `<domain_uuid>-agent` | Les agents du domaine | Généré par l'API, transmis à l'enrôlement |

```bash
sudo mosquitto_passwd -c /etc/mosquitto/passwd api
```

```ini
# /etc/mosquitto/conf.d/abls.conf
listener 1883
allow_anonymous false
password_file /etc/mosquitto/passwd
```

!!! note "Les comptes agents sont gérés par l'API"
    Vous n'avez pas à créer manuellement les comptes `<domain_uuid>-agent` : l'API les provisionne
    et transmet leur mot de passe aux agents lors de l'enrôlement.

### WebSocket pour les interfaces web

La Console et Home s'abonnent au bus via WebSocket :

```ini
listener 9001
protocol websockets
```

Placez un reverse-proxy TLS devant ce port.

---

## Activer TLS

Côté API, dans `/etc/abls-habitat-api.conf` :

```json
{
  "mqtt_over_ssl":   true,
  "mqtt_port":       8883,
  "mqtt_ca_file":    "/etc/abls/ca-interne.pem",
  "mqtt_ssl_verify": true
}
```

Côté agent, si l'autorité de certification est privée, déclarez-la localement :

```json
{
  "mqtt_ca_file": "/etc/abls/ca-interne.pem"
}
```

Si `mqtt_ca_file` et `mqtt_ca_path` sont vides, l'agent cherche automatiquement le magasin
système de la distribution. Le détail des chemins explorés figure dans
[les paramètres communs](../agents/parametres-communs.md#mqtt-et-tls).

!!! danger "`mqtt_ssl_verify: false`"
    Désactiver la vérification du certificat expose la liaison aux attaques de type
    *man-in-the-middle*. À réserver strictement au développement.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| L'agent s'enrôle mais ne remonte aucun état | Connexion au bus API refusée : vérifier `mqtt_password` renvoyé par l'API et le pare-feu |
| L'agent apparaît « mort » dans la Console alors qu'il tourne | Le testament MQTT a été publié : la connexion au bus API a été coupée |
| Les sorties ne s'actionnent pas | Vérifier le bus **local** : `mosquitto_sub -h <master> -t 'SET_DO/#' -v` |
| `Unable to find CA` au démarrage | `mqtt_over_ssl` actif sans magasin CA trouvé : renseigner `mqtt_ca_file` |
| Erreur TLS *certificate verify failed* | Autorité privée non déclarée côté agent |
