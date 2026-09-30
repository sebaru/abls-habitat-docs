# Agent AUDIO

Diffuse des **annonces vocales** et des sons sur les enceintes d'une machine.

!!! warning "C'est le seul agent qui tourne en service utilisateur"
    Il doit accéder au serveur de son de la session. Il ne s'installe donc pas comme les autres.

---

## Rôle

- Reçoit les messages à énoncer depuis le moteur D.L.S.
- Les convertit en parole (`gtts-cli`) et les diffuse (`mpg123`).
- Gère des **zones de diffusion** : un message peut être envoyé à une pièce précise.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | Carte son et enceintes raccordées |
| Serveur de son | PipeWire avec WirePlumber (`wpctl`) |
| Outils | `gtts-cli` (synthèse vocale) et `mpg123` (lecture) |
| Réseau | Accès sortant Internet pour la synthèse vocale |

```bash
sudo apt install mpg123 python3-gtts
wpctl status        # les sorties audio doivent apparaître
```

!!! warning "La synthèse vocale nécessite Internet"
    `gtts-cli` interroge un service en ligne. Sans accès Internet, les annonces vocales
    ne fonctionnent pas.

---

## Installation

```bash
sudo apt install abls-agent-audio
```

---

## Activation du service utilisateur

```bash
# 1. Activer le modèle pour les sessions utilisateur
sudo systemctl --global enable abls-agent-audio@AUDIO_SALON.service

# 2. Permettre à la session de survivre à la déconnexion
sudo loginctl enable-linger monutilisateur

# 3. Démarrer
sudo -iu monutilisateur systemctl --user daemon-reload
sudo -iu monutilisateur systemctl --user start abls-agent-audio@AUDIO_SALON.service
```

!!! danger "Sans `enable-linger`, l'agent s'arrête à la déconnexion"
    C'est la cause numéro un des agents audio « qui marchent puis s'arrêtent ».

L'unité déclare `Wants=wireplumber.service` : elle démarre après le serveur de son.

---

## Paramètres spécifiques

| Clé JSON | Variable d'environnement | Option | Type | Description |
|---|---|---|---|---|
| `volume` | `ABLS_VOLUME` | `--volume` | entier 0–100 | Volume de diffusion |
| `language` | `ABLS_LANGUAGE` | `--language` | chaîne | Langue de la synthèse : `fr` ou `en` |

Les **zones de diffusion** ne se configurent pas ici : elles se déclarent depuis la Console,
page [Zones audio](https://console.abls-habitat.fr/audio/zones).

---

## Enrôlement

```bash
sudo abls-agent-audio --agent-tech-id AUDIO_SALON \
                      --volume        70 \
                      --language      fr \
                      --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                      --domain-secret 'votre-secret-ici' \
                      --api-url       api.abls-habitat.fr \
                      --save
```

---

## Consulter les journaux

Attention : ce sont les journaux **utilisateur**.

```bash
sudo -iu monutilisateur journalctl --user -u abls-agent-audio@AUDIO_SALON.service -f
```

---

## Dépannage

| Symptôme | Piste |
|---|---|
| L'agent s'arrête à la déconnexion | `loginctl enable-linger <utilisateur>` manquant |
| Aucun son alors que l'agent tourne | `wpctl status` : la sortie par défaut est-elle la bonne ? Volume système à zéro ? |
| `gtts-cli: command not found` | Installer `python3-gtts` |
| Annonces muettes mais journaux normaux | Pas d'accès Internet : la synthèse vocale échoue |
| Volume ignoré | Le volume système prime : vérifier avec `wpctl get-volume @DEFAULT_AUDIO_SINK@` |
| `journalctl -u abls-agent-audio...` ne renvoie rien | Vous consultez le journal système : ajoutez `--user` |

---

## Voir aussi

- [Connecteur audio côté technicien](../../../technicien/connecteurs/audio.md)
- [Messages D.L.S](../../../technicien/dls/objets/messages.md)
