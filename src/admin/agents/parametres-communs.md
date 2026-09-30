# Paramètres communs à tous les agents

Cette page recense les paramètres reconnus par **toutes** les classes d'agent.
Les paramètres spécifiques à une technologie sont décrits dans le
[catalogue des agents](catalogue/index.md).

Rappel : la précédence effective est **ARGV > FILE > ENV > défaut**.
Voir [Configuration et précédence](configuration.md).

---

## Identité de l'agent

| Clé JSON | Variable d'environnement | Option | Type | Défaut | Obligatoire |
|---|---|---|---|---|---|
| `agent_tech_id` | `ABLS_AGENT_TECH_ID` | `--agent-tech-id` | chaîne | — | **oui** |
| `server_uuid` | `ABLS_SERVER_UUID` | `--server-uuid` | chaîne | généré | non |

`agent_classe` n'est pas configurable : elle est fixée par le binaire lui-même
(`abls-agent-modbus` est toujours de classe `modbus`).

!!! tip "Choisir un `agent_tech_id`"
    Utilisez un nom parlant, stable et sans espace : `MODBUS_CHAUFFERIE`, `AUDIO_SALON`,
    `GPIOD_PORTAIL`. Il apparaîtra dans le nom du service systemd, dans le nom du fichier de
    configuration, dans les topics MQTT et dans la Console. Le renommer implique de refaire
    l'enrôlement.

---

## Raccordement au domaine

| Clé JSON | Variable d'environnement | Option | Type | Défaut | Obligatoire |
|---|---|---|---|---|---|
| `domain_uuid` | `ABLS_DOMAIN_UUID` | `--domain-uuid` | chaîne | — | **oui** (hors standalone) |
| `domain_secret` | `ABLS_DOMAIN_SECRET` | `--domain-secret` | chaîne | — | **oui** (hors standalone) |
| `api_url` | `ABLS_API_URL` | `--api-url` | chaîne | — | **oui** (hors standalone) |

!!! danger "Confidentialité du `domain_secret`"
    Le `domain_secret` permet à n'importe quel processus de s'authentifier auprès de l'API au nom
    de votre domaine. Ne le communiquez jamais, ne le versionnez jamais, ne le passez pas en
    ligne de commande sur une machine partagée (il serait visible dans `ps`).

    Préférez, dans ce cas, le poser dans le fichier de configuration en mode `0640`.

---

## Fonctionnement du moteur

| Clé JSON | Variable d'environnement | Option | Type | Défaut | Description |
|---|---|---|---|---|---|
| `tps` | `ABLS_TPS` | `--tps` | entier | `50` | Tours par seconde de la boucle principale |
| `dry_run` | `ABLS_DRY_RUN` | `--dry-run` | booléen | `false` | Simule les I/O sans les écrire réellement |
| `log_level` | `ABLS_LOG_LEVEL` | — | entier | `6` (`LOG_INFO`) | Verbosité syslog, de `0` à `7` |
| `config_file` | `ABLS_CONFIG_FILE` | — | chaîne | `/etc/abls/abls-agent.conf` | Fichier de configuration principal |

!!! note "`dry_run` en mise en service"
    `--dry-run` est précieux lors du premier démarrage sur une installation réelle : l'agent lit
    les entrées et publie leur état, mais n'actionne aucune sortie. Vous pouvez valider le mapping
    sans risque avant de basculer en mode réel.

!!! warning "`log_level` peut être repris par l'API"
    La valeur locale s'applique au démarrage, mais l'API renvoie sa propre valeur de `log_level`
    lors de l'enrôlement, et peut la modifier à chaud via le topic MQTT `AGENT/<tech_id>/LOG`.
    Voir [journaux](../exploitation/journaux.md).

Les niveaux suivent la convention syslog :

| Valeur | Niveau | Usage |
|---|---|---|
| 0 | `LOG_EMERG` | Système inutilisable |
| 1 | `LOG_ALERT` | Intervention immédiate requise |
| 2 | `LOG_CRIT` | Erreur critique, arrêt de l'agent |
| 3 | `LOG_ERR` | Erreur |
| 4 | `LOG_WARNING` | Avertissement |
| 5 | `LOG_NOTICE` | Événement notable (démarrage, connexion) |
| 6 | `LOG_INFO` | Fonctionnement normal détaillé — **défaut** |
| 7 | `LOG_DEBUG` | Mise au point, très verbeux |

---

## MQTT et TLS

| Clé JSON | Variable d'environnement | Option | Type | Défaut | Description |
|---|---|---|---|---|---|
| `mqtt_over_ssl` | `ABLS_MQTT_OVER_SSL` | — | booléen | fourni par l'API | Chiffre la liaison MQTT vers l'API |
| `mqtt_ca_file` | `ABLS_MQTT_CA_FILE` | — | chaîne | `""` | Fichier PEM du CA validant le certificat du broker |
| `mqtt_ca_path` | `ABLS_MQTT_CA_PATH` | — | chaîne | `""` | Répertoire de certificats CA |

Les paramètres `mqtt_hostname`, `mqtt_port`, `mqtt_password` et `mqtt_qos` ne sont **pas** à
définir localement : ils sont fournis par l'API lors de l'[enrôlement](enrolement.md).

!!! info "Détection automatique du CA système"
    Si `mqtt_ca_file` et `mqtt_ca_path` sont tous deux vides, l'agent cherche automatiquement le
    magasin de certificats de la distribution, dans cet ordre :

    **Fichiers CA**

    - `/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem` (Fedora / RHEL)
    - `/etc/ssl/certs/ca-certificates.crt` (Debian / Raspberry Pi OS)
    - `/etc/ssl/certs/ca-bundle.crt`

    **Répertoires CA**

    - `/etc/pki/tls/certs` (Fedora / RHEL)
    - `/etc/ssl/certs` (Debian / Raspberry Pi OS)

    Si aucun n'est trouvé alors que TLS est actif, le démarrage échoue.

Une autorité de certification privée se déclare ainsi :

```json
{
  "mqtt_over_ssl": true,
  "mqtt_ca_file": "/etc/abls/ca-interne.pem"
}
```

---

## Mode standalone

| Clé JSON | Variable d'environnement | Option | Type | Défaut | Description |
|---|---|---|---|---|---|
| `standalone` | `ABLS_STANDALONE` | `--standalone` | booléen | `false` | Désactive tout dialogue avec l'API |
| `master_hostname` | `ABLS_MASTER_HOSTNAME` | `--master-hostname` | chaîne | fourni par l'API | Broker MQTT local |

Voir [Mode standalone](standalone.md).

---

## Paramètres de service

| Clé JSON | Option | Description |
|---|---|---|
| — | `--save` | Écrit la configuration résolue puis quitte |
| — | `--help` | Affiche l'aide générée et quitte |

---

## Aide-mémoire

```bash
# Quelle configuration l'agent a-t-il réellement retenue ?
sudo journalctl -u abls-agent-modbus@MODBUS_CHAUFFERIE.service | grep local_config

# Quelles options accepte cette classe d'agent ?
abls-agent-modbus --help

# Des variables ABLS_ traînent-elles dans mon shell ?
env | grep ^ABLS_
```
