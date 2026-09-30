# Onduleur (UPS)

L'agent [UPS](../../admin/agents/catalogue/ups.md) remonte l'état d'un onduleur exposé par un
serveur NUT.

---

## I/O exposées

| Famille | Disponible | Contenu |
|---|---|---|
| `DI` — entrées T.O.R | oui | Présence secteur, batterie faible, défaut, remplacement de batterie |
| `AI` — entrées analogiques | oui | Charge de la batterie, autonomie, charge de sortie, tensions |
| `DO`, `AO` | non | — |

Le mapping se fait dans la Console : menu **Agents → UPS**, puis pour chaque variable NUT utile,
associez un mnémonique.

---

## Variables NUT courantes

| Variable NUT | Nature | Unité | Signification |
|---|---|---|---|
| `ups.status` | état | — | `OL` sur secteur, `OB` sur batterie, `LB` batterie faible |
| `battery.charge` | analogique | % | Charge restante |
| `battery.runtime` | analogique | s | Autonomie estimée |
| `ups.load` | analogique | % | Taux de charge de l'onduleur |
| `input.voltage` | analogique | V | Tension d'entrée |
| `output.voltage` | analogique | V | Tension de sortie |

Liste exacte pour votre matériel :

```bash
upsc onduleur@localhost
```

---

## Le schéma d'usage type

```dls
#define SECTEUR_PRESENT <-> _DI(libelle="Présence secteur");
#define BATT_FAIBLE     <-> _DI(libelle="Batterie faible");
#define BATT_CHARGE     <-> _AI(libelle="Charge batterie", unite="%");
#define AUTONOMIE       <-> _AI(libelle="Autonomie restante", unite="s");

#define MSG_COUPURE <-> _MSG(type=alarme,
                             libelle="Coupure secteur, autonomie $UPS:AUTONOMIE secondes",
                             notif_sms);

#define MSG_RETOUR <-> _MSG(type=etat,
                            libelle="Le secteur est revenu",
                            notif_sms);

#define MSG_BATT_CRITIQUE <-> _MSG(type=danger,
                                   libelle="Batterie onduleur critique, arrêt imminent",
                                   notif_sms);

- /SECTEUR_PRESENT -> MSG_COUPURE;
-  SECTEUR_PRESENT -> MSG_RETOUR;
-  BATT_FAIBLE     -> MSG_BATT_CRITIQUE;
```

---

## Temporiser les micro-coupures

Une coupure d'une seconde ne mérite pas une alerte.

```dls
#define TR_COUPURE <-> _T(daa=100, dma=0, dMa=0, dad=0,
                          libelle="Confirmation coupure 10 secondes");

- /SECTEUR_PRESENT -- TR_COUPURE -> MSG_COUPURE;
```

!!! tip "Dimensionner `daa`"
    `daa` s'exprime en dixièmes de seconde : `daa=100` vaut 10 secondes.
    C'est un bon compromis pour filtrer les micro-coupures sans retarder l'alerte utile.

---

## Délester pour tenir plus longtemps

L'intérêt principal de la remontée UPS est de **prolonger l'autonomie** en coupant les charges
non essentielles dès la coupure.

```dls
#define DELESTAGE_CONFORT <-> _DO(libelle="Coupure circuits de confort");

- /SECTEUR_PRESENT -> DELESTAGE_CONFORT;
-  SECTEUR_PRESENT -> /DELESTAGE_CONFORT;
```

!!! danger "N'alimentez pas les actionneurs par l'onduleur lui-même"
    Si le contacteur de délestage est alimenté par l'onduleur, il consomme précisément
    l'autonomie qu'il est censé préserver.

---

## Surveiller la santé de la batterie

Une batterie vieillissante annonce une autonomie qu'elle ne tiendra pas.

```dls
#define MSG_BATT_USEE <-> _MSG(type=derangement,
                               libelle="Autonomie de l'onduleur anormalement faible");

- SECTEUR_PRESENT . BATT_CHARGE > 95.0 . AUTONOMIE < 300.0 -> MSG_BATT_USEE;
```

Archivez `battery.runtime` : sa décroissance sur plusieurs mois est le meilleur indicateur du
moment où changer la batterie.

---

## Voir aussi

- [Installation de l'agent UPS](../../admin/agents/catalogue/ups.md)
- [Messages D.L.S](../dls/objets/messages.md)
- [Paramétrer les archives](../parcours/09-archives.md)
