# Architecture du projet

Les éléments constituant le projet sont architecturés dans un domaine.
Un domaine repréesente un univers dans lequel tous les composants pourront intérargir ensemble.

!!! note

    A contrario, deux éléments de deux domaines différents ***ne pourront pas*** intérargir.

Généralement, vous disposez d'un unique domaine représentant l'enemble de votre habitat. Vu d'un peu plus près, les composants
d'un domaine sont les suivants:

![imgmax700](/img/architecture_schema.png)

##Les capteurs et actionneurs

Il s'agit de tous les éléments capturant l'environnement ou pouvant agir dessus. Par exemple, une prise electrique commandable,
un télérupteur ou encore un contacteur.

Tous ces capteurs et actionneurs sont pilotés au travers des différents [connecteurs](connecteurs.md).

##Les Agents

Les agents sont des composants logiciels installés sur une ou plusieurs de vos machines, chez vous. Il ont la mission
d'échanger avec vos capteurs et actionneurs, via leur capacité à se [connecter](connecteurs.md) à ces éléments.

L'ensemble des agents sont inter-connectés au travers d'un bus.
Chacun des agents se synchronise avec [la plateforme cloud](#la-plateforme-cloud) qui sera détaillée ci dessous.
Pour installer un agent sur une de vos machines, suivez la [procédure d'installation](guide_demarrage.md).

##L'agent principal

Dans un domaine, un agent particulier a pour objet de faire tourner [l'intelligence](dls.md) de la plateforme. Cet agent est dit
**principal** ou, en anglais, **master**

!!! note

    Un seul et unique agent est ***principal*** à l'intérieur d'un même domaine. Les autres sont des agents secondaires.

##La plateforme Cloud

Cette plateforme est le point d'entrée pour les utilisateurs, [privilégiés ou non](users.md), afin d'atteindre votre domaine. Elle
est disponible a travers ces liens

* [https://home.abls-habitat.fr](https://home.abls-habitat.fr) pour les utilisateurs réguliers.
* [https://console.abls-habitat.fr](https://console.abls-habitat.fr) pour les utilisateurs à privilèges.
