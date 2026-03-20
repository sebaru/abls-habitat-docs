# Les Sorties Analogiques _AO

Une sortie analogique est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_AO*.

Contrairement aux [sorties TOR](dls_sortie_tor.md) qui ne peuvent prendre que les valeurs 0 ou 1, une sortie analogique représente une **valeur réelle** à appliquer sur un actionneur (vanne proportionnelle, variateur de fréquence, consigne de régulateur, ...).

Elle peut être positionnée dans une **LISTE_ACTIONS** via une expression `arithmétique`, et utilisée dans une **EXPRESSION** pour des comparaisons.

La valeur d'une sortie analogique est transmise au [connecteur](connecteurs.md) physique auquel elle est associée.

## Déclarer une Sortie Analogique

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez une sortie analogique de la manière suivante:

    #define ACRONYME <-> _AO(libelle="Ma consigne de chauffe", unite="°C");

La définition commence par le mot clé `#define`, puis une chaine de caractères représentant l'**ACRONYME** de la sortie, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe `_AO`, éventuellement des options entre parenthèses, et enfin un point virgule terminal.

## Les options d'une sortie analogique

### Options à la déclaration

* **libelle**: permet de documenter le rôle de cette sortie dans le module D.L.S. Hérité du connecteur associé si non renseigné.
* **unite**: représente l'unité physique de la valeur à appliquer (ex: `"°C"`, `"Hz"`, `"V"`, `"%"`). Par défaut vide.
* **archivage**: période d'archivage des changements de valeur, exprimée en dixièmes de secondes. Par défaut 0 (pas d'archivage).

Exemple :

    #define CONSIGNE_CHAUD <-> _AO(libelle="Consigne chaudière départ", unite="°C", archivage=3600);

## Positionnement

Une sortie analogique reçoit sa valeur depuis une expression `arithmétique` :

    /* Forcer la consigne à une valeur fixe */
    - 65.0 → CONSIGNE_CHAUD;

    /* Transférer la valeur d'un registre */
    - CONSIGNE_REGISTRE → CONSIGNE_CHAUD;

    /* Calculer la consigne en fonction d'une entrée */
    - TEMP_EXT * (-1.5) + 75.0 → CONSIGNE_CHAUD;

## Exemple d'usage

    /* Nous sommes dans le DLS "CHAUDIERE" */
    #define CONSIGNE_DEPART  <-> _AO(libelle="Consigne température départ", unite="°C");
    #define TEMP_EXT         <-> _AI(libelle="Température extérieure",  unite="°C");
    #define MODE_CONFORT     <-> _B(libelle="Mode confort actif");
    #define MODE_ECO         <-> _B(libelle="Mode économique actif");

    /* Courbe de chauffe : consigne départ = -1.5 * Temp_ext + 75 */
    - MODE_CONFORT → -1.5 * TEMP_EXT + 75.0 → CONSIGNE_DEPART;

    /* Mode éco : température réduite de 5°C */
    - MODE_ECO → -1.5 * TEMP_EXT + 70.0 → CONSIGNE_DEPART;

    /* Vérification de cohérence : alarme si la consigne calculée est trop élevée */
    - CONSIGNE_DEPART > 90.0 → MSG_CONSIGNE_HAUTE;

!!! warning
    Une sortie analogique ne peut être positionnée que dans le module D.L.S à qui elle appartient.
    Positionner la sortie analogique d'un autre module D.L.S lèvera une erreur à la compilation.

!!! tip
    Pour les régulations PID, il est recommandé d'utiliser la fonction [_PID](dls_calculs.md#regulateur-pid) qui calculera automatiquement la valeur à appliquer en sortie.
