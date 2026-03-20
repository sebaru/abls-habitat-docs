# Les Temporisations _T

Une temporisation est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_T*.

Chaque temporisation a pour valeur booléenne soit 0, soit 1, selon qu'elle est active ou non.
Elle peut être utilisée dans une **EXPRESSION** (valeur booléenne), ou positionnée dans une **LISTE_ACTIONS**.

Les temporisations permettent de **décaler, maintenir ou limiter dans le temps** un événement particulier. Elles sont définies par quatre paramètres indépendants :

| Paramètre   | Description |
|:------------|:------------|
| `delai_on`  | Retard au collage : délai avant que la temporisation passe à 1 après que la condition devient vraie |
| `min_on`    | Durée minimale de maintien à 1 : même si la condition retombe, la tempo reste à 1 au moins ce temps |
| `max_on`    | Durée maximale de maintien à 1 : même si la condition reste vraie, la tempo retombe après ce temps |
| `delai_off` | Retard au décollage : délai avant que la temporisation passe à 0 après que la condition devient fausse |
| `random`    | Valeur aléatoire : si renseigné, remplace `delai_on` par une valeur aléatoire entre 0 et `random` |

!!! note
    Toutes les durées sont exprimées en **dixièmes de secondes** (ex: `100` = 10 secondes, `600` = 1 minute).

## Déclarer une Temporisation

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez une temporisation de la manière suivante:

    #define ACRONYME <-> _T(libelle="Ma temporisation");

La définition commence par le mot clé `#define`, puis une chaine de caractères représentant l'**ACRONYME** de la temporisation, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe `_T`, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'une temporisation

### Options à la déclaration

* **libelle**: permet de documenter le rôle de la temporisation.

Exemple :

    #define TEMPO_ECLAIRAGE <-> _T(libelle="Temporisation extinction éclairage couloir");

### Options de positionnement dans une LISTE_ACTIONS

Les durées sont configurées au moment du positionnement de la temporisation :

* **delai_on=N** : retard au collage en dixièmes de secondes (défaut: 0)
* **delai_off=N** : retard au décollage en dixièmes de secondes (défaut: 0)
* **min_on=N** : durée minimale de maintien à 1 en dixièmes de secondes (défaut: 0)
* **max_on=N** : durée maximale de maintien à 1 en dixièmes de secondes (défaut: 0 = illimité)
* **random=N** : remplace `delai_on` par une valeur aléatoire entre 0 et N dixièmes de secondes

Exemple :

    /* La temporisation passe à 1 après 5s, et reste à 1 au moins 10s après retombée du signal */
    - MA_CONDITION → TEMPO_ECLAIRAGE(delai_on=50, delai_off=100);

## Comportement chronologique

Le cycle de vie d'une temporisation s'articule autour des états suivants :

```
Condition: _____|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|_____________________|¯¯¯¯¯¯¯
Tempo:     _____|←delai_on→|¯¯¯¯¯¯¯¯¯¯¯¯|←delai_off→|_____|¯¯
                                 ↑min_on↑         ↑max_on limite la durée
```

1. La condition passe à 1 → décompte de `delai_on`
2. Après `delai_on` → la temporisation passe à 1
3. La condition retombe à 0 → la temporisation reste à 1 au moins `min_on`
4. Après `min_on` et après `delai_off` → la temporisation passe à 0
5. Si la condition reste vraie au-delà de `max_on` → la temporisation retombe quand même à 0

## Exemples d'usage

### Retard à l'enclenchement (delai_on)

    /* La pompe ne démarre qu'après 3 secondes de demande (évite les micros-cycles) */
    #define TEMPO_ANTI_CYCLE <-> _T(libelle="Anti-court cycle pompe");

    - DEMANDE_CHAUFFE → TEMPO_ANTI_CYCLE(delai_on=30);
    - TEMPO_ANTI_CYCLE → POMPE:MARCHE;

### Maintien après extinction (delai_off)

    /* L'éclairage reste allumé 5 minutes après la dernière détection de présence */
    #define TEMPO_PRESENCE <-> _T(libelle="Maintien éclairage sur présence");

    - DETECTEUR:PRESENCE → TEMPO_PRESENCE(delai_off=3000);
    - TEMPO_PRESENCE → LUMIERE:ALLUMAGE;

### Limitation de durée (max_on)

    /* La vanne ne peut rester ouverte plus de 30 minutes */
    #define TEMPO_OUVERTURE <-> _T(libelle="Limitation ouverture vanne");

    - COMMANDE_OUVERTURE → TEMPO_OUVERTURE(max_on=18000);
    - TEMPO_OUVERTURE → VANNE:OUVERTURE;

### Usage dans une EXPRESSION

    /* Si la temporisation est active, on l'utilise dans une logique */
    - TEMPO_PRESENCE . /INHIBITION → LUMIERE:ALLUMAGE;

!!! tip
    Une temporisation peut être utilisée dans une condition pour déterminer si elle est en cours de décompte ou non.
    Sa valeur vaut 1 tant qu'elle est active, 0 sinon.

!!! warning
    Une temporisation ne peut être positionnée que dans le module D.L.S à qui elle appartient.
