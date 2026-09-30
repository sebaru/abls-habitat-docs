# Agent METEO

Récupère les **prévisions météorologiques** depuis l'API Météo-Concept et les met à disposition
du domaine.

---

## Rôle

- Publie les prévisions de la commune : températures minimale et maximale, probabilité de pluie,
  cumul, vent, ensoleillement.
- Alimente les **horloges** d'éphémérides : lever et coucher du soleil.

Très utilisé pour conditionner l'arrosage, le chauffage ou l'éclairage extérieur.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Compte | Un jeton d'API [Météo-Concept](https://api.meteo-concept.com/) |
| Donnée | Le code INSEE de la commune |
| Réseau | Accès HTTPS sortant |

!!! tip "Trouver le code INSEE"
    Il s'agit du code commune de l'INSEE, à 5 caractères, différent du code postal.
    Il est publié sur le site de l'INSEE ou dans les données ouvertes de votre commune.

!!! warning "Quota d'appels"
    Le palier gratuit de Météo-Concept limite le nombre de requêtes quotidiennes.
    Une seule instance d'agent par commune suffit largement.

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-meteo
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-meteo
    ```

---

## Unité systemd

`abls-agent-meteo@.service` — unité **templatée**.

```bash
sudo systemctl enable --now abls-agent-meteo@METEO_API.service
```

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `token` | `ABLS_TOKEN` | `--token` | chaîne | Jeton d'API Météo-Concept |
| `code_insee` | `ABLS_CODE_INSEE` | `--code-insee` | chaîne | Code INSEE de la commune |

!!! note "`code_insee` est une chaîne, pas un entier"
    Certains codes INSEE commencent par un zéro ou contiennent une lettre (Corse).
    Conservez-les entre guillemets dans le fichier JSON.

---

## Enrôlement

```bash
sudo tee /etc/abls/abls-agent-meteo@METEO_API.conf >/dev/null <<'EOF'
{
  "agent_tech_id": "METEO_API",
  "domain_uuid":   "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "domain_secret": "votre-secret-ici",
  "api_url":       "api.abls-habitat.fr",
  "token":         "votre-jeton-meteo-concept",
  "code_insee":    "77350"
}
EOF
sudo chown root:abls /etc/abls/abls-agent-meteo@METEO_API.conf
sudo chmod 0640      /etc/abls/abls-agent-meteo@METEO_API.conf

sudo systemctl enable --now abls-agent-meteo@METEO_API.service
```

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Erreur d'authentification | Jeton incorrect ou expiré |
| Aucune donnée pour la commune | Code INSEE erroné — attention à ne pas confondre avec le code postal |
| Les données cessent en milieu de journée | Quota d'appels dépassé |
| Lever et coucher du soleil décalés | Fuseau horaire du système incorrect : `timedatectl` |

```bash
sudo journalctl -u abls-agent-meteo@METEO_API.service -f
```

---

## Voir aussi

- [Connecteur Météo côté technicien](../../../technicien/connecteurs/meteo.md)
- [Exemple D.L.S Météo](../../../technicien/dls/exemples/meteo.md)
