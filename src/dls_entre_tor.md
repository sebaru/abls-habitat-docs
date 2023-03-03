# Les Entrées T.O.R _E ou _DI

Une entrée TOR (Tout Ou Rien) est un bit interne de la [mémoire d'information](dls.md#memoire-d'informations), de classse *_E* ou *_DI*.

Chaque entrée TOR a pour valeur booléenne soit 0, soit 1, et ne peut être utilisée que dans une **EXPRESSION**.

## Déclarer une Entrée TOR

Dans la zone d'[ALIAS](dls_alias.md), déclarez une entrée TOR de la manière suivante:

    #define ACRONYME <-> _E();

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** de l'entrée, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _E, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'une entrée TOR

Dans une **EXPRESSION**, il est possible de moduler la sémantique du bit interne en utilisant les options suivantes:

* **edge_up**: permet de ne prendre en compte que les fronts montants (vrai lorsque l'entrée passe de 0 à 1)
* **edge_down**: permet de ne prendre en compte que les fronts descendants (vrai lorsque l'entrée passe de 1 à 0)

!!! tip
    Une entrée TOR dispose d'un libellé (une description), qui est héritée de la configuration du [connecteur](connecteurs.md) qui lui est associé.

## Exemple d'usage

    /* Nous sommes dans le DLS "PORTE" */
    #define MON_ENTREE <-> _E (libelle="Capteur d'ouverture de la porte");

### Usage dans une EXPRESSION

    - MON_ENTREE → MON_BISTABLE;       /* Si MON_ENTREE = 1 alors MON_BISTABLE = 1 */
    - /MON_ENTREE → /MON_BISTABLE;     /* Si MON_ENTREE = 0 alors MON_BISTABLE = 0 */
    - MON_ENTREE(edge_up) → MON_BISTABLE; /* Si MON_ENTREE passe de 0 à 1, MON_BISTABLE est positionné à 1 */
    - MON_ENTREE(edge_down) → MON_BISTABLE; /* Si MON_ENTREE passe de 1 à 0, MON_BISTABLE est positionné à 0 */

