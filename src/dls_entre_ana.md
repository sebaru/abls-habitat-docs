# Les Entrées Analogiques _AI

Une entrée analogique est un bit interne de la [mémoire d'information](dls.md#memoire-dinformations), de classe *_AI*.

Contrairement aux [entrées TOR](dls_entre_tor.md) qui n'ont que 2 états (0 ou 1), une entrée analogique représente une **valeur réelle** mesurée par un capteur (température, pression, débit, tension, ...).

Elle peut être utilisée dans une **EXPRESSION** en tant qu'unité `arithmétique`, notamment dans des [comparaisons](dls_logique.md#les-comparaisons) ou des [calculs](dls_calculs.md).

## Déclarer une Entrée Analogique

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez une entrée analogique de la manière suivante:

    #define ACRONYME <-> _AI(libelle="Ma sonde de température", unite="°C");

La définition commence par le mot clé `#define`, puis une chaine de caractères représentant l'**ACRONYME** de l'entrée, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe `_AI`, éventuellement des options entre parenthèses, et enfin un point virgule terminal.

## Les options d'une entrée analogique

### Options à la déclaration

* **libelle**: permet de documenter le rôle de cette entrée dans le module D.L.S. Hérité du connecteur associé si non renseigné.
* **unite**: représente l'unité physique de la valeur mesurée (ex: `"°C"`, `"kPa"`, `"m³/h"`, `"V"`, `"A"`). Par défaut vide.
* **archivage**: période d'archivage des valeurs en base de données, exprimée en dixièmes de secondes. Permet de conserver un historique. Par défaut 0 (pas d'archivage).

Exemple :

    #define TEMP_EXT <-> _AI(libelle="Température extérieure", unite="°C", archivage=3600);

!!! tip
    Le libellé et l'unité d'une entrée analogique sont normalement hérités de la configuration du [connecteur](connecteurs.md) qui l'alimente (Modbus, Phidget, Météo, ...). L'option `libelle` dans le `#define` permet de les surcharger.

## Usage dans une EXPRESSION

Une entrée analogique s'utilise dans une expression pour :

### Comparaison (résultat booléen)

    /* Si la température extérieure dépasse 30°C, on active la climatisation */
    - TEMP_EXT > 30.0 → CLIM:MARCHE;

    /* Si la température est inférieure à 0°C, alerte gel */
    - TEMP_EXT < 0.0 → MSG_ALERTE_GEL;

    /* Entre 18°C et 21°C : confort thermique */
    - TEMP_INT >= 18.0 . TEMP_INT <= 21.0 → CONFORT_THERMIQUE;

### Calcul (résultat arithmétique)

    /* Stockage de la valeur dans un registre */
    - TEMP_EXT → MON_REGISTRE;

    /* Calcul de différence */
    - TEMP_INT - TEMP_EXT → DELTA_TEMP;

## Exemple complet

    /* Nous sommes dans le DLS "CHAUFFAGE" */
    #define TEMP_ENTREE  <-> _AI(libelle="Température water d'entrée chaudière", unite="°C");
    #define TEMP_SORTIE  <-> _AI(libelle="Température water de sortie chaudière", unite="°C");
    #define DELTA        <-> _REGISTRE(libelle="Delta température", unite="°C");

    /* Calcul du delta entre entrée et sortie */
    - TEMP_SORTIE - TEMP_ENTREE → DELTA;

    /* Alarme si le delta est trop faible: échangeur encrassé ? */
    - DELTA < 5.0 → MSG_DELTA_FAIBLE;

!!! warning
    Une entrée analogique est en lecture seule dans le code D.L.S. Sa valeur est imposée par le connecteur physique associé.
    Il n'est pas possible de lui affecter directement une valeur depuis le code D.L.S.
    Pour manipuler des valeurs calculées, utilisez un [registre](dls_registres.md).
