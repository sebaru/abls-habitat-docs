# <img src="https://static.abls-habitat.fr/img/abls.svg" width=100> Bienvenue sur Abls-Habitat !

Vous trouverez sur ce site l'ensemble de la documentation technique permettant de prendre en main ce système de gestion d'habitat.
Cette documentation s'adresse aux personnes ayant la responsabilité de l'installation et du maintien des systèmes et sous-systèmes composant un domaine complet.
Elle présente les guides d'installation, l'architecture, les concepts, les modes d'emploi, ainsi que les bonnes pratiques de mise en oeuvre.

---
## Pré-requis

Les socles minimums sur lesquels les agents ont été testés puis validés:

* Debian Bookworm ou supérieure, avec les **backports** installés
* RaspiOS (basée sur Bookworm)
* Fedora (Server ou Workstation), à partir de Fedora 38

!!! Note
    Vous aurez également besoin des droits d'administration, via **sudo** par exemple.

---
##Installation d'un agent en natif

Si vous souhaitez ajouter un agent

1. Suivez la procédure d'installation en [ligne de commande](#installation-en-ligne-de-commande)
1. Puis complétez par [lier l'agent à l'API](#lier-un-agent).
1. Si besoin, vous pouvez également positionner les [options avancées](#options-avancees)

###Installation en ligne de commande

L'agent à déployer est **abls-agent-server**.
L'installation revient à installer ce paquet via **dnf** ou **apt** selon votre distribution.

#### Fedora/RHEL (RPM)

Sur un système basé sur RPM (Fedora/RHEL), ajoutez le dépôt **ABLS-PKGS** puis installez le paquet `abls-agent-server`:

    sudo wget -O /etc/yum.repos.d/abls-rpms.repo https://pkgs.abls-habitat.fr/abls-rpms.repo
    sudo rpm --import https://pkgs.abls-habitat.fr/rpms/keys/RPM-GPG-KEY-ABLS
    sudo dnf makecache
    sudo dnf install abls-agent-server

#### Debian/RaspiOS (APT)

Sur un système basé sur APT (Debian/RaspiOS), installez d'abord la clé de signature du dépôt:

    sudo install -d -m 0755 /etc/apt/keyrings
    sudo wget -O /etc/apt/keyrings/abls-archive-keyring.gpg https://pkgs.abls-habitat.fr/abls-archive-keyring.gpg
    sudo chmod 0644 /etc/apt/keyrings/abls-archive-keyring.gpg

Ajoutez ensuite la source **ABLS-PKGS** correspondant à votre distribution:

    source /etc/os-release
    sudo wget -O /etc/apt/sources.list.d/abls-pkgs-${VERSION_CODENAME}.sources https://pkgs.abls-habitat.fr/abls-pkgs-${VERSION_CODENAME}.sources

Puis mettez à jour le cache APT et installez `abls-agent-server`:

    sudo apt update
    sudo apt install abls-agent-server

!!! Note
    La variable utilisée est `VERSION_CODENAME`, fournie par `/etc/os-release`. Par exemple, RaspiOS 13 `trixie` télécharge `https://pkgs.abls-habitat.fr/abls-pkgs-trixie.sources`.

Dans les deux cas, activez ensuite le service de l'agent:

    sudo systemctl enable --now abls-agent-server.service

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

    sudo abls-agent-server --save --domain-uuid `domain_uuid` --domain-secret `domain-secret`

Votre agent est désormais lié à l'API.

###Options avancées


Si besoin de configuration plus fine, vous pouvez positionner explicitement l'UUID de votre agent ainsi que l'URL de l'API maitresse
via les options de démarrage suivantes:

1. **Agent UUID**: Utilisez cette options en cas de restauration d'un agent par exemple.
1. **API URL**: Utile en cas d'utilisation d'une API OnPremise.

!!! danger

    Les **options avancées** sont réservées aux personnes maitrisant ces options et en ayant le réel besoin.

Via votre terminal, tapez ensuite la commande suivante:

    sudo abls-agent-server --save --domain-uuid `domain_uuid` --domain-secret `domain-secret` --api-url `api_url` --agent-uuid `agent_uuid`

Votre agent est désormais lié à l'API.

###Configuration MQTT_API TLS

Si votre broker MQTT_API est configuré en SSL/TLS, vous pouvez indiquer explicitement le fichier CA ou le répertoire CA à utiliser pour valider le certificat du broker.
Ces options sont à ajouter manuellement dans `/etc/abls-agent.conf` :

```json
{
  "mqtt_ca_file": "/chemin/vers/ca.pem",
  "mqtt_ca_path": ""
}
```

Si ces champs sont laissés vides, l'agent détecte automatiquement le CA système (bundle Debian ou Fedora).

Consultez la [référence complète de configuration de l'agent](config_agent.md) pour le détail de tous les paramètres.

---
## Arrêt/Relance et suivi de votre agent natif

###Commandes de lancement et d'arret

Les commandes suivantes permettent alors de demarrer, stopper, redémarrer l'agent sur votre Système:

    sudo systemctl start abls-agent-server.service
    sudo systemctl stop abls-agent-server.service
    sudo systemctl restart abls-agent-server.service

Attention, l'arrêt d'un agent nécessite de sauvegarder beaucoup d'éléments vers l'API, cela peut prendre 2 à 5 minutes.

### Commandes d'affichage des logs

Les commandes suivantes permettent d'afficher les logs de l'agent:

    sudo journalctl -f -u abls-agent-server.service

---
## Upgrader un agent natif déjà installé

Un agent peut etre automatiquement upgradé depuis la console, via la page de [gestion des agents](https://console.abls-habitat.fr/agents).

Vous pouvez également le mettre à niveau via le gestionnaire de paquets natif de votre distribution.

### Upgrade RPM (Fedora/RHEL)

    sudo dnf makecache
    sudo dnf upgrade abls-agent-server
    sudo systemctl restart abls-agent-server.service

### Upgrade APT (Debian/RaspiOS)

    sudo apt update
    sudo apt install --only-upgrade abls-agent-server
    sudo systemctl restart abls-agent-server.service

---
##Reinstaller un agent natif

Pour relancer la phase d'installation, supprimez le fichier de configuration puis relancez l'agent:

    $ sudo rm /etc/abls-agent.conf
    $ sudo systemctl restart abls-agent-server.service

Et enfin recommencer la [procédure](#installation-dun-agent-en-natif).
