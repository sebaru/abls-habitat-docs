# I/O GPIO Raspberry Pi

L'agent [GPIOD](../../admin/agents/catalogue/gpiod.md) expose les broches GPIO d'une carte Linux
(Raspberry Pi et compatibles) comme entrées et sorties T.O.R.

---

## I/O exposées

| Famille | Disponible | Remarque |
|---|---|---|
| `DI` — entrées T.O.R | oui | Une par broche configurée en entrée |
| `DO` — sorties T.O.R | oui | Une par broche configurée en sortie |
| `AI` — entrées analogiques | non | Le Raspberry Pi n'a pas de convertisseur analogique |
| `AO` — sorties analogiques | non | — |

!!! tip "Besoin d'analogique sur Raspberry Pi ?"
    Utilisez un module [Phidget](phidget.md) ou un automate [Modbus](modbus.md).

---

## Configuration dans la Console

Menu **Agents → GPIOD**, puis sélectionnez votre agent.

Pour chaque broche utilisée, déclarez :

| Champ | Description |
|---|---|
| **Contrôleur** | Le `gpiochip` concerné, généralement `gpiochip0` |
| **Numéro de ligne** | Le numéro de la ligne GPIO, au sens `libgpiod` |
| **Sens** | Entrée ou sortie |
| **Libellé** | Texte affiché dans la Console et le mapping |

!!! danger "Numéro de ligne, pas numéro de broche physique"
    `libgpiod` numérote les **lignes du contrôleur**, ce qui ne correspond ni au numéro de la
    broche sur le connecteur, ni à l'ancienne numérotation BCM de `sysfs`.

    Vérifiez avec :

    ```bash
    gpioinfo gpiochip0
    ```

---

## Mapping

Chaque I/O déclarée devient mappable vers un mnémonique D.L.S.
Voir [mapper les I/O](../parcours/03-mapping.md).

```dls
#define PORTAIL_OUVERT <-> _DI(libelle="Fin de course portail ouvert");
#define CMD_PORTAIL    <-> _DO(libelle="Commande ouverture portail");

- PORTAIL_OUVERT -> MSG_PORTAIL_OUVERT;
```

---

## Points d'attention pour le câblage

!!! danger "Les GPIO sont en 3,3 V"
    Ne jamais appliquer 5 V ni une tension secteur sur une broche. Passez systématiquement par un
    optocoupleur ou un module relais isolé.

!!! warning "État indéterminé au démarrage"
    Entre la mise sous tension de la carte et le démarrage de l'agent, l'état des broches n'est
    pas maîtrisé. Câblez de sorte que l'état par défaut soit l'état sûr (relais au repos =
    équipement à l'arrêt).

### Entrées flottantes

Une entrée non tirée oscille au gré des perturbations. Activez la résistance de tirage interne
ou posez une résistance externe. Une entrée « qui clignote toute seule » est presque toujours
une entrée flottante.

### Rebonds de contact

Un contact mécanique produit plusieurs fronts en quelques millisecondes. Filtrez côté D.L.S :

```dls
#define BP_BRUT   <-> _DI(libelle="Bouton poussoir");
#define BP_FILTRE <-> _T(daa=2, dma=0, dMa=0, dad=0, libelle="Anti-rebond 200ms");

- BP_BRUT -- BP_FILTRE -> ACTION;
```

---

## Voir aussi

- [Installation de l'agent GPIOD](../../admin/agents/catalogue/gpiod.md)
- [Entrées T.O.R](../dls/objets/di.md) · [Sorties T.O.R](../dls/objets/do.md)
- [Temporisations](../dls/objets/tempos.md)
