# Exemples commentés

Ces exemples sont tirés d'une installation réelle en exploitation. Ils illustrent les schémas
récurrents de la programmation D.L.S : mode automatique et manuel, filtrage temporel,
notification, supervision.

!!! tip "Lisez-les dans cet ordre"
    Chaque page reprend et approfondit les notions de la précédente.

| Exemple | Ce qu'il illustre |
|---|---|
| [Éclairage centralisé](eclairage.md) | Liens inter-modules, boutons de synoptique, commandes groupées |
| [Pompe à chaleur](pompe-pac.md) | Modes de fonctionnement, seuils, temporisations, compteurs, défauts |
| [Météo et notifications](meteo.md) | Paramètres de module, horloges, messages avec variables |
| [Bits système et supervision](sys.md) | Auto-supervision du domaine |

---

## Conventions de nommage

Les exemples suivent des préfixes cohérents, que vous avez tout intérêt à reprendre :

| Préfixe | Signification |
|---|---|
| `DI_`, `DO_`, `AI_`, `AO_` | Objet lié à une I/O physique |
| `ME_` | Monostable (état non mémorisé) |
| `M`, `MDEF_` | Bistable, mémoire de défaut |
| `TR_` | Temporisation |
| `VISU_` | Visuel destiné à un synoptique |
| `MSG_` | Message utilisateur |
| `O_TXT_` | Commande reçue par SMS ou messagerie |
| `ODLS_` | Ordre reçu d'un autre module D.L.S |
| `CI_`, `TIME_` | Compteur d'impulsions, compteur horaire |

!!! tip "Une convention vaut mieux qu'une bonne convention"
    Peu importe celle que vous choisissez : tenez-vous-y. Un module relu six mois plus tard
    se déchiffre d'abord par ses noms.

---

## Où trouver plus d'exemples

Le dépôt `SRC_DLS_OZOIR` rassemble les modules d'une installation domestique complète :
éclairages, volets, chauffage, piscine, arrosage, sécurité, énergie.
