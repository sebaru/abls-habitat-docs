# Les Bistables _B

Un bistable est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_B*.

Chaque bistable a pour valeur booléenne soit 0, soit 1.
Il peut être utilisé dans une **EXPRESSION**, ou dans une **LISTE_ACTIONS**.

Contrairement au [monostable](dls_monostables.md), un bistable est **maintenu dans le temps** : une fois positionné à 1, sa valeur reste à 1 même si la condition qui l'a activé disparaît. Il faut explicitement coder le passage à 0.

## Déclarer un Bistable

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez un bistable de la manière suivante:

    #define ACRONYME <-> _B(libelle="Ceci est mon bistable");

La définition commence par le mot clé `#define`, puis une chaine de caractères représentant l'**ACRONYME** du bistable, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe `_B`, un couple de parenthèses, et enfin un point virgule terminal.

De manière optionnelle, il est possible d'adjoindre un libellé au bistable en lui ajoutant l'option `libelle`.

## Les options d'un bistable

### Options à la déclaration

* **libelle**: permet de documenter le rôle du bistable.
* **groupe**: permet de créer un groupe de bistables mutuellement exclusifs. Lorsqu'un bistable du groupe est activé, tous les autres bistables du même groupe sont automatiquement remis à 0. Le groupe est représenté par un entier dont la portée est limitée au module D.L.S propriétaire.

Exemple :

    /* Un seul mode actif à la fois parmi les trois */
    #define MODE_ECO    <-> _B(libelle="Mode économique",  groupe=1);
    #define MODE_CONFORT <-> _B(libelle="Mode confort",    groupe=1);
    #define MODE_HORS_GEL <-> _B(libelle="Mode hors-gel", groupe=1);

### Options d'usage dans une EXPRESSION

* **edge_up**: permet de ne prendre en compte que les fronts montants (vrai lorsque le bistable passe de 0 à 1)
* **edge_down**: permet de ne prendre en compte que les fronts descendants (vrai lorsque le bistable passe de 1 à 0)

## Positionnement

La différence fondamentale avec le monostable est qu'il faut **deux lignes distinctes** pour gérer la montée à 1 et le retour à 0.

Prenons en exemple:

    /* Si la porte est ouverte, on mémorise l'intrusion */
    - PORTE_OUVERTE → MON_BISTABLE;

    /* Si l'utilisateur acquitte, on efface la mémorisation */
    - ACQUIT → /MON_BISTABLE;

Si `PORTE_OUVERTE` devient FALSE, `MON_BISTABLE` **reste quand même à 1** jusqu'à ce que la deuxième ligne soit évaluée vraie.

!!! tip
    Par convention, le `/` devant un bistable en **LISTE_ACTIONS** le force à 0. Il n'existe pas d'opérateur spécifique de RAZ : c'est le même mécanisme que pour toute action de mise à 0 (`/BISTABLE`).

## Exemple d'usage

    /* Nous sommes dans le DLS "ALARME" */
    #define INTRUSION <-> _B(libelle="Mémorisation d'une intrusion");
    #define ACQUIT    <-> _DI(libelle="Bouton d'acquittement");

    /* Positionnement à 1 : lorsque la porte est ouverte */
    - PORTE:OUVERTE → INTRUSION;

    /* Remise à 0 : sur acquit opérateur */
    - ACQUIT → /INTRUSION;

    /* Utilisation dans une expression : si on est en intrusion et qu'il fait nuit */
    - INTRUSION . NUIT:ACTIF → MSG_ALARME_INTRU;

### Usage des options edge_up / edge_down

    /* MON_BISTABLE passe de 0 à 1 : on envoie une notification */
    - MON_BISTABLE(edge_up) → MSG_MONTEE;

    /* MON_BISTABLE passe de 1 à 0 : on envoie une autre notification */
    - MON_BISTABLE(edge_down) → MSG_DESCENTE;

!!! warning
    Un bistable ne peut être positionné que dans le module D.L.S à qui il appartient.
    Le positionnement d'un bistable d'un autre module D.L.S lèvera une erreur à la compilation.
