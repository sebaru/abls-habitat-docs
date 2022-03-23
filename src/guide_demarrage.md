# <img src="/img/abls.svg" width=100> Bienvenue sur Abls-Habitat !

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

1. Pour une installation from scratch, la procédure d'installation recommandée est celle en [ligne de commande](#installation-en-ligne-de-commande)
1. Puis complétez par [l'installation web](#installation-web).

Vous pouvez également, dans le cadre d'upgrade par exemple, utiliser la méthode de mise à jour basée sur [le repository GIT](#upgrader-une-instance-existante).

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

Entrez alors les deux paramètres spécifiques de votre domaine:
1. Le domain_uuid
1. Le domain_secret

!!! Danger
    Le ***domain_secret*** est une données confidentielle qui ne doit jamais être diffusée

---
## Arrêt/Relance et suivi de votre agent

###Commandes de lancement et d'arret

Les commandes suivantes permettent alors de demarrer, stopper, redémarrer l'agent sur votre Système:

    [watchdog@Server ~]$ sudo systemctl start Watchdogd.service
    [watchdog@Server ~]$ sudo systemctl stop Watchdogd.service
    [watchdog@Server ~]$ sudo systemctl restart Watchdogd.service

### Commandes d'affichage des logs

Les commandes suivantes permettent d'afficher les logs de l'instance:

    [watchdog@Server ~]$ sudo journalctl -f -u Watchdogd.service

---
##Upgrader un agent deja installé

Pour mettre à niveau votre instance, vous pouvez suivre les mises à jour automatiques de la branche de production
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
## a migrer dans domaine create
Utilisateurs par défaut

A l'installation, deux comptes sont pre-enregistrés: les comptes **root** et **guest**

* Le compte **root** est un compte administrateur (privilège maximum : Level 9). Son mot de passe par défaut est **password**
* Le compte **guest** est un compte utilisateur avec des privilèges minimaux (Level 1). Son mot de passe par défaut est **guest**
