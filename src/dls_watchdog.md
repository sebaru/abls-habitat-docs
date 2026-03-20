# Les Watchdog _WATCHDOG

Un Watchdog est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_WATCHDOG*.


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

### À la déclaration

* **libelle**: La description du bit interne, ce qu'il représente.
* **consigne**: valeur de décompte par défaut exprimée en dixième de seconde. Si non renseignée, la valeur par défaut est 600 (soit 60 secondes).

Exemple :

    /* Watchdog de 60s (600 dixièmes) */
    #define WD_COMM <-> _WATCHDOG(libelle="Surveillance communication", consigne=600);

### Dans le corps du module (action)

Lors du positionnement en action, deux formes sont possibles :

* `MON_WATCHDOG(consigne=N)` — relance le watchdog avec une valeur fixe (en dixièmes de secondes)
* `MON_WATCHDOG(consigne=TECH_ID:ACRONYME_R)` — relance le watchdog avec la valeur d'un **registre**, permettant une consigne dynamique

!!! tip
    Un watchdog est `1` (vrai) tant que son compte à rebours n'a pas atteint zéro. Il passe à `0` (faux, échu) dès l'expiration de la consigne. Le repositionner via une action le relance.

## Exemple de définition

    /* Nous sommes dans le DLS "CHAUDIERE" */
    #define MON_WATCHDOG <-> _WATCHDOG (libelle="Temps de refresh", consigne=600);

## Usage d'un Watchdog

    /* Si MON_WATCHDOG est en décompte alors on affiche le message */
    - MON_WATCHDOG → MSG_WATCHDOG_EN_DECOMPTE;
    /* Si MON_WATCHDOG est échu, on le relance avec une nouvelle consigne */
    - /MON_WATCHDOG → MON_WATCHDOG(consigne=1200);
