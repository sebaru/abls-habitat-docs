# Les Messages _MSG

Un message est un bit interne de la [mémoire d'information](dls.md#memoire-d'informations), de classse *_MSG*.

Chaque message peut etre positionné dans une **ACTION**. Il n'est cependant pas possible de l'utiliser avec le complément */*.


## Déclarer un Message

Dans la zone d'[ALIAS](dls_acronymes.md), déclarez un Message de la manière suivante:

    #define ACRONYME <-> _MSG(parametre=valeur);

La définition commence par le mot clé #define, puis une chaine de caractères représentant l'**ACRONYME** du message, puis une double flèche (un inférieur « < », un tiret « - », un supérieur « > »),
la classe _MSG, une liste d'option (sous la forme `parametre`=`valeur`) entourée de parenthèses, et enfin un point virgule terminal.

## Les types des Messages

Dans sa définition, un message permet de spécifier sa typologie. Il existe plusieurs typologies de messages qui peuvent etre précisées
au travers de l'option `type`:

| Périmètre procédé 	| Typologie | Représentation | 	Description
|:------------|:--------:|:----------------|:-------
| Activité | **etat** | ![Etat Message](https://static.abls-habitat.fr/img/info.svg) | Le message a pour vocation d'informer l'utilisateur d'une situation ou d'un évènement sur le procédé. Si la situation ne se présente plus, le message disparait.
| Activité | **defaut** | ![Defaut Message](https://static.abls-habitat.fr/img/pignon_orange.svg) | Une situation de dérive potentiellement momentanée sur le procédé est rencontrée sur le procédé.
| Activité | **alarme** | ![alarme Message](https://static.abls-habitat.fr/img/pignon_red.svg) | Une situation de dérive persistante sur le procédé necessitant une intervention de l'utilisateur est rencontrée.
| Activité | **notification** | ![Notif Message](https://static.abls-habitat.fr/img/notification.svg) | Le message a pour vocation d'informer d'un évènement lié au procédé. Le message reste apparent jusqu'au nouvel évènement du même type.
| Sécurité des biens | **veille** | ![Info Message](https://static.abls-habitat.fr/img/bouclier_green.svg) | Les biens associés au procédé sont sous surveillance.
| Sécurité des biens | **alerte** | ![Info Message](https://static.abls-habitat.fr/img/bouclier_red.svg) | Un évènement particulier met à mal la sécurité des biens associés au procédé.
| Sécurité des personnes | **derangement** | ![Info Message](https://static.abls-habitat.fr/img/croix_orange.svg) | La surveillance de la sécurité des personnes à proximité du procédé n'est que partielle ou inexistante.
| Sécurité des personnes | **danger** | ![Info Message](https://static.abls-habitat.fr/img/croix_red.svg) | Un évènement met en péril la sécurité des personnes à proximité du procédé.

Si non renseignée, la typologie par défaut d'un message est **etat**.

Exemple:

    /* Nous sommes dans le DLS "PORTE" */
    /* Définition d'un message */
    #define MON_MSG <-> _MSG(type=etat, libelle="la porte est ouverte")

    /* Le message 'la porte est ouverte', de typologie info, sera diffusé */
    /* quand la condition 'PORTE_OUVERTE' sera vraie. */
    - PORTE_OUVERTE -> MON_MSG;


## L'option `groupe`

L'option `groupe` peut etre ajoutée à la liste des options d'un message, lors de sa définition.
Cette option permet de creer un groupe de message dans lequel la mise à un d'un message met à zero tous les autres messages du meme groupe.

Le groupe est représenté par un entier, dont la portée est limitée au DLS parent du message. Ainsi, il est possible d'avoir un
`groupe`=1 dans le DLS "**PORTE**", et un autre `groupe`=1 dans le DLS "**PORTAIL**", ces groupes sont différents puisque issus de DLS différents.

Exemple:

    /* Nous sommes dans le DLS "PORTE" */
    /* Définition d'un message, ajout de l'option `debug` en fin de liste d'option */
    #define MSG_VENT_NORD  <-> _MSG(type=etat, libelle="vent du nord", **groupe**=1)
    #define MSG_VENT_SUD   <-> _MSG(type=etat, libelle="vent du sud", **groupe**=1)
    #define MSG_VENT_EST   <-> _MSG(type=etat, libelle="vent d'est", **groupe**=1)
    #define MSG_VENT_OUEST <-> _MSG(type=etat, libelle="vent d'ouest", **groupe**=1)

    /* le passage d'un vent du nord à un vent d'est diffusera le message */
    /* 'vent d'est' tout en désactivant le message 'vent du nord' */
    - VENT_DU_NORD  -> MSG_VENT_NORD;
    - VENT_DU_SUD   -> MSG_VENT_SUD;
    - VENT_DE_EST   -> MSG_VENT_EST;
    - VENT_DE_OUEST -> MSG_VENT_OUEST;

## L'option de `debug`

L'option `debug` peut etre ajoutée à la liste des options d'un message, lors de sa définition.
Cette option permet de ne diffuser le message qu'à la condition que le module D.L.S associé soit dans une situation de debug activée.

Exemple:

    /* Nous sommes dans le DLS "PORTE" */
    /* Définition d'un message, ajout de l'option `debug` en fin de liste d'option */
    #define MON_MSG_DE_DEBUG <-> _MSG(type=etat, libelle="test", **debug**)

    /* Meme si 'MA_CONDITION' est vraie, le message */
    /* ne sera diffusé que si le DLS est en debug. */
    - MA_CONDITION -> MON_MSG_DE_DEBUG;

## Exemples d'usages

    /* Nous sommes dans le DLS "PORTE" */
    /* Définition des messages */
    #define MSG_OUVERTE    <-> _MSG(type=etat,   libelle="la porte est ouverte")
    #define MSG_COINCEE    <-> _MSG(type=defaut, libelle="la porte est coincée")
    #define MSG_EN_VEILLE  <-> _MSG(type=veille, libelle="la porte est sous surveillance")
    #define MSG_EFFRACTION <-> _MSG(type=alerte, libelle="la porte est fracturée")

