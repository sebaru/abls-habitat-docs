# Agent IMSG

L'agent IMSG permet d'envoyer et de recevoir des messages XMPP/Jabber depuis le cœur ABLS-Habitat vers les utilisateurs autorisés.

Il est conçu pour utiliser la pile ABLS standard avec le module HTTP local, le broker MQTT interne et les services de mapping pour transformer les commandes textuelles en actions D.L.S.

---

## Objectif

Le connecteur IMSG apporte trois services principaux :

- recevoir des messages depuis un compte Jabber/XMPP dédié ;
- autoriser uniquement les utilisateurs identifiés par le serveur principal ;
- convertir une commande textuelle en action ABLS ou en message de réponse.

Le flux standard est le suivant :

1. un utilisateur envoie un message à l'agent ;
2. le serveur vérifie l’identité et les droits d'envoi ;
3. le texte est comparé aux acronymes ou règles de mapping ;
4. si une correspondance est trouvée, une impulsion MQTT ou une réponse est envoyée.

---

## Configuration

L’agent attend au minimum les paramètres suivants dans sa configuration locale :

- `jabber_id` ou `jabberid` : identifiant Jabber complet, par exemple `abls@domain.tld` ;
- `password` ou `jabber_password` : mot de passe associé.

Le binaire utilise les conventions de configuration ABLS standard, donc les paramètres sont également lisibles depuis l’interface de gestion et les fichiers de config de l'agent.

Exemple de configuration minimale :

```ini
jabber_id = abls@domain.tld
password = secret
```

---

## Comportement

### Commandes texte reconnues

Le module traite les messages simples comme :

- `ping` → répond par `Pong !` ;
- un acronyme ou mot reconnu par le mapping → déclenche la commande associée ;
- une requête inconnue → indique que rien n’a été trouvé.

### Envoi de messages

L’agent peut également diffuser des notifications à tous les utilisateurs autorisés :

- démarrage du service ;
- test ;
- messages de statut ou de commande générale ;
- messages sur événements système.

---

## Sécurité et droits

Le service n’accepte une commande que si :

- l’émetteur est identifié dans le système ABLS ;
- l’ID Jabber correspond à un utilisateur exploitable ;
- le compte est autorisé à envoyer des commandes texte (`can_send_txt_cde`).

Cela évite d’exécuter des commandes depuis un compte non valide ou non autorisé.

---

## Intégration ABLS

Le runtime s’appuie sur le cycle ABLS standard :

- `Agent_init()` pour l’initialisation ;
- `Agent_is_ready()` pour le signal de disponibilité ;
- `Agent_loop()` pour la boucle de traitement ;
- `Agent_end()` pour le nettoyage.

Les appels HTTP partent vers les endpoints API locaux, notamment :

- `/run/user/can_send_txt_cde`
- `/run/mapping/search_txt`
- `/run/users/wanna_be_notified`

Les réactions de commande sont ensuite transmises via MQTT local au système de gestion des D.L.S.

---

## Déploiement

L’agent est construit comme les autres modules ABLS grâce à CMake et aux scripts `build.sh`, `build_apt.sh`, `build_rpm.sh` et `bump.sh`.

Le service système associé est installé en tant qu’unité `abls-agent-imsg@.service` pour un démarrage par instance technique.

---

## Exemple de commande

```bash
/usr/bin/abls-agent-imsg --agent-tech-id=imsg
```

L’agent peut ensuite recevoir des commandes textuelles en XMPP et diffuser les états vers les utilisateurs autorisés.
