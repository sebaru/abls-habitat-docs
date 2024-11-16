# Les Watchdog _WATCHDOG

Un Watchdog est un bit interne de la [mémoire d'information](dls.md#memoire-d'informations), de classe *_WATCHDOG*.


Un watchdog est un bit interne qui décompte le temps depuis sa consigne, et jusqu'à ce que cette consigne soit dépassée, et
que le watchdog devienne alors échu.

Dans une **EXPRESSION**, chaque watchdog a pour valeur booléenne soit 0, soit 1, selon qu'il est en décompte ou échu.

Dans une **ACTION**, il est possible de positionner une valeur de temps correspondant à la `consigne` du watchdog.

Tant que le watchdog est en décompte, à savoir que la consigne n'est pas atteinte, sa valeur est 1.
Quand la consigne est atteinte, la valeur du bit est 0: il est échu.

## Déclarer un Watchdog

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez un Watchdog de la manière suivante:

    #define MON_WATCHDOG <-> _WATCHDOG(options);

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** du Watchdog, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _WATCHDOG, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'un Watchdog

* **consigne**: permet de définir une unité de temps pour le décompte du watchdog. Elle s'exprime en dixième de seconde.
* **libelle**: La description du bit interne, ce qu'il représente.

## Exemple de définition

    /* Nous sommes dans le DLS "CHAUDIERE" */
    #define MON_WATCHDOG <-> _WATCHDOG (libelle="Temps de refresh", consigne=600);

## Usage d'un Watchdog

    /* Si MON_WATCHDOG est en décompte alors on affiche le message */
    - MON_WATCHDOG → MSG_WATCHDOG_EN_DECOMPTE;
    /* Si MON_WATCHDOG est échu, on le relance avec une nouvelle consigne */
    - /MON_WATCHDOG → MON_WATCHDOG(consigne=1200);
