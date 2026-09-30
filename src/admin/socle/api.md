# Installer et configurer l'API

L'**API** est le cœur du socle : elle détient la configuration du domaine, la base de données,
l'historique, et c'est auprès d'elle que les agents s'[enrôlent](../agents/enrolement.md).

!!! tip "Vous utilisez le Cloud du projet ?"
    Cette page ne vous concerne pas. `api.abls-habitat.fr` est déjà en service ; passez
    directement aux [dépôts de paquets](../agents/depots.md).

---

## Composants requis

| Composant | Rôle | Page |
|---|---|---|
| MariaDB | Données de configuration et archives | [Base de données](base-de-donnees.md) |
| Mosquitto | Bus MQTT entre l'API et les agents | [Broker MQTT](mqtt.md) |
| Keycloak (ou compatible OIDC) | Authentification des utilisateurs | ci-dessous |
| Memcached | Cache de session | ci-dessous |
| Apache httpd | Service des interfaces Console et Home | [Console et Home](console-home.md) |

---

## Configuration : sources et précédence

L'API partage le mécanisme de configuration des agents. Les trois sources sont appliquées
**dans l'ordre ENV → FILE → ARGV**, chacune écrasant la précédente :

**précédence effective : ARGV > FILE > ENV > valeurs par défaut**

| Source | Exemple |
|---|---|
| ENV | `ABLS_DB_HOSTNAME=db.interne.lan` |
| FILE | `/etc/abls-habitat-api.conf` |
| ARGV | `--db-hostname db.interne.lan` |

Toute variable `ABLS_<CLÉ>` alimente la clé `<clé>` en minuscules : `ABLS_MQTT_PORT` alimente
`mqtt_port`. Les valeurs `TRUE`/`FALSE` deviennent des booléens, les entiers stricts des entiers,
le reste des chaînes.

Le chemin du fichier est lui-même paramétrable via `ABLS_CONFIG_FILE`, lue avant l'ouverture du
fichier :

```bash
ABLS_CONFIG_FILE=/opt/recette/abls-habitat-api.conf abls-habitat-api
```

Voir [Configuration et précédence](../agents/configuration.md) pour le détail du mécanisme,
identique à celui des agents.

---

## Référence de configuration (`abls-habitat-api.conf`)

Le fichier de configuration de l'API est un fichier **JSON** situé à :

    /etc/abls-habitat-api.conf

Il est lu au démarrage du service `abls-habitat-api`. Toute modification nécessite un redémarrage du service.

---

## Exemple complet

```json
{ "db_hostname":        "mysgbd.example.com",
  "db_password":        "myrootpassword",
  "db_port":            3306,
  "db_arch_hostname":   "myarchive.example.com",
  "db_arch_port":       3306,
  "home_url":           "https://myhome.example.com",
  "console_url":        "https://myconsole.example.com",
  "api_url":            "https://myapi.example.com",
  "api_local_port":     5562,
  "static_data_url":    "http://static.example.com",
  "idp_realm":          "myrealm",
  "idp_url":            "https://idp.example.com",
  "idp_token_check":    true,
  "memcached_options":  "--SERVER=localhost:11211",
  "mqtt_hostname":      "mymqtt.example.com",
  "mqtt_port":          1883,
  "mqtt_over_ssl":      false,
  "mqtt_ca_file":       "",
  "mqtt_ca_path":       "",
  "mqtt_ssl_verify":    true,
  "mqtt_password":      "MQTT_PASSWORD",
  "mqtt_qos":           1,
  "allow_origin":       "*",
  "log_level":          6
}
```

---

## Référence des paramètres

### Base de données principale

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `db_hostname` | string | `localhost` | Hôte du serveur MariaDB/MySQL principal |
| `db_password` | string | `changeme` | Mot de passe de la base de données |
| `db_port` | integer | `3306` | Port du serveur de base de données |

### Base de données d'archivage

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `db_arch_hostname` | string | *(idem `db_hostname`)* | Hôte du serveur d'archivage (peut être le même que le principal) |
| `db_arch_port` | integer | *(idem `db_port`)* | Port du serveur d'archivage |

!!! info
    Si `db_arch_hostname` et `db_arch_port` sont identiques à `db_hostname` et `db_port`, l'API utilise une seule connexion pour les deux rôles.

---

### URLs frontaux

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `home_url` | string | `https://localhost` | URL publique de l'interface Home |
| `console_url` | string | `https://localhost` | URL publique de la console d'administration |
| `api_url` | string | — | URL publique de l'API elle-même (transmise aux agents) |
| `api_local_port` | integer | `5562` | Port d'écoute local de l'API |
| `static_data_url` | string | `https://static.abls-habitat.fr` | URL du serveur de ressources statiques (icones, inventaire…) |

---

### Identity Provider (IDP / Keycloak)

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `idp_url` | string | `https://idp.abls-habitat.fr` | URL de base du serveur Keycloak |
| `idp_realm` | string | `Abls-Habitat` | Nom du realm Keycloak utilisé pour l'authentification |
| `idp_token_check` | boolean | `true` | Vérifie la signature de l'access token. Si `false`, l'API accepte le token sans contrôle de validité |

L'API valide le champ `iss` des tokens JWT en vérifiant qu'il commence par `idp_url`.

!!! warning "idp_token_check: false"
    Désactiver cette vérification revient à faire confiance à tout JWT bien formé transmis à l'API. Réservez ce mode aux environnements de développement, de test ou à un proxy d'authentification de confiance placé en amont.

---

### Broker MQTT

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `mqtt_hostname` | string | `localhost` | Hôte du broker MQTT (Mosquitto) |
| `mqtt_port` | integer | `1883` | Port du broker MQTT |
| `mqtt_password` | string | `changeme` | Mot de passe de connexion MQTT (utilisateur `api`) |
| `mqtt_qos` | integer | `1` | Niveau de qualité de service MQTT (0, 1 ou 2) |
| `mqtt_over_ssl` | boolean | `false` | Active la connexion TLS vers le broker MQTT |

---

### MQTT TLS

Ces paramètres ne sont utilisés que si `mqtt_over_ssl` est `true`.

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `mqtt_ca_file` | string | `""` | Chemin absolu vers le fichier PEM du CA pour valider le certificat TLS du broker. Si vide, détection automatique du CA système. |
| `mqtt_ca_path` | string | `""` | Chemin absolu vers le répertoire CA. Si vide, détection automatique du CA système. |
| `mqtt_ssl_verify` | boolean | `true` | Vérifie le certificat du serveur MQTT. Mettre à `false` uniquement en développement. |

!!! info "Détection automatique du CA système"
    Si `mqtt_ca_file` et `mqtt_ca_path` sont tous les deux vides, l'API tente de trouver automatiquement le CA système dans les chemins suivants, dans cet ordre :

    **Fichiers CA :**

    - `/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem` (Fedora/RHEL)
    - `/etc/ssl/certs/ca-certificates.crt` (Debian/Ubuntu)
    - `/etc/ssl/certs/ca-bundle.crt`

    **Répertoires CA :**

    - `/etc/pki/tls/certs` (Fedora/RHEL)
    - `/etc/ssl/certs` (Debian/Ubuntu)

    Si aucun n'est trouvé et que `mqtt_over_ssl` est `true`, le démarrage de l'API échoue.

!!! warning "mqtt_ssl_verify: false"
    Désactiver la vérification du certificat expose la connexion aux attaques de type *man-in-the-middle*. Réservé aux environnements de développement.

---

### Divers

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `allow_origin` | string | `*` | Valeur de l'en-tête HTTP `Access-Control-Allow-Origin`. Restreindre en production. |
| `memcached_options` | string | `*` | Options de connexion à Memcached (ex: `--SERVER=localhost:11211`) |
| `log_level` | integer | `6` | Niveau de log syslog (0 = urgence … 7 = debug). `6` = informationnel. |

---

## Démarrage et vérification

```bash
sudo systemctl enable --now abls-habitat-api.service
sudo journalctl -u abls-habitat-api.service -f
```

Contrôle de bon fonctionnement :

```bash
curl -sS https://votre-api.example.com/status
```

---

## Pointer les agents vers votre API

Sur chaque machine portant un agent, renseignez `api_url` :

```bash
sudo abls-agent-modbus --agent-tech-id MODBUS_CHAUFFERIE \
                       --api-url votre-api.example.com \
                       --domain-uuid ... --domain-secret ... --save
```

!!! warning "Certificat TLS"
    Les agents valident le certificat de l'API avec le magasin système. Si vous utilisez une
    autorité privée, installez-la dans le magasin de chaque machine agent
    (`update-ca-certificates` ou `update-ca-trust`).

---

## Pour aller plus loin

- [Base de données](base-de-donnees.md)
- [Broker MQTT](mqtt.md)
- [Console et Home](console-home.md)
