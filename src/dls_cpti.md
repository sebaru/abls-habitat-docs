# Les Compteurs d'Impulsions _CI

Un compteur d'impulsion est un bit interne de la [mémoire d'information](dls.md#memoire-d'informations), de classse *_CI*.

Un compteur d'impulsion permet de compter le nombre de fois qu'une **CONDITION** passe de l'état 0 à l'état 1.

Chaque compteur d'impulsion a pour valeur un entier positif.
Il peut etre positionné dans une **EXPRESSION**, ou bien sous la forme d'une [comparaison](dls_logique.md#les-comparaisons) dans une **CONDITION**.


## Déclarer un compteur d'impulsion

Dans la zone d'[ALIAS](dls_acronyme.md), déclarez un compteur d'impulsion de la manière suivante:

    #define ACRONYME <-> _CI(options);

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** du compteur,
puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _CI, éventuellement des options entre parenthèses, et enfin un point virgule terminal.

## Les options d'un compteur d'impulsion

A la définition:

* **libelle**: La description du bit interne, ce qu'il représente.
* **ratio**: Permet de définir le nombre de passage de 0 à 1 de la condition avant d'augmenter de 1 la valeur du compteur.
* **multi**: considère que la valeur du compteur est multipliée par cet entier avant d'etre évaluée.

Dans le corps d'un module D.L.S:

* **reset**: permet de remettre a 0 le compteur d'impulsion si la condition est vraie.

## Exemple d'usage

    /* Nous sommes dans le DLS "PORTE" */
    #define MON_COMPTEUR_OUVERTURE <-> _CI (libelle="Nombre d'ouverture de la porte d'entrée");
    #define MON_COMPTEUR_LITRE     <-> _CI (libelle="Nombre de litres de chasse d'eau", multi=6); /* Une chasse d'eau est équivalente à 6 litres d'eau */
    #define MON_COMPTEUR_RALENTI   <-> _CI (libelle="Nombre de litres d'eau", multi=10); /* Si le capteur de debit donne une impulsion tous les 1/10 de litre */

### Usage dans une CONDITION

    - MON_COMPTEUR_OUVERTURE > 10 → MON_BISTABLE;   /* Si le nombre d'ouverture depasse 10 alors MON_BISTABLE = 1 */

### Usage dans une EXPRESSION

    - PORTE_OUVERTE-> MON_COMPTEUR_OUVERTURE; /* Si la porte s'ouvre, le compteur d'ouverture d'incrémente */
    - APPUI_BOUTON -> MON_COMPTEUR_OUVERTURE(reset); /* Si le bit APPUI_BOUTON est vrai, alors le compteur revient à 0 */

