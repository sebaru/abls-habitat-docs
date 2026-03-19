# Domaine : configuration et sélection

Un **domaine** est l'unité centrale d'organisation d'Abls-Habitat.
Il regroupe l'ensemble des équipements, des modules D.L.S, des utilisateurs et des données d'une installation.

---

## Sélection du domaine

Après connexion sur la console, la page [/domains](https://console.abls-habitat.fr/domains) affiche la liste de vos domaines.

Chaque domaine est présenté sous forme de **carte** avec :

- Son image représentative
- Son nom
- Un bouton pour le sélectionner comme domaine actif

!!! note
    Si vous n'avez pas encore de domaine, un message vous invite à en créer un ou à rejoindre un domaine existant via une invitation.

Après sélection, la console bascule automatiquement sur ce domaine et toutes les actions (D.L.S, synoptiques, utilisateurs…) portent sur ce dernier.

---

## Créer un domaine

Depuis la page [/domains](https://console.abls-habitat.fr/domains), cliquez sur **Créer un domaine**.

Un nouveau domaine est immédiatement provisionné. Vous en devenez l'**administrateur** (niveau 9).

---

## Configurer le domaine

La page [/domain/edit](https://console.abls-habitat.fr/domain/edit) permet de modifier les paramètres du domaine actif.

### Paramètres généraux

| Paramètre | Description |
|---|---|
| **Image** | Image représentative du domaine (cliquez sur l'image pour en changer) |
| **Domain Name** | Nom court du domaine |
| **Domain UUID** | Identifiant unique du domaine (lecture seule) |
| **Domain Secret Key** | Clé secrète utilisée par les agents pour s'authentifier (masquée) |
| **Creation date** | Date de création du domaine (lecture seule) |
| **Titre du synoptique principal** | Libellé affiché sur la page d'accueil du domaine |
| **Notification aux utilisateurs** | Message de notification diffusé à tous les utilisateurs connectés |
| **TechID de l'Audio principal** | Identifiant du thread audio utilisé pour les annonces sonores |
| **URL du repository** | URL d'un dépôt Git pour la synchronisation des packages D.L.S |
| **Token du repository** | Token d'authentification pour le dépôt Git |
| **Clef d'API Mistral.AI** | Clé pour l'intégration de l'IA générative Mistral |
| **Debug Traduction D.L.S** | Niveau de verbosité du débogage de la compilation D.L.S |

Cliquez sur **Save** pour enregistrer les modifications.

!!! tip
    Le **Domain UUID** et le **Domain Secret Key** sont nécessaires pour configurer les agents.
    Retrouvez-les dans cette page et reportez-les dans la commande de lancement de l'agent.
    Consultez le [guide de démarrage](guide_demarrage.md) pour plus de détails.

!!! danger
    Le **Domain Secret Key** est une donnée confidentielle. Ne la partagez qu'avec les personnes de confiance chargées de déployer des agents.

---

## Danger Zone

La section **Danger Zone** (accessible en déroulant la carte rouge) propose deux opérations irréversibles :

### Transférer le domaine

Permet de **transférer la propriété** du domaine à un autre utilisateur en saisissant son adresse e-mail.

!!! warning
    Cette opération est **irréversible**. L'ancien propriétaire perd ses droits d'administration.

### Supprimer le domaine

Permet de **supprimer définitivement** le domaine et toutes ses données (D.L.S, synoptiques, archives, utilisateurs…).

La suppression nécessite de saisir la confirmation `ok to delete ` suivi du `domain_uuid` pour éviter les suppressions accidentelles.

!!! danger
    La suppression du domaine est **définitive et irréversible**. Toutes les données sont perdues.
