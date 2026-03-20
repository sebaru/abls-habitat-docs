# Les Horloges _HORLOGE

Une horloge est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_HORLOGE*.

Chaque horloge a pour valeur booléenne soit 0, soit 1. Elle représente un **événement horaire ponctuel** : elle passe à 1 exactement à une heure et une minute précises, puis retombe à 0 à la minute suivante.

Elle peut uniquement être utilisée dans une **EXPRESSION** (valeur booléenne). Il n'est pas possible de la positionner manuellement depuis le code D.L.S.

!!! note
    La programmation des horaires (heure, minute) d'une horloge se fait **depuis l'interface web**, dans la configuration du module D.L.S, et non dans le code source. Le code D.L.S se contente de déclarer l'horloge et de l'utiliser.

## Déclarer une Horloge

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez une horloge de la manière suivante:

    #define ACRONYME <-> _HORLOGE(libelle="Mon événement horaire");

La définition commence par le mot clé `#define`, puis une chaine de caractères représentant l'**ACRONYME** de l'horloge, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe `_HORLOGE`, un couple de parenthèses, et enfin un point virgule terminal.

## Les options d'une horloge

### Options à la déclaration

* **libelle**: permet de documenter l'événement représenté par cette horloge.

Exemple :

    #define REVEIL_MATIN   <-> _HORLOGE(libelle="Réveil du matin en semaine");
    #define HEURE_COUCHER  <-> _HORLOGE(libelle="Heure de coucher");

## Programmation des horaires

Les horaires associés à chaque horloge sont configurés depuis l'interface web dans la section **Configuration → Modules D.L.S**, onglet **Horloges**. Il est possible d'associer à une horloge :

* une ou plusieurs **plages horaires** (heure + minute)
* éventuellement filtrées par **jour de la semaine**

Lorsque l'heure courante correspond exactement à un des horaires configurés, l'horloge passe à 1 pour la durée d'une minute, puis revient à 0.

## Usage dans une EXPRESSION

L'horloge s'utilise dans une expression comme n'importe quel bit booléen.
Sa valeur est 1 uniquement à la minute programmée.

### Déclenchement ponctuel à une heure précise

    /* Chaque fois que l'horloge REVEIL_MATIN sonne, on ouvre les volets */
    - REVEIL_MATIN → VOLETS:OUVERTURE(mono);

### Combinaison avec d'autres conditions

    /* On n'ouvre les volets au réveil que si on est en mode présence */
    - REVEIL_MATIN . MODE:PRESENCE → VOLETS:OUVERTURE(mono);

### Bascule d'un bistable

    /* Mise en veille au coucher */
    - HEURE_COUCHER → MAISON:MODE_VEILLE;

    /* Sortie de veille au réveil */
    - REVEIL_MATIN → /MAISON:MODE_VEILLE;

## Exemple complet

    /* Nous sommes dans le DLS "VOLETS" */
    #define OUV_MATIN     <-> _HORLOGE(libelle="Ouverture des volets le matin");
    #define FERM_SOIR     <-> _HORLOGE(libelle="Fermeture des volets le soir");
    #define VOLET_SALON   <-> _DO(libelle="Sortie ouverture volet salon");

    /* À l'heure programmée le matin : on ouvre */
    - OUV_MATIN  → VOLET_SALON;

    /* À l'heure programmée le soir : on ferme */
    - FERM_SOIR  → /VOLET_SALON;

!!! tip
    Pour des comparaisons d'heure en continu (ex : « entre 9h et 18h »), préférez l'utilisation du mot clef `_HEURE` dans une [comparaison horaire](dls_logique.md#les-comparaisons-horaires) plutôt qu'une horloge.
    Les horloges sont réservées aux déclenchements **ponctuels** à une heure précise.
