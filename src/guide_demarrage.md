# <img src="https://static.abls-habitat.fr/img/abls.svg" width=100> Bienvenue sur Abls-Habitat !

Vous trouverez sur ce site l'ensemble de la documentation technique permettant de prendre en main ce système de gestion d'habitat.
Cette documentation s'adresse aux personnes ayant la responsabilité de l'installation et du maintien des systèmes et sous-systèmes composant un domaine complet.
Elle présente les guides d'installation, l'architecture, les concepts, les modes d'emploi, ainsi les bonnes pratiques de mise en oeuvre.

---
## Pré-requis

Les socles minimums sur lesquels le système a été testé puis validé:

* Fedora 34 ou supérieure
* Debian Bullseye ou supérieure
* RaspiOS (basée sur Bullseye)

!!! Note
    Vous aurez également besoin des droits d'administration, via *sudo* par exemple.

---
##Installation d'un agent

1. Pour commencer, suivez la procédure d'installation en [ligne de commande](#installation-en-ligne-de-commande)
1. Puis complétez par [l'installation web](#installation-web).
1. Si besoin, vous pouvez également positionner les [options avancées](#options-avancees)

Vous pouvez également, dans le cadre d'upgrade par exemple, utiliser la méthode de mise à jour basée sur [le repository GIT](#upgrader-un-agent-deja-installe).

###Installation en ligne de commande

Depuis un terminal, lancez la commande suivante:

    $ sudo bash -c "$(wget https://raw.githubusercontent.com/sebaru/Watchdog/main/INSTALL.sh -q -O -)"

Laissez-vous ensuite [guider](#installation-web) par l'installation graphique.

### Installation web

Via votre navigateur, et en supposant que vous venez d'installer localement votre agent, allez sur la page [https://localhost:5559/install](https://localhost:5559/install).

!!! warning

    Les certificats SSL générés étant auto-signés, votre navigateur vous demandera une exception de sécurité
    en cliquant sur ***Avancé*** puis ***Accepter le risque et poursuivre***

Entrez ensuite les paramètres de votre domaine qui vous ont été diffusés lors de sa création dans la page qui s'affiche à vous:

![install](/img/ihm_install.png)

1. Le **domain_uuid**: Il s'agit de l'identifiant principal de votre domaine, auquel vous pourrez relier tous vos agents
1. Le **domain_secret**: Il s'agit du secret protégeant les communications entre vos agents et l'API principale.

!!! Danger
    Le ***domain_secret*** est une donnée confidentielle qui ne doit jamais être diffusée

###Options avancées


Si besoin de configuration plus fine, vous pouvez positionner explicitement l'UUID de votre agent ainsi que l'URL de l'API maitresse
en déroulant le cadre ***Advanced Options***:

1. Instance UUID: Utilisez cette options en cas de restauration de l'agent.
1. **API URL**: Utile en cas d'utilisation d'une API OnPremise.

![install](/img/ihm_install_advanced.png)

!!! danger

    Les options avancées sont réservées aux personnes maitrisant ces options et en ayant le réel besoin.
---
## Arrêt/Relance et suivi de votre agent

###Commandes de lancement et d'arret

Les commandes suivantes permettent alors de demarrer, stopper, redémarrer l'agent sur votre Système:

    [watchdog@Server ~]$ sudo systemctl start Watchdogd.service
    [watchdog@Server ~]$ sudo systemctl stop Watchdogd.service
    [watchdog@Server ~]$ sudo systemctl restart Watchdogd.service

### Commandes d'affichage des logs

Les commandes suivantes permettent d'afficher les logs de l'agent:

    [watchdog@Server ~]$ sudo journalctl -f -u Watchdogd.service

---
##Upgrader un agent deja installé

Pour mettre à niveau votre agent, vous pouvez suivre les mises à jour automatiques de la branche de production
du repository **[Github](https://github.com/sebaru/Watchdog.git)**.

Pour cela, tapez les commandes suivantes dans un terminal:

    $ git clone https://github.com/sebaru/Watchdog.git abls-habitat-agent
    $ cd abls-habitat-agent
    $ ./autogen.sh
    $ sudo make install
    $ cd ..
    $ rm -rf abls-habitat-agent
    $ sudo systemctl restart Watchdogd

---
##Reinstaller un agent

Pour relancer la phase d'installation, supprimer le fichier de configuration puis relancer l'agent:

    $ sudo rm /etc/abls-habitat-agent.conf
    $ sudo systemctl restart Watchdogd

Et enfin recommencer la [procédure](#installation-dun-agent)
