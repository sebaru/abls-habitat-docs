# Les Monostables _M

Un monostable est un bit interne de la [mémoire d'information](dls.md#memoire-d'informations), de classse *_M*.

Chaque monostable a pour valeur booléenne soit 0, soit 1.
Il peut etre utilisé dans une **EXPRESSION**, ou dans une **LISTE_ACTIONS**

## Déclarer un Monostable

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez un monostable de la manière suivante:

    #define ACRONYME <-> _M(libelle="Ceci est mon monostable");

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** de l'entrée, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _M, un couple de parenthèses, et enfin un point virgule terminal.

De manière optionnelle, il est possible d'adjoindre un libellé au monostable en lui ajoutant l'option `libelle`.

## Les options d'un monostable

Dans une **EXPRESSION**, il est possible de moduler la sémantique du bit interne en utilisant les options suivantes:

* **edge_up**: permet de ne prendre en compte que les fronts montants (vrai lorsque l'entrée passe de 0 à 1)
* **edge_down**: permet de ne prendre en compte que les fronts descendants (vrai lorsque l'entrée passe de 1 à 0)

## Positionnement

Prenons en exemple:

    /* Entre 10h et 11h, on veut chauffer */
    - MA_CONDITION → MON_MONOSTABLE;

Si MA_CONDITION est VRAIE, alors MON_MONOSTABLE devient VRAI.

Si MA_CONDITION devient FAUSSE alors MON_MONOSTABLE devient FAUX également.

!!! tip
    De part la nature evenementiel des monostables, il est conseillé de n'avoir qu'une seule et unique ligne D.L.S positionnant un monostable donné.

## Exemple d'usage

    /* Nous sommes dans le DLS "PORTE" */
    #define WANT_CHAUFFE <-> _M (libelle="Demande de chauffe");

### Usage dans une EXPRESSION

    /* Entre 10h et 11h, on veut chauffer */
    - _HEURE > 10:00 . _HEURE < 11:00 → WANT_CHAUFFE;
    - WANT_CHAUFFE(edge_up) → MON_BISTABLE; /* Si WANT_CHAUFFE passe de 0 à 1, MON_BISTABLE est positionné à 1 */
    - WANT_CHAUFFE(edge_down) → MON_BISTABLE; /* Si WANT_CHAUFFE passe de 1 à 0, MON_BISTABLE est positionné à 0 */

!!! warning
    Un monostable ne peut etre positionné que dans le module D.L.S à qui il appartient.
    Le positionnement d'un monostable d'un autre module D.L.S lévera une erreur à la compilation.
