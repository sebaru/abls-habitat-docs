# Référence de configuration — Agent (`abls-habitat-agent.conf`)

Le fichier de configuration de l'agent est un fichier **JSON** situé à :

    /etc/abls-habitat-agent.conf

Il est créé automatiquement lors de la commande `Watchdogd --save ...`.
Vous pouvez aussi l'éditer manuellement pour y ajouter des options non accessibles via la ligne de commande (MQTT TLS, etc.).

---

## Exemple complet

```json
{ "domain_uuid":   "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "domain_secret": "yoursecrethere",
  "agent_uuid":    "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "api_url":       "api.abls-habitat.fr",
  "mqtt_ca_file":  "",
  "mqtt_ca_path":  ""
}
```

---

## Référence des paramètres

### Paramètres obligatoires

| Clé | Type | Description |
|---|---|---|
| `domain_uuid` | string | Identifiant unique du domaine Abls-Habitat |
| `domain_secret` | string | Clé secrète du domaine (ne jamais partager) |

!!! danger "Confidentialité"
    Le `domain_secret` permet à n'importe quel processus de s'authentifier auprès de l'API au nom de votre domaine. Ne le communiquez jamais.

---

### Paramètres optionnels

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `agent_uuid` | string | auto-généré | UUID de cet agent. Utile pour restaurer un agent existant.|
| `api_url` | string | `api.abls-habitat.fr` | URL de l'API principale. Utile pour une installation OnPremise. |

---

### Paramètres MQTT TLS

Ces paramètres ne sont utilisés que lorsque la connexion MQTT vers l'API est configurée en SSL (`mqtt_over_ssl: true` côté API).

| Clé | Type | Défaut | Description |
|---|---|---|---|
| `mqtt_ca_file` | string | `""` | Chemin absolu vers le fichier PEM du CA utilisé pour valider le certificat TLS du broker MQTT. Si vide, l'agent recherche automatiquement un bundle CA système. |
| `mqtt_ca_path` | string | `""` | Chemin absolu vers le répertoire contenant les certificats CA. Si vide, l'agent recherche automatiquement un répertoire CA système. |

!!! info "Détection automatique du CA système"
    Si `mqtt_ca_file` et `mqtt_ca_path` sont tous les deux vides, l'agent tente de trouver automatiquement le CA système dans les chemins suivants, dans cet ordre :

    **Fichiers CA :**

    - `/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem` (Fedora/RHEL)
    - `/etc/ssl/certs/ca-certificates.crt` (Debian/Ubuntu)
    - `/etc/ssl/certs/ca-bundle.crt`

    **Répertoires CA :**

    - `/etc/pki/tls/certs` (Fedora/RHEL)
    - `/etc/ssl/certs` (Debian/Ubuntu)

    Si aucun n'est trouvé et que le SSL est activé, le démarrage de l'agent échoue.

---

## Variables d'environnement

Ces variables peuvent être définies dans l'environnement du processus (utile pour les containers). Elles **surchargent** les valeurs lues depuis le fichier de configuration :

| Variable | Clé JSON équivalente |
|---|---|
| `ABLS_DOMAIN_UUID` | `domain_uuid` |
| `ABLS_DOMAIN_SECRET` | `domain_secret` |
| `ABLS_AGENT_UUID` | `agent_uuid` |
| `ABLS_API_URL` | `api_url` |

---

## Options de ligne de commande

| Option | Description |
|---|---|
| `--domain-uuid <uuid>` | Surcharge `domain_uuid` |
| `--domain-secret <secret>` | Surcharge `domain_secret` |
| `--agent-uuid <uuid>` | Surcharge `agent_uuid` |
| `--api-url <url>` | Surcharge `api_url` |
| `--save` | Écrit la configuration résultante dans `/etc/abls-habitat-agent.conf` |
| `--debug <niveau>` | Définit le niveau de log (0 = urgence … 7 = debug) |
| `--single` | Démarre sans lancer les threads connecteurs |

!!! tip "Ordre de priorité"
    En cas de conflit, l'ordre de priorité est (du plus fort au plus faible) :
    **Ligne de commande** > **Variables d'environnement** > **Fichier de configuration**
