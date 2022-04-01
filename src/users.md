# Catégorie d'utilisateurs

Chaque utilisateur d'un domaine dispose d'un niveau d'habilitation aux différents éléments de ce domaine.
Ce niveau d'habilitation est représenté par un numéro d'accréditation allant de 1 à 9.
Un utilisateur d'un niveau *N* peut:

* Voir et modifier toutes les ressources d'un niveau inférieur ou égal à *N-1*
* Voir les ressources d'un niveau égal à *N*
* Voir et modifier ses propres ressources

!!! note

    Il ne pourra pas accéder ou modifier les ressources de rang plus élevé.

Par défaut, un utilisateur nouvellement créé sera associé au niveau *1*.
Au demarrage, deux [utilisateurs par défaut](utilisateurs-par-defaut) sont créés.

##Utilisateurs non privilègiés

Les niveaux *1* à *5* sont les niveaux à destination des clients finaux.
L'usage des différents niveaux est laissé a l'appréciation du client.

##Utilisateurs privilégiés

Les niveaux *6* à *9* sont les niveaux reservés aux utilisateurs de profil **techniciens**.
Ces utilisateurs à privilèges possèdent les droits de modifier le coeur du système:

* L'édition, l'ajout ou la suppression des [modules D.L.S](dls.md)
* L'édition, l'ajout ou la suppression des synoptiques
* La configuration des [connecteurs](connecteurs.md)

---
##Utilisateurs par défaut

A l'installation, deux comptes sont pre-enregistrés: les comptes **root** et **guest**

* Le compte **root** est un compte administrateur (privilège maximum : Level 9). Son mot de passe par défaut est **password**
* Le compte **guest** est un compte utilisateur avec des privilèges minimaux (Level 1). Son mot de passe par défaut est **guest**

