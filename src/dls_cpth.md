# Les Compteurs Horaire _CH

Un compteur horaire est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_CH*.

Un compteur horaire permet de compter le temps cumulé durant lequel une **CONDITION** est vraie.

Chaque compteur horaire est une valeur entière positive, représentant une durée en dixième de seconde.
Il peut etre positionné dans une **EXPRESSION**, ou bien sous la forme d'une [comparaison](dls_logique.md#les-comparaisons) dans une **CONDITION**.

## Déclarer un compteur horaire

Dans la zone d'[ALIAS](dls_acronyme.md), déclarez un compteur horaire de la manière suivante:

    #define ACRONYME <-> _CH(options);

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** du compteur,
puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _CH, éventuellement des options entre parenthèses, et enfin un point virgule terminal.

## Les options d'un compteur horaire

A la définition:

* **libelle**: La description du bit interne, ce qu'il représente.

Dans le corps d'un module D.L.S:

* **reset**: permet de remettre a 0 le compteur horaire si la condition est vraie.

## Exemple d'usage

    /* Nous sommes dans le DLS "PORTE" */
    #define MON_TEMPS_OUVERTURE <-> _CH (libelle="Temps d'ouverture de la porte d'entrée");

### Usage dans une CONDITION

    - MON_TEMPS_OUVERTURE > 100 → MON_BISTABLE;   /* Si le temps d'ouverture depasse 100 dixièmes soit 10 secondes alors MON_BISTABLE = 1 */

### Usage dans une EXPRESSION

    - PORTE_OUVERTE-> MON_TEMPS_OUVERTURE; /* Si la porte est ouverte, le compteur horaire décompte */
    - APPUI_BOUTON -> MON_TEMPS_OUVERTURE(reset); /* Si le bit APPUI_BOUTON est vrai, alors le compteur revient à 0 */
