# Programmation D.L.S: les Acronymes

Un acronyme permet de créer un bit interne dans la [mémoire d'information](dls.md#memoire-d'informations) en lui affectant une classe et des paramètres de configuration.

---
## Déclarer un ACRONYME

Cette zone de code des modules D.L.S permet d'associer un **ACRONYME** à une classe de bit interne au sein d'un module D.L.S représenté par son **TECH_ID**.
Cet **ACRONYME** pourra être utilisé dans le code de fonctionnement du module **TECH_ID** lui-même.
Il pourra également être utilisé dans d'autres modules D.L.S sous sa forme complète **TECH_ID**:**ACRONYME**. Notez le ":" entre le tech_id et l'acronyme.

Il s'agit d'une zone de code dont la syntaxe est la suivante:

    #define ACRONYME <-> _CLASSE;

Elle commence directement par une chaine de caractères représentant l'**ACRONYME**, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »), une Classe, et enfin un point virgule terminal.

---
## Déclarer ses options

Des [options](dls_options.md) peuvent être affectées à un alias, en utilisant la syntaxe suivante :

    #define ACRONYME <-> _CLASSE (OPTIONS); /* OPTIONS étant une liste de champ=valeur, séparée par des virgules ',' */

Les options sont ajoutées sous la forme d'une liste de clef=valeur séparées par des virgules et encadrées par des parenthèses.

---
##Exemples

    #define VOLET_OUVERT <-> _E;            /* VOLET_OUVERT sera mappé à une Entrée Physique (par exemple, à un module MODBUS, ou à la reception d'un SMS) */
    #define CDE_VOLET    <-> _M;            /* CDE_VOLET sera utilisé en tant que monostable dans la suite du code D.L.S */
    #define TEMPO        <-> _T(daa=50);    /* TEMPO est une temporisation retard d'une consigne de 5 secondes */
    #define VISUEL_POMPE <-> _I(forme="pompe", color="red");    /* VISUEL_POMPE est un visuel représenté par une pompe de couleur rouge */

!!! Note
    Les différentes [classes](dls.md#les-classes-de-zone-memoire) sont décrites dans la page [concept](dls.md).
