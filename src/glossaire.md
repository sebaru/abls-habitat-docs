# Glossaire

Les termes ci-dessous reviennent dans les trois volets de cette documentation.

---

### Agent

Processus logiciel installé sur une de vos machines (`abls-agent-server`, `abls-agent-modbus`…).
Il dialogue avec le matériel et se synchronise avec l'API du domaine.
Chaque agent appartient à une **classe** et porte un **tech_id** unique.

Voir : [installation](admin/agents/installation.md) · [déclaration dans la console](technicien/parcours/01-agent.md)

### Agent (classe)

Type d'agent, qui détermine la technologie prise en charge : `server`, `dls`, `modbus`, `gpiod`,
`phidget`, `audio`, `sms`, `imsg`, `teleinfoedf`, `shelly`, `ups`, `meteo`.
Voir le [catalogue](admin/agents/catalogue/index.md).

### API

Service central qui détient la configuration du domaine, la base de données et l'historique.
Tous les agents s'y enrôlent au démarrage. Hébergée par le projet
(`api.abls-habitat.fr`) ou [par vous-même](admin/socle/api.md).

### Archive

Enregistrement périodique de la valeur d'un mnémonique, pour alimenter l'historique et les courbes.
Voir : [paramétrer les archives](technicien/parcours/09-archives.md).

### Bit interne

Variable booléenne interne à un module D.L.S, sans existence physique (bistable `_B`,
monostable `_M`…).

### Console

Interface web des utilisateurs à privilèges (niveau ≥ 6), à l'adresse
<https://console.abls-habitat.fr>. C'est l'outil du **technicien**.

### D.L.S

*Domain Logic Script* : le langage d'automatisation d'Abls-Habitat, inspiré des automates
programmables. Un programme D.L.S est découpé en **modules**, compilés puis exécutés en temps réel.
Voir : [le langage D.L.S](technicien/dls/index.md).

### Domaine

Univers logique regroupant des agents, des modules D.L.S, des synoptiques et des utilisateurs.
Deux domaines différents ne communiquent jamais entre eux.
Identifié par un `domain_uuid` et protégé par un `domain_secret`.

### `domain_secret`

Clé secrète qui authentifie les agents auprès de l'API du domaine.
Sa divulgation compromet tout le domaine.

### Home

Interface web de l'**utilisateur final**, à l'adresse <https://home.abls-habitat.fr>.

### I/O (entrée / sortie)

Point d'échange avec le monde physique. Quatre familles :

| Sigle | Nom | Nature |
|---|---|---|
| `DI` | Digital Input — entrée T.O.R | booléen lu |
| `DO` | Digital Output — sortie T.O.R | booléen écrit |
| `AI` | Analog Input — entrée analogique | valeur numérique lue |
| `AO` | Analog Output — sortie analogique | valeur numérique écrite |

### Mapping

Association entre une I/O physique portée par un thread et un **mnémonique** utilisable en D.L.S.
C'est le pont entre le câblage et la logique.
Voir : [mapper les I/O](technicien/parcours/03-mapping.md).

### Master (serveur principal)

Dans un domaine, un serveur est désigné **master** : c'est lui qui héberge le broker MQTT local
et exécute le moteur D.L.S. Les autres serveurs s'y raccordent.

### Mnémonique

Nom logique d'une variable du domaine (`TEMP:JARDIN`, `POMPE_PAC:DO_ACT_TELE`…).
Il est de la forme `MODULE:OBJET`. Les mnémoniques sont créés par la compilation D.L.S et par le
mapping. Voir : [gérer les mnémoniques](technicien/parcours/07-mnemos.md).

### MQTT

Protocole de messagerie temps réel utilisé par Abls-Habitat. Deux bus coexistent :

- **MQTT API** : entre les agents et l'API centrale (chiffré, authentifié)
- **MQTT local** : entre les agents d'un même site, via le serveur master

### Module D.L.S

Unité de programme D.L.S, nommée (`SALON_ECL`, `POMPE_PAC`…), compilée indépendamment.
Un module peut référencer les objets d'un autre module via la syntaxe `AUTRE_MODULE:OBJET`.

### Serveur

Machine physique ou virtuelle qui héberge un ou plusieurs agents.
Identifiée par un `server_uuid`, généré automatiquement au premier démarrage.

### Synoptique

Page de visualisation graphique destinée à l'utilisateur final : un plan, des visuels animés,
des commandes. Voir : [créer les synoptiques](technicien/parcours/05-synoptiques.md).

### `tech_id`

Identifiant technique unique d'un agent au sein du domaine (`MODBUS_CHAUFFERIE`, `AUDIO_SALON`…).
Il apparaît dans le nom du service systemd, dans le nom du fichier de configuration et dans les
topics MQTT.

### Thread (connecteur)

Instance de connexion à une technologie, portée par un agent.
Un agent Modbus peut par exemple porter plusieurs threads, un par automate.
Voir : [configurer les threads](technicien/parcours/02-threads.md).

### T.O.R

*Tout Ou Rien* : se dit d'une grandeur booléenne (ouvert/fermé, allumé/éteint),
par opposition à une grandeur analogique.

### Visuel

Représentation graphique animée d'un objet sur un synoptique (une ampoule, une pompe, un cadran).
Déclaré en D.L.S par un objet `_I`, choisi dans la
[bibliothèque de visuels](technicien/visuels/index.md).
