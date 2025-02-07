# La programmation D.L.S

Les modules portant l'intelligence sont nommés ***Module D.L.S***.
Ils permettent, via un langage de programmation inspiré des automates, de définir quel doit être l'état de sortie d'un objet en fonction d'un ensemble d'états d'entrés.

!!! note
    Dans l'interface web, vous pouvez lister et éditer ces modules D.L.S en utilisant le menu **Configuration->Modules D.L.S**.

---
## Mémoire d'informations

L'ensemble des différents modules D.L.S partagent la même mémoire d'informations. Toutes les informations sont accessibles en lecture et écriture par tous les plugins D.L.S.

Chaque élément est caractérisé

* par sa **classe** : une entrée, une sortie, un message, un compteur, ...
* par son **tech_id**, représentant le module D.L.S auquel il est rattaché
* par son **acronyme**, représentant son nom dans la mémoire d'information

Par exemple: le bit **GARAGE:OUVERTURE** peut représenter une entrée correspondant à l'état d'OUVERTURE ou de fermeture de l'ouvrant GARAGE.

Ou encore, le bit **PORTAIL:NBR_OUVERTURE** peut représenter un compteur associé au nombre d'ouverture du PORTAIL.

Deux bits de deux modules différents peuvent porter le même acronyme, dans la mesure ou leurs tech_id seront différents. Exemple : **JARDIN:TEMPERATURE** et **CUISINE:TEMPERATURE**

!!! Note
    Par construction, dans un code source D.L.S, si un bit interne ne spécifie pas son tech_id, celui du module D.L.S d'appartenance est utilisé.

---
## Architecture d'un module D.L.S

Un module D.L.S présentera plusieurs zones de code :

* la zone de définition des [**Acronymes**](dls_acronymes.md)
* la zone de définition des [**Liens**](dls_link.md)
* la zone de description du fonctionnement portant la [**logique**](dls_logique.md) et les [**calculs**](dls_calculs.md)

---
## Les classes de zone mémoire

Les différentes classes proposées sont les suivantes:

* [_DI](dls_entre_tor.md) est une **entrée TOR**. L'entrée peut avoir 2 valeurs: 0 ou 1 et représente l'état physique d'un capteur.
* [_AI](dls_entre_ana.md) est une **entrée analogique** est représentée par la classe . Une entrée Analogique représente une valeur d'un capteur analogique. Celle-ci dispose d'options permettant au systeme de savoir comment interpréter les informations fournies par les capteurs (4/20mA, 0-10V, ...)
* [_DO](dls_sortie_tor.md) est une **sortie TOR** est représentée par la classe . Une sortie TOR peut avoir 2 valeurs : 0 ou 1, et représente l'état souhaité d'un actionneur.
* [_AO](dls_sortie_ana.md) est une **sortie analogique** est représentée par la classe . Une sortie Analogique represente la valeur souhaitée d'un actionneur analogique. Elle dispose d'options permettant au systeme de traduire une valeur reelle en valeurcompréhensible par les actionneurs.
* [_B](dls_bistables.md) est un **bistable**. Bit dont la valeur est 0 ou 1, maintenu dans le temps. Il faut explicitement coder la mise à zero du bit pour que celui-ci soit effectivement remis à 0.
* [_M](dls_monostables.md) est un **monostable**. Les monostables sont des bits furtifs, non maintenus dans le temps. Si la condition initiale qui imposait le maintien du bit n'est plus vraie,ce bit va alors tomber de lui-meme à 0.
* [_CI](dls_cpti.md) est un **compteur d'impulsions**. Incrémenté à chaque front montant de sa condition de pilotage.
* [_CH](dls_cpth.md) est un **compteur Horaire**. Temps seconde représentant la durée effective de maintien de sa condition de pilotage.
* [_T](dls_tempo.md) est une **temporisation**. Les temporisations permettent de décaler, maintenir ou limiter dans le temps un evenement particulier.
* [_REGISTRE](dls_registres.md) est un **registre**. Les registres permettent de manipuler des points de consignes, de seuil,et permettent de réaliser des calculs.
* [_HORLOGE](dls_horloge.md) est une **horloge**. Les horloges sont des éléments binaires positionnées en fonction d'une heure bien précise de la journée.
* [_WATCHDOG](dls_watchdog.md) est un **watchdog**. Les comptes a rebours permettent de decompter le temps à partir d'un evenementet de réagir si cet evenement n'est pas revenu au bout d'une consigne précise.
* [_MSG](dls_messages.md) est un **message**. Les messages permettent de notifier les utilisateurs. Ils sont diffusés dans l'interface, par SMS ou par messagerie instantanée ou par mail.
* [_VISUEL](dls_visuels.md) est un **visuel**. Les visuels représentent des images associés aux objets, sous différentes formes et couleurs.

---
## Les commentaires

Il est possible d'intégrer des commentaires dans un code D.L.S. Utiles pour augmenter le niveau de lisibilité du code, ils permettent
aussi d'accélérer la compréhension du mode de fonctionnement.

Un commentaire commence par la chaine « /\* » et se finit par la chaine « \*/ »
Exemple de syntaxe:

     - a . b → c;                /* Ceci est un commentaire */

##Exemple

    /* Zone de définition des acronymes */
    #define POS_CAPTEUR  <-> _E(libelle="Position du capteur d'ouverture");
    #define MON_COMPTEUR <-> _CI(libelle="Nombre d'ouvertures de la porte");

    /* Zone de définition des liens */
    #link EDF:VISUEL_ECLAIR; /* Lien vers le visuels de l'éclair du module D.L.S EDF. Celui-ci apparaitra sur la page syntoptique de ce module */

    /* Zone de logique et de calcul */
    - POS_CAPTEUR -> MON_COMPTEUR; /* Si la porte est ouverte, on augmente de 1 la valeur de compteur */

---
## Bits locaux

Par construction, certains bits internes sont créés automatiquement. Ces bits sont présentés ci dessous.

| Nom du bit  | Classe  |  Positionné par | Défaut  | Description
|:------------|:--------|:----------------|:-------:|:-----------
| MEMSA_COMM |  Activité  | Module |  TRUE | TRUE si la communication est OK, sinon FALSE.
| MEMSA_DEFAUT|   Activité |  Module |  FALSE | TRUE si le module est en défaut
| MEMSA_DEFAUT_FIXE|   Activité |  Module |  FALSE | TRUE si le module est en défaut fixe
| MEMSA_ALARME|   Activité |  Module |  FALSE| TRUE si le module est en alarme
| MEMSA_ALARME_FIXE |  Activité |  Module |  FALSE| TRUE si le module est en alarme fixe
| MEMSA_OK |  Activité  | Système  | TRUE | Bit de synthèse de l'activité. Calculé par rapport aux 5 bits précédents
| MEMSSB_VEILLE |  Sécurité des Biens |  Module|   FALSE | TRUE si le module est en veille
| MEMSSB_ALERTE |  Sécurité des Biens |  Module |  FALSE | TRUE si le module est en alerte
| MEMSSB_ALERTE_FUGITIVE |  Sécurité des Biens |  Module |  FALSE | TRUE si le module est en alerte fugitive
| MEMSSB_ALERTE_FIXE |  Sécurité des Biens |  Module |  FALSE |  TRUE si le module est en alerte fixe
| MEMSSP_DERANGEMENT |  Sécurité des Personnes |  Module |  FALSE | TRUE si le module est en dérangement
| MEMSSP_DERANGEMENT_FIXE |  Sécurité des Personnes |  Module|   FALSE | TRUE si le module est en dérangement fixe
| MEMSSP_DANGER |  Sécurité des Personnes |  Module |  FALSE | TRUE si le module remonte un danger imminent
| MEMSSP_DANGER_FIXE |  Sécurité des Personnes  | Module |  FALSE |  TRUE si le module remonte un danger imminent (fixe).
| MEMSSP_OK  | Sécurité des Personnes  | Système  | TRUE |  Bit de synthèse de la sécurité des personnes. Calculé par rapport aux 4 bits précédents.
| OSYN_ACQUIT |  Acquit  | Système |  FALSE | Bit positionné par le système lors d'une demande d'acquit synoptique

## Les chaines réservées

Il est possible d'utiliser des chaines de caratères dynamique dans les modules DLS. Celles sont les suivantes:

| Usage        |  Description
|:-------------|:-----------
| $DLS_TECH_ID |  Cette chaine de caractère est remplacée par le TECH_ID du module en cours d'édition.
| $THIS        |  Cette chaine de caractère est remplacée par le TECH_ID du module en cours d'édition.
| $DLS_ID      |  Cette chaine de caractère est remplacée par l'ID numérique du module en cours d'édition.
| $DATE        |  Cette chaine de caractère est remplacée par la date au format JJ/MM/AAAA au moment de la compilation du module.
| $SYN_PAGE    |  Cette chaine de caractère est remplacée par le nom de la page synoptique a laquelle est rattaché le module, au moment de sa compilation.
| $SYN_ID      |  Cette chaine de caractère est remplacée par l'ID numérique de la page synoptique à laquelle est rattaché le module, au moment de sa compilation.
