# Téléinformation E.D.F

L'agent [TELEINFOEDF](../../admin/agents/catalogue/teleinfoedf.md) décode la trame de
**téléinformation client (TIC)** émise par un compteur électrique et publie les grandeurs de
consommation.

---

## I/O exposées

| Famille | Disponible | Contenu |
|---|---|---|
| `AI` — entrées analogiques | oui | Index d'énergie, puissance, intensité, tension |
| `DI` — entrées T.O.R | oui | Période tarifaire en cours, dépassements |
| `DO`, `AO` | non | La TIC est en lecture seule |

!!! note "La téléinformation ne commande rien"
    C'est un flux de mesure descendant. Pour agir sur des circuits, il faut un contacteur piloté
    par une sortie [Modbus](modbus.md) ou [GPIO](gpiod.md).

---

## Deux modes, deux jeux de données

| Mode | Débit | Compteurs concernés | Richesse |
|---|---|---|---|
| **Historique** | 1200 bauds | Compteurs électromécaniques, Linky par défaut | Index, intensité, puissance apparente |
| **Standard** | 9600 bauds | Linky reparamétré | Ajoute tension, puissances par phase, index fournis et soutirés |

!!! danger "Le mode se règle côté agent ET côté compteur"
    Le paramètre `standard` de l'agent doit correspondre au mode réellement émis par le
    compteur. Une discordance donne une trame illisible et aucune donnée.
    Voir [la page d'installation](../../admin/agents/catalogue/teleinfoedf.md).

---

## Grandeurs typiques

Les étiquettes exactes dépendent du compteur et du mode. Les plus utilisées :

| Nature | Mode historique | Mode standard | Unité |
|---|---|---|---|
| Index heures pleines | `HCHP` | `EASF02` | Wh |
| Index heures creuses | `HCHC` | `EASF01` | Wh |
| Intensité instantanée | `IINST` | `IRMS1` | A |
| Puissance apparente | `PAPP` | `SINSTS` | VA |
| Tension | — | `URMS1` | V |
| Période tarifaire | `PTEC` | `LTARF` | — |
| Intensité souscrite | `ISOUSC` | `PREF` | A / kVA |

Le mapping se fait dans la Console : menu **Agents → Téléinfo EDF**, puis pour chaque étiquette
utile, associez un mnémonique.

---

## Exemples d'usage

### Suivre la consommation

```dls
#define PUISSANCE <-> _AI(libelle="Puissance apparente", unite="VA");
#define ISOUSC    <-> _AI(libelle="Intensité souscrite", unite="A");

#define MSG_SURCHARGE <-> _MSG(type=alerte,
                               libelle="Consommation proche du disjoncteur : $TIC:PUISSANCE VA",
                               notif_sms);

- PUISSANCE > 8000 -> MSG_SURCHARGE;
```

### Délester avant la coupure

```dls
#define DELESTAGE <-> _DO(libelle="Coupure chauffe-eau");

- PUISSANCE > 8500 -> DELESTAGE;
- PUISSANCE < 7000 -> /DELESTAGE;
```

!!! warning "Prévoyez toujours une hystérésis"
    Sans écart entre le seuil de déclenchement et le seuil de retour, la sortie bat en
    permanence autour du seuil et use le contacteur.

### Exploiter les heures creuses

```dls
#define HEURES_CREUSES <-> _DI(libelle="Période heures creuses");

- HEURES_CREUSES -> AUTORISATION_BALLON;
```

---

## Archiver les index

Les index d'énergie sont cumulatifs : les archiver permet de tracer des courbes de consommation
sur plusieurs années. Activez l'archivage sur ces mnémoniques
([paramétrer les archives](../parcours/09-archives.md)), puis construisez un
[tableau de courbes](../parcours/08-tableaux.md).

!!! tip "Archivez les index, pas la puissance instantanée"
    La puissance apparente varie à chaque seconde : l'archiver produit un volume considérable
    pour peu d'information. Les index, eux, suffisent à reconstituer toute consommation.

---

## Voir aussi

- [Installation de l'agent TELEINFOEDF](../../admin/agents/catalogue/teleinfoedf.md)
- [Entrées analogiques](../dls/objets/ai.md)
- [Shelly](shelly.md) — alternative ou complément pour mesurer un circuit précis
