# <img src="https://static.abls-habitat.fr/img/abls.svg" width=100> Abls-Habitat, ou comment gérer simplement votre habitat !

Le logiciel libre **Abls-Habitat** est un ensemble de composants distribués selon les termes de la licence GPL
et hébergés sur [GitHub](https://github.com/sebaru?tab=repositories):

* un ou plusieurs [Agents](https://github.com/sebaru/abls-agent-server.git)
* une [console](https://github.com/sebaru/abls-habitat-console.git) d'administration
* une [interface](https://github.com/sebaru/abls-habitat-home.git) de navigation et de contrôle
* une [API](https://github.com/sebaru/abls-habitat-api.git) pour lier les composants entre eux

L'agent, à l'image d'un chef d'orchestre, fédère un ensemble de capteurs et d'actionneurs au travers d'un [langage de programmation](technicien/dls/index.md) simple qui vous permettra de gérer votre habitat facilement !

Les [connecteurs](technicien/connecteurs/index.md) permettent en temps réel de connaitre l'état de vos capteurs, d'envoyer des commandes, ou encore d’être alerté par SMS ou messagerie instantanée en cas d'évènements imprévus, ou bien nécessitant votre intervention.

Ainsi, aux travers d'interfaces conviviales vous saurez :

* Quelles sont les températures extérieures et de votre salon,
* Quelle est votre consommation électrique instantanée,
* Piloter manuellement ou via l'intelligence embarquée vos radiateurs selon vos besoins,
* Gérer la pompe de votre puit ou de votre bac de rétention des eaux de pluie,
* Arroser automatiquement votre jardin selon les créneaux horaires et les saisons,
* Et engager des économies financières !

---

## Par où commencer ?

Cette documentation est organisée en **trois volets**, un par rôle. Choisissez le vôtre.

<div class="grid cards" markdown>

-   **Je suis administrateur**

    ---

    J'installe les agents sur les machines, je les enrôle sur le domaine, je règle leur
    configuration et je maintiens le socle en condition opérationnelle.

    [Volet Administrateur](admin/index.md)

-   **Je suis technicien**

    ---

    Je mappe les entrées/sorties, j'écris les modules D.L.S et je construis les synoptiques
    que verront les utilisateurs.

    [Volet Technicien](technicien/index.md)

-   **Je suis utilisateur**

    ---

    Je pilote mon habitat au quotidien : synoptiques, messages, historique, caméras et
    notifications.

    [Volet Utilisateur](utilisateur/index.md)

</div>

Si vous hésitez, la page [Les trois rôles](roles.md) détaille la frontière entre chacun.
Le [glossaire](glossaire.md) définit le vocabulaire commun aux trois volets.
