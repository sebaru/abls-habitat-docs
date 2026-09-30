# SMS

L'agent [SMS](../../admin/agents/catalogue/sms.md) est à la fois un **organe de notification**
et un **organe de commande** : il envoie des alertes et reçoit des ordres par message texte.

---

## I/O exposées

| Famille | Disponible | Usage |
|---|---|---|
| `DI` — entrées T.O.R | oui, **virtuelles** | Une par commande texte déclarée avec `map_sms` |
| `DO`, `AI`, `AO` | non | — |

Les entrées ne sont pas mappées manuellement : elles sont créées par la déclaration D.L.S
elle-même.

---

## Envoyer une notification

L'option `notif_sms` d'un message déclenche son envoi par SMS :

```dls
#define MSG_FUITE_EAU <-> _MSG(type=danger,
                               libelle="Fuite d'eau détectée dans la cave",
                               notif_sms);

- CAVE:DETECTION_EAU -> MSG_FUITE_EAU;
```

Les destinataires sont les **utilisateurs du domaine** ayant renseigné leur numéro et demandé à
être notifiés. Voir [Être notifié](../../utilisateur/notifications.md).

!!! warning "Le SMS coûte et dérange"
    Réservez `notif_sms` aux messages de type `danger`, `alarme` ou `defaut`.
    Un message d'état banal notifié par SMS finit par être ignoré, et c'est celui qui compte
    qui passera inaperçu.

---

## Recevoir une commande

L'option `map_sms` sur une entrée T.O.R crée une **commande texte** :

```dls
#define O_TXT_POMPE_ON  <-> _DI(map_sms="POMPE ON");
#define O_TXT_POMPE_OFF <-> _DI(map_sms="POMPE OFF");

- O_TXT_POMPE_ON  -> DEMARRER_POMPE;
- O_TXT_POMPE_OFF -> /DEMARRER_POMPE;
```

L'utilisateur envoie `POMPE ON` au numéro du domaine ; l'entrée passe à `1` le temps d'un tour,
comme une impulsion.

!!! note "L'entrée est fugitive"
    Une commande texte se comporte comme une impulsion, pas comme un état maintenu.
    Pour mémoriser, passez par un [bistable](../dls/objets/bistables.md).

---

## Interroger l'installation

Le schéma le plus utile est la **demande d'information** : une commande texte qui provoque
l'envoi d'un message de réponse.

```dls
#define O_TXT_TEMP <-> _DI(map_sms="TEMP");
#define MSG_TEMP   <-> _MSG(type=etat,
                            libelle="Salon $TEMP:SALON degrés, jardin $TEMP:JARDIN degrés",
                            notif_sms);

- O_TXT_TEMP -> MSG_TEMP;
```

---

## Sécurité des commandes texte

!!! danger "Une commande texte pilote votre installation depuis l'extérieur"
    Trois protections se cumulent :

    1. **L'émetteur doit être un utilisateur connu du domaine** — un numéro inconnu est ignoré.
    2. **Son niveau d'habilitation doit être suffisant** pour la ressource visée.
    3. **La commande doit exister** — une commande inconnue n'a aucun effet.

    Cela ne dispense pas de bon sens : ne créez pas de commande texte pour une action dangereuse
    ou irréversible (déverrouillage d'un accès, coupure d'un circuit de sécurité).

!!! tip "Nommez les commandes sans ambiguïté"
    Évitez les commandes proches l'une de l'autre (`ON` / `OFF` seuls). Un correcteur
    automatique de téléphone ou une faute de frappe ne doit pas transformer une commande
    anodine en commande critique.

---

## Choisir entre modem local et passerelle OVH

| Critère | Modem GSM local | Passerelle OVH |
|---|---|---|
| Réception de commandes | oui | non |
| Fonctionne sans Internet | oui | non |
| Matériel requis | modem + SIM | aucun |
| Coût | abonnement SIM | crédit SMS |

!!! tip "Le modem local reste le meilleur choix pour l'alerte"
    En cas de coupure Internet, c'est le seul canal qui continue de fonctionner. C'est
    précisément le moment où vous voulez être prévenu.

---

## Voir aussi

- [Installation de l'agent SMS](../../admin/agents/catalogue/sms.md)
- [Messages D.L.S](../dls/objets/messages.md)
- [Commander par SMS](../../utilisateur/commandes-sms.md)
