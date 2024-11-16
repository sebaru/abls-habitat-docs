# Les Registres _REGISTRE

Un registre est un bit interne de la [mémoire d'information](dls.md#memoire-d'informations), de classe *_R* ou *_REGISTRE*.

Chaque registre est un contenant pour une valeur réelle.

Il peut être utilisé dans une **EXPRESSION** en utilisant les opérateurs de [comparaison](dls_logique.md(lescomparaisons).

Il peut également être utilisé dans une **ACTION**, en tant que receptable d'un calcul exprimé en tant qu'**EXPRESSION**.

## Déclarer un REGISTRE

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez un registre de la manière suivante:

    #define ACRONYME <-> _REGISTRE();

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** du registre, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _R ou _REGISTRE, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'un registre

Dans sa définition, il est possible d'ajouter des options à un registre.

* **libelle**: permet de positionner un registre pour expliciter la finalité du bit interne
* **unite**: represente l'unité de la valeur du registre

## Exemple de définition

    /* Nous sommes dans le DLS "EAU" */
    /* Exemple pour un registre représentant un débit cumulé d'eau */
    /* exprimé en litres par seconde L/s */
    #define MON_REGISTRE <-> _REGISTRE(libelle="Débit cumulé", unite="L/s");

## Usage dans une EXPRESSION

    /* Nous sommes dans le DLS "VENT.dls */
    #define VITESSE <-> _R(libelle="vitesse du vent", unite="m/s");
    /* Le registre VITESSE est augmentée d'une valeur de 1.0 */
    - VITESSE + 1.0 -> VITESSE;
