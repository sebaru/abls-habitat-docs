# Les trois rôles

Faire vivre un domaine Abls-Habitat mobilise **trois métiers différents**.
Cette documentation est organisée en trois volets, un par rôle. Identifiez le vôtre : c'est votre
porte d'entrée.

---

## L'administrateur

> « J'installe et je maintiens les machines et les agents. »

L'administrateur intervient **sur les systèmes**, en ligne de commande, avec les droits `root`.
Il ne rédige pas de logique d'automatisation et ne dessine pas d'écran.

Ses responsabilités :

- Choisir et préparer les machines qui porteront les agents (serveur, Raspberry Pi, VM)
- Ajouter les dépôts de paquets Abls-Habitat et installer les agents
- Enrôler chaque agent sur le domaine (`domain_uuid`, `domain_secret`, `api_url`)
- Régler les paramètres locaux et arbitrer la **précédence ENV / FILE / ARGV**
- Éventuellement héberger lui-même le socle (API, base de données, broker MQTT, Console, Home)
- Surveiller, journaliser, mettre à jour, sauvegarder, dépanner

**Ce qu'il doit savoir faire :** administrer Linux, `systemd`, `apt`/`dnf`, lire un `journalctl`.

[Aller au volet Administrateur](admin/index.md)

---

## Le technicien

> « Je construis et je fais évoluer l'intelligence du domaine. »

Le technicien travaille **depuis la Console web**, sans jamais se connecter en SSH sur les machines.
Il part d'un parc d'agents déjà installés par l'administrateur.

Ses responsabilités :

- Déclarer les agents et leurs threads (connecteurs) dans le domaine
- Réaliser le **mapping des I/O** : relier chaque entrée/sortie physique à un mnémonique
- Écrire, compiler et déboguer les **modules D.L.S** qui portent l'automatisation
- Concevoir les **synoptiques** que verra l'utilisateur final, et les peupler dans l'atelier graphique
- Paramétrer les messages, les notifications, les archives et les courbes

**Ce qu'il doit savoir faire :** raisonner en logique booléenne et en automatisme, lire un schéma
électrique, écrire du D.L.S.

**Habilitation requise :** niveau 6 minimum sur le domaine.

[Aller au volet Technicien](technicien/index.md)

---

## L'utilisateur final

> « Je pilote mon habitat au quotidien. »

L'utilisateur se connecte à l'interface [Home](https://home.abls-habitat.fr) depuis son téléphone
ou son ordinateur. Il n'a rien à configurer.

Ses usages :

- Consulter ses synoptiques et agir sur les commandes (éclairage, volets, chauffage…)
- Lire le fil de l'eau, acquitter les messages
- Consulter l'historique et les courbes de consommation
- Regarder ses caméras
- Recevoir des alertes par SMS, messagerie ou annonce audio
- Inviter ses proches sur le domaine

**Ce qu'il doit savoir faire :** rien de particulier.

[Aller au volet Utilisateur](utilisateur/index.md)

---

## Qui fait quoi : la frontière entre les rôles

Certaines notions apparaissent dans plusieurs volets, mais sous un angle différent.
Ce tableau lève les ambiguïtés les plus fréquentes.

| Sujet | Administrateur | Technicien | Utilisateur |
|---|---|---|---|
| **Agent** | L'installe, le configure, le démarre sur une machine | Le déclare dans le domaine et configure ses threads | Ne le voit pas |
| **Connecteur** | Installe le paquet correspondant et ses dépendances matérielles | Déclare les I/O exposées et les mappe | Ne le voit pas |
| **I/O physique** | Câble, driver, permissions système | Mapping vers un mnémonique | Ne le voit pas |
| **D.L.S** | Installe l'agent qui l'exécute | L'écrit et le débogue | Subit ou déclenche ses effets |
| **Synoptique** | Ne s'en occupe pas | Le crée et le peuple | Le consulte et agit dessus |
| **Message** | Ne s'en occupe pas | Le déclare en D.L.S | Le lit et l'acquitte |
| **Utilisateur du domaine** | Gère les comptes et les niveaux d'accès | Invite des techniciens | Invite ses proches |
| **Secret du domaine** | Le connaît et l'utilise | Peut le consulter (niveau ≥ 6) | Ne le voit jamais |

!!! tip "Une seule personne peut porter plusieurs rôles"
    Dans une installation domestique, la même personne est souvent administrateur **et** technicien.
    Les volets restent séparés pour que chacun sache dans quel contexte il agit : un changement fait
    en SSH n'a pas les mêmes conséquences qu'un changement fait dans la Console.

---

## Prérequis d'habilitation

L'accès aux outils dépend du niveau d'accréditation du compte sur le domaine.

| Rôle | Outil principal | Niveau requis |
|---|---|---|
| Administrateur | Terminal SSH + Console | 9 (propriétaire du domaine) |
| Technicien | [Console](https://console.abls-habitat.fr) | 6 à 8 |
| Utilisateur | [Home](https://home.abls-habitat.fr) | 1 à 5 |

Le détail de la grille est décrit dans [les habilitations](admin/habilitations.md).
