# Diffusion audio

L'agent [AUDIO](../../admin/agents/catalogue/audio.md) diffuse des **annonces vocales** sur les
enceintes d'une machine. Il ne fournit aucune entrée ni sortie : c'est un **organe de
notification**, au même titre que le [SMS](sms.md) et la [messagerie](imsg.md).

---

## I/O exposées

| Famille | Disponible |
|---|---|
| `DI`, `DO`, `AI`, `AO` | non |

Rien à mapper. L'audio se pilote exclusivement par les
[messages D.L.S](../dls/objets/messages.md).

---

## Les zones de diffusion

Une **zone** représente un ensemble d'enceintes, typiquement une pièce.
Chaque agent audio est rattaché à une ou plusieurs zones.

Configuration dans la Console : menu **Zones audio**.

| Champ | Description |
|---|---|
| **Nom de la zone** | Identifiant utilisé en D.L.S, par exemple `SALON` |
| **Libellé** | Texte affiché dans la Console |
| **Agents rattachés** | Les agents audio qui diffusent dans cette zone |

!!! tip "Prévoyez une zone générale"
    Une zone regroupant toutes les enceintes est indispensable pour les alertes de sécurité,
    qui doivent être entendues partout.

---

## Diffuser un message

L'option `audio_zone` d'un message désigne la zone de diffusion :

```dls
#define MSG_PORTAIL_OUVERT <-> _MSG(type=etat,
                                    libelle="Le portail vient de s'ouvrir",
                                    audio_zone="SALON");

#define MSG_FUITE_EAU <-> _MSG(type=danger,
                               libelle="Attention, fuite d'eau détectée",
                               audio_zone="GENERALE",
                               notif_sms);

- PORTAIL:OUVERT      -> MSG_PORTAIL_OUVERT;
- CAVE:DETECTION_EAU  -> MSG_FUITE_EAU;
```

Le texte du `libelle` est **lu à voix haute**. Il peut contenir des variables :

```dls
#define MSG_TEMP <-> _MSG(libelle="Il fait $TEMP:JARDIN degrés dehors",
                          audio_zone="CUISINE");
```

---

## Écrire un texte destiné à être entendu

Un bon libellé écrit n'est pas forcément un bon libellé parlé.

!!! tip "Quelques règles"
    - **Phrases courtes et complètes.** « Le portail est ouvert » plutôt que « Portail : ouvert ».
    - **Pas d'abréviations.** « degrés » et non « °C », « pourcent » et non « % ».
    - **Attention aux unités collées au nombre.** `$TEMP:JARDIN°C` se prononce mal.
    - **Évitez la ponctuation exotique**, les parenthèses et les tirets.
    - **Relisez à voix haute** avant de valider.

---

## Éviter la cacophonie

Une annonce répétée à chaque tour du moteur est insupportable.

!!! danger "Déclenchez toujours sur un front, jamais sur un état"
    ```dls
    /* À éviter : l'annonce se répète tant que la condition est vraie */
    - PORTE_OUVERTE -> MSG_PORTE;

    /* Préférer : déclenchement sur le front montant */
    #define MEM_PORTE <-> _B(libelle="Mémoire annonce porte");
    - PORTE_OUVERTE . /MEM_PORTE -> MSG_PORTE, MEM_PORTE;
    - /PORTE_OUVERTE            -> /MEM_PORTE;
    ```

Pensez aussi à conditionner les annonces non urgentes à une plage horaire :

```dls
- ANNONCE . _HEURE > 07:30 . _HEURE < 22:00 -> MSG_INFO;
```

---

## Limites à connaître

| Limite | Conséquence |
|---|---|
| La synthèse vocale nécessite un accès Internet | Pas d'annonce en cas de coupure |
| Latence de quelques secondes | L'audio n'est pas un moyen d'alerte temps réel |
| Une seule annonce à la fois par zone | Les messages simultanés s'enchaînent |

Pour une alerte critique, doublez toujours l'audio par un
[SMS](sms.md) ou un message visuel.

---

## Voir aussi

- [Installation de l'agent AUDIO](../../admin/agents/catalogue/audio.md)
- [Messages D.L.S](../dls/objets/messages.md)
- [Être notifié](../../utilisateur/notifications.md)
