# Les Entrées T.O.R _E ou _DI

Une entrée TOR (Tout Ou Rien) est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_E* ou *_DI*.

Chaque entrée TOR a pour valeur booléenne soit 0, soit 1, et ne peut être utilisée que dans une **EXPRESSION**.

## Déclarer une Entrée TOR

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez une entrée TOR de la manière suivante:

    #define ACRONYME <-> _DI();

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** de l'entrée, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _DI, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'une entrée TOR

### Options à la déclaration

* **libelle**: permet de documenter le rôle de cette entrée dans le module D.L.S.
* **map_sms**: associe une commande SMS à cette entrée. Lorsqu'un SMS contenant cette chaîne est reçu par le système, l'entrée est activée ponctuellement.

Exemple :

    #define SONNETTE <-> _DI(libelle="Sonnette d'entrée", map_sms="sonnette");

!!! tip
    Le libellé d'une entrée TOR est hérité de la configuration du [connecteur](connecteurs.md) qui lui est associé. L'option `libelle` dans le `#define` permet de le surcharger ou de le définir pour les entrées sans connecteur physique.

### Options d'usage dans une EXPRESSION

* **edge_up**: permet de ne prendre en compte que les fronts montants (vrai lorsque l'entrée passe de 0 à 1)
* **edge_down**: permet de ne prendre en compte que les fronts descendants (vrai lorsque l'entrée passe de 1 à 0)

## Exemple de définition

    /* Nous sommes dans le DLS "PORTE" */
    #define MON_ENTREE <-> _DI (libelle="Capteur d'ouverture de la porte");

## Usage dans une EXPRESSION

    - MON_ENTREE → MON_BISTABLE;       /* Si MON_ENTREE = 1 alors MON_BISTABLE = 1 */
    - /MON_ENTREE → /MON_BISTABLE;     /* Si MON_ENTREE = 0 alors MON_BISTABLE = 0 */
    - MON_ENTREE(edge_up) → MON_BISTABLE; /* Si MON_ENTREE passe de 0 à 1, MON_BISTABLE est positionné à 1 */
    - MON_ENTREE(edge_down) → MON_BISTABLE; /* Si MON_ENTREE passe de 1 à 0, MON_BISTABLE est positionné à 0 */

