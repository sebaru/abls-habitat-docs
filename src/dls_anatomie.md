# Programmation D.L.S: Anatomie

Cette page vous propose un modèle d'organisation permettant de bénéficier de la souplesse apportée par la solution.

Prenons l'exemple du besoin: *piloter un luminaire*.
Le découpage proposé est le suivant:

* Un module **maitre** assurant le pilotage direct d'un actionneur, en gérant les visuels, les défauts et les notifications associés.
* Un module **controle** permettant de visualiser les éléments de mesures de associés à l'objet. Ce module sera suffixé par **_CTRL**.
* Un module **commande** dont le rôle sera de gérer les évènements reçu par le système et de faire appel au maitre pour lui envoyer des ordres. Ce module sera suffixé par **_CMDE**.
* Un module **maintenance** dont le rôle sera de gérer les évènements reçu par le système et de faire appel au maitre pour lui envoyer des ordres. Ce module sera suffixé par **_MTCE**.

Ainsi, pour un tétérupteur pilotant l'éclairage d'une cour par exemple, dont le `tech_id` serait **ECLCOUR**, les modules seront les suivants:

* [ECLCOUR](#anatomie-du-module-maitre-eclcour)
* [ECLCOUR_CTRL](#anatomie-dun-module-de-controle-eclcour)
* [ECLCOUR_CMDE](#anatomie-dun-module-de-commande-eclcour)
* [ECLCOUR_MTCE](#anatomie-dun-module-de-maintenance-eclcour)

---
## Anatomie du module maitre ECLCOUR

### Cartouche

    /*****************************************************************************/
    /*  Module ECLCOUR                                                09/05/2023 */
    /*  Ce module pilote l'éclairage de la cour                                  */
    /*****************************************************************************/

### Définition des entrées/sorties physiques ou interne

    /* ENTREES PHYSIQUES */
     #define POS_TL              <-> _DI; /* Position Télérupteur Eclairage Cour */

    /* ORDRES INTERNES ~~~~~~~~~~~~~*/
     #define O_ALLUMER           <-> _DI;               /* Demande d'allumage TL */
     #define O_ETEINDRE          <-> _DI;             /* Demande d'extinction TL */

    /* SORTIES PHYSIQUES */
     #define ACT_TL              <-> _DO;   /* Sortie de pilotage du télérupteur */

### Définition des visuels et des messages:

    /* VISUELS */
     #define VISU_POS_TL         <-> _I(forme="ampoule"); /* Position Télérupteur */

    /* MESSAGES */
     #define MSG_TELE_OFF          <-> _MSG(type=etat,libelle="Eclairage Cour éteint"); /* TL désactivé */
     #define MSG_TELE_ON           <-> _MSG(type=etat,libelle="Eclairage Cour actif");  /* TL activé */
     #define MSG_DEF_REPOS         <-> _MSG(type=defaut,libelle="Défaut repos");        /* Defaut repos */
     #define MSG_DEF_TRAVAIL       <-> _MSG(type=defaut,libelle="Défaut travail");      /* Defaut travail */

### Définition des compteurs

    /* Compteurs */
     #define CHPROCEDE       <->_CH(libelle="Duré de vie du procédé");
     #define CHSERVICE       <->_CH(libelle="Cadran Horloge Durée Service de l'Eclairage Cour");
     #define CIACTIONS       <->_CI(libelle="Compteur Itérations Actions Télérupteur de l'Eclairage Cour");

### Définition des temporisations

     #define TR_DEF                <-> _T(daa=10,dma=0,dMa=0,dad=0,libelle="Temporisation de détection de défaut après manoeuvre");
     #define TR_IMP                <-> _T(daa= 0,dma=0,dMa=3,dad=0,libelle="Temporisation d'impulsion pour manoeuvrer le télérupteur");

### Définition des bits internes au module

    /* Bistables et monostables internes */
     #define MDEF_REPOS            <-> _B(libelle="Mémorisation du défaut repos non acquitté du TL");
     #define MDEF_REPOS_F          <-> _B(libelle="Mémorisation du défaut repos acquitté (Fixe) du TL");
     #define MDEF_TRAVAIL          <-> _B(libelle="Mémorisation du défaut travail non acquitté du TL");
     #define MDEF_TRAVAIL_F        <-> _B(libelle="Mémorisation du défaut travail acquitté (Fixe) du TL");
     #define MEWANTTL              <-> _B(libelle="Etat attendu du TL (0=ouvert, 1=fermé)");
     #define MEACTELE              <-> _B(libelle="Demande de manoeuvre du TL (changement d'état)");
     #define ME_MTCE               <-> _B(libelle="Mémo Etat <maintenance> de l'Eclairage Cour");

### Mesures de précaution à l'allumage

    /* Start */
    - _START -> /ACT_TL;    /* Au start, on fait tomber la sortie */

### Vient ensuite la réaction aux evenements:

    /* Evenements */
    -_TRUE   -> CHPROCEDE;                          /* Durée total Procédé */
    - POS_TL -> CHSERVICE;              /* Durée de Service du Télérupteur */

    - POS_TL(edge_up) + POS_TL(edge_down)

### Le calcul de l'état attendu

    /* CALCUL ETAT ATTENDU TELERUPTEUR */
    - MEMSA_OK. O_ALLUMER. /POS_TL -> MEWANTTL, MEACTELE;
    - MEMSA_OK. O_ETEINDRE. POS_TL ->/MEWANTTL, MEACTELE;

### Le pilotage physique

    /* PILOTAGE TELE SUR COMMANDE DE MANOEUVRE */
    - MEMSA_OK. MEACTELE -> TR_IMP, TR_DEF;
    /* Envoie de la sortie +1 Cpt Actions Télérupteur */
    - TR_IMP             -> ACT_TL, CIACTIONS;
    /* Fin de la tempo, fin de l'impulsion */
    -/TR_IMP + /MEMSA_OK ->/ACT_TL;

    /* FIN DE MANOEUVRE */
    - TR_DEF -> /MEACTELE;

### La gestion des défauts

Le template de détection des défauts est le suivant:

    /* Detections du défaut */
    - TR_DEF . **Condition_du_defaut** . /MDEF_FIXE -> MDEF;
    /* Acquit intéractif du defaut */
    - OSYN_ACQUIT . MDEF ->/MDEF, MDEF_FIXE;
    /* RAZ du défaut */
    - **Condition_de_RAZ** -> MDEF_FIXE;
    /* Notification du défaut */
    - MDEF + MDEF_FIXE -> MSG_DEFAUT;

Sur l'exemple de l'éclairage cour, cela donnerai pour le défaut Repos (le télérupteur reste bloqué sur ON et ne peut redescendre à OFF):

    /* Détection Discordance Repos du Télérupteur */
    - TR_DEF ./ME_MTCE . POS_TL . /MEWANTTL ./MDEF_REPOS_F
                                -> MDEF_REPOS;
    - OSYN_ACQUIT . MDEF_REPOS  ->/MDEF_REPOS, MDEF_REPOS_F;
    -/POS_TL . MDEF_REPOS_F     ->/MDEF_REPOS_F;
    - MDEF_REPOS + MDEF_REPOS_F -> MEMSA_DEFAUT;

### Le reporting

Ces remontées servent à gérer les indices de défaut sur la page synoptique associé à ce module D.L.S.

    /* ACTIVITE - Report Défaut et Anomalie */

    - MDEF_REPOS + MDEF_TRAVAIL     -> MEMSA_DEFAUT;
    - MDEF_REPOS_F + MDEF_TRAVAIL_F -> MEMSA_DEFAUT_FIXE;

    /* SECURITES DES BIENS - Report Veille et Alerte */
    - _TRUE  -> MEMSSB_VEILLE;
    - _FALSE -> MEMSSB_ALERTE;
    - _FALSE -> MEMSSB_ALERTE_FIXE;

    /* SECURITES DES PERSONNES - Report Danger et dérangement */
    - _FALSE -> MEMSSP_DERANGEMENT;
    - _FALSE -> MEMSSP_DERANGEMENT_FIXE;
    - _FALSE -> MEMSSP_DANGER;
    - _FALSE -> MEMSSP_DANGER_FIXE;

### Affichage des visuels

    switch
     | - MDEF_TRAVAIL  -> VISU_POS_TL(mode="off", cligno, libelle="Défaut travail");
     | - MDEF_REPOS    -> VISU_POS_TL(mode="on",  cligno, libelle="Défaut repos");
     | - POS_TL        -> VISU_POS_TL(mode="on",  libelle="Eclairage Cour allumé");
     | -               -> VISU_POS_TL(mode="off", libelle="Eclairage Cour en attente");

### Notification par messages
    /* Edition des messages */
    -/POS_TL                        -> MSG_TELE_OFF;
    - POS_TL                        -> MSG_TELE_ON;



## Anatomie d'un module de controle ECLCOUR
## Anatomie d'un module de commande ECLCOUR
## Anatomie d'un module de maintenance ECLCOUR
