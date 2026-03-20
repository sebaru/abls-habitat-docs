# Les Sorties T.O.R _DO

Une sortie TOR (Tout Ou Rien) est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_DO*.

Chaque sortie TOR a pour valeur booléenne soit 0, soit 1. Elle représente l'**état souhaité d'un actionneur** (relais, vanne, voyant, ...).
Elle peut être positionnée dans une **LISTE_ACTIONS**, et être utilisée dans une **EXPRESSION**.

La valeur d'une sortie TOR est transmise au [connecteur](connecteurs.md) physique auquel elle est associée.

## Déclarer une Sortie TOR

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez une sortie TOR de la manière suivante:

    #define ACRONYME <-> _DO();

La définition commence par le mot clé `#define`, puis une chaine de caractères représentant l'**ACRONYME** de la sortie, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe `_DO`, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'une sortie TOR

### Options à la déclaration

* **libelle**: permet de documenter le rôle de cette sortie dans le module D.L.S. Hérité du connecteur associé si non renseigné.
* **archivage**: période d'archivage des changements d'état, exprimée en dixièmes de secondes. Par défaut 0 (pas d'archivage).

Exemple :

    #define POMPE_EAU <-> _DO(libelle="Mise en marche pompe eau chaude", archivage=600);

### Options d'usage dans une EXPRESSION

* **edge_up**: vrai uniquement lors du front montant (lorsque la sortie passe de 0 à 1)
* **edge_down**: vrai uniquement lors du front descendant (lorsque la sortie passe de 1 à 0)

### Options d'usage dans une LISTE_ACTIONS (mode impulsion)

* **mono**: force la sortie en mode **impulsion** : la sortie passe à 1 pendant exactement un cycle d'exécution du module D.L.S, puis revient automatiquement à 0.

Exemple :

    /* POMPE_START ne sera active qu'un seul cycle (impulsion) */
    - MA_CONDITION → POMPE_START(mono);

!!! tip
    Le mode `mono` est utile pour déclencher une action ponctuelle (envoi d'une commande, démarrage d'une séquence) sans avoir à gérer explicitement la remise à 0.

## Positionnement

    /* Si la condition est vraie, la sortie est à 1 ; sinon elle est à 0 */
    - MA_CONDITION → POMPE_EAU;

    /* Forcer la sortie à 0 explicitement */
    - ARRET_URGENCE → /POMPE_EAU;

## Exemple d'usage

    /* Nous sommes dans le DLS "CIRCULATION_EAU" */
    #define POMPE_MARCHE  <-> _DO(libelle="Sortie marche pompe de circulation");
    #define TEMP_DEPART   <-> _AI(libelle="Température de départ", unite="°C");
    #define TEMP_CONSIGNE <-> _REGISTRE(libelle="Consigne température départ", unite="°C");

    /* Mise en marche pompe si la température de départ est en dessous de la consigne */
    - TEMP_DEPART < TEMP_CONSIGNE → POMPE_MARCHE;

    /* Utilisation dans une expression : si la pompe tourne et que la température chute trop */
    - POMPE_MARCHE . TEMP_DEPART < 10.0 → MSG_ALERTE_GEL;

    /* Détection du démarrage effectif de la pompe */
    - POMPE_MARCHE(edge_up) → MSG_DEMARRAGE_POMPE;

!!! warning
    Une sortie TOR ne peut être positionnée que dans le module D.L.S à qui elle appartient.
    Positionner la sortie TOR d'un autre module D.L.S lèvera une erreur à la compilation.
