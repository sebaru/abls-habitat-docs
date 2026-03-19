# Gestion des Utilisateurs

La console permet à l'administrateur du domaine de gérer les utilisateurs : les inviter, modifier leurs droits et leur profil, ou les retirer du domaine.

Pour une description du système de niveaux d'habilitation, consultez la page [Utilisateurs](users.md).

---

## Liste des utilisateurs

La page [/users](https://console.abls-habitat.fr/users) affiche l'ensemble des utilisateurs ayant accès au domaine actif.

Pour chaque utilisateur sont indiqués :

| Colonne | Description |
|---|---|
| **Nom** | Nom court de l'utilisateur |
| **Email** | Adresse e-mail (identifiant principal) |
| **Niveau** | Niveau d'habilitation (1 à 9) |
| **Téléphone** | Numéro de téléphone (pour les SMS) |
| **XMPP** | Adresse de messagerie instantanée |
| **Notifications** | Indique si l'utilisateur reçoit des notifications textuelles |
| **Commandes** | Indique si l'utilisateur peut envoyer des commandes textuelles |

---

## Inviter un utilisateur

Cliquez sur **Inviter un utilisateur** pour accéder à la page [/user/invite](https://console.abls-habitat.fr/user/invite).

### Formulaire d'invitation

| Champ | Description |
|---|---|
| **New Friend Email** | Adresse e-mail de la personne à inviter |
| **New Friend Access Level** | Niveau d'habilitation accordé (1 à 9) |

Cliquez sur **Inviter** pour envoyer l'invitation.

!!! note
    La personne invitée recevra un email d'invitation. Si elle ne possède pas encore de compte Abls-Habitat, elle sera invitée à en créer un.
    Une fois acceptée, elle apparaîtra dans la liste des utilisateurs du domaine.

---

## Éditer un utilisateur

Depuis la liste des utilisateurs, cliquez sur l'icône d'édition pour accéder à la fiche d'un utilisateur ([/user/edit](https://console.abls-habitat.fr/user/edit)).

### Informations modifiables

| Champ | Description |
|---|---|
| **User UUID** | Identifiant unique de l'utilisateur (lecture seule) |
| **User Email** | Adresse e-mail (lecture seule) |
| **User Name** | Nom court affiché dans l'interface |
| **Permissions level** | Niveau d'habilitation actuel (lecture seule pour l'administrateur) |
| **User Phone** | Numéro de téléphone, utilisé pour les notifications SMS |
| **Free SMS Api USER** | Identifiant API Free Mobile pour l'envoi de SMS |
| **Free SMS Api KEY** | Clé API Free Mobile pour l'envoi de SMS |
| **User XMPP** | Adresse XMPP pour la messagerie instantanée |
| **Notifications textuelles** | Active ou désactive la réception de notifications (par GSM ou IMSG) |
| **Commandes textuelles** | Autorise ou non l'envoi de commandes au domaine (par GSM ou IMSG) |

Cliquez sur **Save** pour enregistrer les modifications.

---

## Niveaux d'habilitation

Les niveaux d'habilitation définissent les droits d'accès et de modification dans le domaine :

| Niveau | Profil | Droits principaux |
|---|---|---|
| **1 – 5** | Utilisateurs finaux | Accès en lecture/écriture selon le niveau, sur les ressources de niveau inférieur |
| **6** | Technicien délégué | Peut voir le `domain_secret`, éditer les modules D.L.S, synoptiques et connecteurs |
| **7** | Technicien | Droits techniques étendus |
| **8** | Administrateur délégué | Peut modifier le nom et l'image du domaine |
| **9** | Administrateur | Peut transférer ou supprimer le domaine |

!!! note
    Seul l'administrateur du domaine (niveau 9) peut modifier le niveau d'habilitation des autres utilisateurs.

---

## Retirer un utilisateur (Danger Zone)

La section **Danger Zone** (en bas de la fiche utilisateur) permet de **supprimer** un utilisateur du domaine.

La suppression nécessite de saisir `ok to delete ` suivi de son `user_uuid` pour confirmer l'opération.

!!! warning
    Cette opération est irréversible. L'utilisateur perd immédiatement tout accès au domaine.
