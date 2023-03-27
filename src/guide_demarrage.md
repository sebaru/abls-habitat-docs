# <img src="https://static.abls-habitat.fr/img/abls.svg" width=100> Bienvenue sur Abls-Habitat !

Vous trouverez sur ce site l'ensemble de la documentation technique permettant de prendre en main ce système de gestion d'habitat.
Cette documentation s'adresse aux personnes ayant la responsabilité de l'installation et du maintien des systèmes et sous-systèmes composant un domaine complet.
Elle présente les guides d'installation, l'architecture, les concepts, les modes d'emploi, ainsi que les bonnes pratiques de mise en oeuvre.

---
## Pré-requis

Les socles minimums sur lesquels les agents ont été testés puis validés:

* Debian Bullseye ou supérieure, avec les **backports** installés
* RaspiOS (basée sur Bullseye)
* Fedora (Server ou Workstation), à partir de Fedora 36

!!! Note
    Vous aurez également besoin des droits d'administration, via **sudo** par exemple.

---
##Installation d'un agent depuis un container

La solution la plus simple pour installer un agent est d'utiliser le format container.

Depuis votre hote, tapez la commande suivante:

    [watchdog@Server ~]$ podman run --name abls-agent --tz local -p 5559:5559 --env ABLS_API_URL=api.abls-habitat.fr --env ABLS_DOMAIN_UUID=`domain_uuid` --env ABLS_DOMAIN_SECRET=`domain_secret` --group-add keep-groups --device /dev/serial/ docker.io/sebaru/abls-agent:latest

Retrouvez aussi ces instructions sur la console, en cliquant sur le menu [Ajouter un agent](https://console.abls-habitat.fr/agent/add)

---
##Installation d'un agent en natif

Si vous souhaitez ajouter manuellement un agent

1. Suivez la procédure d'installation en [ligne de commande](#installation-en-ligne-de-commande)
1. Puis complétez par [lier l'agent à l'API](#lier-un-agent).
1. Si besoin, vous pouvez également positionner les [options avancées](#options-avancees)

Vous pouvez également, dans le cadre d'upgrade par exemple, utiliser la méthode de mise à jour basée sur [le repository GIT](#upgrader-un-agent-deja-installe).

###Installation en ligne de commande

Depuis un terminal, lancez la commande suivante:

    [watchdog@Server ~]$ sudo bash -c "$(wget https://raw.githubusercontent.com/sebaru/Watchdog/main/INSTALL.sh -q -O -)"

[Liez](#lier-un-agent) ensuite votre agent à votre domaine.

### Lier un agent

La solution la plus simple est de vous connecter à la console, de cliquez sur le menu [Ajouter un agent](https://console.abls-habitat.fr/agent/add)
et de suivre les instructions.

Manuellement, vous pouvez également, depuis votre [console](https://console.abls-habitat.fr), récupérer les données suivantes:

1. Le `domain_uuid`: Il s'agit de l'identifiant principal de votre domaine, auquel vous pourrez relier tous vos agents
1. Le `domain_secret`: Il s'agit du secret protégeant les communications entre vos agents et l'API principale.

!!! Danger
    Le ***domain_secret*** est une donnée confidentielle qui ne doit jamais être diffusée

Via votre terminal, tapez ensuite la commande suivante:

    [watchdog@Server ~]$ sudo Watchdogd --link --domain-uuid `domain_uuid` --domain-secret `domain-secret`

Votre agent est désormais lié à l'API.

###Options avancées


Si besoin de configuration plus fine, vous pouvez positionner explicitement l'UUID de votre agent ainsi que l'URL de l'API maitresse
via les options de démarrage suivantes:

1. **Agent UUID**: Utilisez cette options en cas de restauration d'un agent par exemple.
1. **API URL**: Utile en cas d'utilisation d'une API OnPremise.

!!! danger

    Les **options avancées** sont réservées aux personnes maitrisant ces options et en ayant le réel besoin.

Via votre terminal, tapez ensuite la commande suivante:

    [watchdog@Server ~]$ sudo Watchdogd --link --domain-uuid `domain_uuid` --domain-secret `domain-secret` --api-url `api_url` --agent-uuid `agent_uuid`

Votre agent est désormais lié à l'API.

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

    [watchdog@Server ~]$ git clone https://github.com/sebaru/Watchdog.git abls-habitat-agent
    [watchdog@Server ~]$ cd abls-habitat-agent
    [watchdog@Server ~]$ ./autogen.sh
    [watchdog@Server ~]$ sudo make install
    [watchdog@Server ~]$ cd ..
    [watchdog@Server ~]$ rm -rf abls-habitat-agent
    [watchdog@Server ~]$ sudo systemctl restart Watchdogd

---
##Reinstaller un agent

Pour relancer la phase d'installation, supprimez le fichier de configuration puis relancez l'agent:

    $ sudo rm /etc/abls-habitat-agent.conf
    $ sudo systemctl restart Watchdogd

Et enfin recommencer la [procédure](#installation-dun-agent).
