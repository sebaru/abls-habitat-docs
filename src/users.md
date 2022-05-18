# Catégorie d'utilisateurs

Chaque utilisateur d'un domaine dispose d'un niveau d'habilitation aux différents éléments de ce domaine.
Ce niveau d'habilitation est représenté par un numéro d'accréditation allant de 1 à 9.
Un utilisateur d'un niveau *N* peut:

* Voir et modifier toutes les ressources d'un niveau inférieur ou égal à *N-1*
* Voir les ressources d'un niveau égal à *N*
* Voir et modifier ses propres ressources

!!! note

    Il ne pourra pas accéder ou modifier les ressources d'un rang plus élevé.

Par défaut, un utilisateur nouvellement créé sera associé au niveau *1*.

##Utilisateurs non privilègiés

Les niveaux *1* à *5* sont les niveaux à destination des clients finaux.
L'usage des différents niveaux est laissé a l'appréciation du client.

##Utilisateurs privilégiés

Les niveaux *6* à *9* sont les niveaux reservés aux utilisateurs de profils **techniciens**.
Ces utilisateurs à privilèges possèdent les droits de modifier le coeur du système:


---
##Grille des privilèges

Un utilisateur de niveau *N*

* Niveau 9 - Administrateur du domaine
** Peut transférer le domaine à un nouveau propriétaire
** Peut supprimer complétement le domaine
* Niveau 8 - Administrateur délégué du domaine
** Peut modifier le `domain_name` ainsi que changer l'`image` du domaine
* Niveau 7 - Technicien du domaine
* Niveau 6 - Technicien délégué du domaine
** Peut voir le `domain_secret`
** Peut éditer, ajouter ou supprimer des [modules D.L.S](dls.md)
** Peut éditer, ajouter ou supprimer des synoptiques
** Peut éditer, ajouter ou supprimer des [connecteurs](connecteurs.md)
