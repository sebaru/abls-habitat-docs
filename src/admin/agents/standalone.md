# Mode standalone

Le mode **standalone** fait tourner un agent **sans API centrale**. L'agent ne s'enrôle pas, ne
remonte aucune donnée au Cloud et se contente de dialoguer avec le broker MQTT local.

---

## Quand l'utiliser

- **Banc de test** : valider un câblage ou un automate sans polluer le domaine de production.
- **Site isolé** : installation sans accès Internet permanent.
- **Diagnostic** : isoler un problème d'agent d'un problème d'API.

!!! warning "Ce que vous perdez"
    En standalone, l'agent ne bénéficie ni de la configuration distante, ni de l'historique, ni
    des synoptiques, ni des notifications. La Console ne le voit pas. Ce n'est pas un mode
    d'exploitation nominal.

---

## Activation

```bash
sudo abls-agent-modbus --agent-tech-id MODBUS_BANC \
                       --standalone \
                       --master-hostname 127.0.0.1 \
                       --save
```

Ou dans le fichier de configuration :

```json
{
  "agent_tech_id":   "MODBUS_BANC",
  "standalone":      true,
  "master_hostname": "127.0.0.1"
}
```

---

## Ce qui change

| Aspect | Mode normal | Mode standalone |
|---|---|---|
| `domain_uuid`, `domain_secret`, `api_url` | obligatoires | ignorés |
| `master_hostname` | fourni par l'API | **obligatoire** |
| Appel `POST /run/agent/config` | oui | non |
| Bus MQTT API | connecté | non connecté |
| Bus MQTT local | connecté | connecté |
| Visibilité dans la Console | oui | non |
| `log_level` | imposé par l'API | valeur locale conservée |

L'agent refuse de démarrer si `master_hostname` est absent :
`There is no 'master_hostname', in config, exiting.`

---

## Broker MQTT local

Le mode standalone suppose un broker MQTT joignable sur le port `1883` à l'adresse
`master_hostname`. Sur un poste de test :

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

---

## Observer un agent standalone

Sans Console, l'observation passe par MQTT.

```bash
# Tout ce que l'agent publie
mosquitto_sub -h 127.0.0.1 -t '#' -v

# Forcer une sortie T.O.R
mosquitto_pub -h 127.0.0.1 -t 'SET_DO/MODBUS_BANC/3' -m '1'

# Forcer une sortie analogique
mosquitto_pub -h 127.0.0.1 -t 'SET_AO/MODBUS_BANC/0' -m '42.5'
```

Combinez avec `--dry-run` pour vérifier la logique de mapping sans actionner le matériel :

```bash
abls-agent-modbus --agent-tech-id MODBUS_BANC --standalone \
                  --master-hostname 127.0.0.1 --dry-run
```

---

## Revenir en mode normal

Le mode standalone est un drapeau : il ne peut pas être désactivé depuis la ligne de commande.
Retirez la clé du fichier de configuration :

```bash
sudo systemctl stop abls-agent-modbus@MODBUS_BANC.service
sudo rm /etc/abls/abls-agent-modbus@MODBUS_BANC.conf
```

Puis refaites un [enrôlement](enrolement.md) normal.
