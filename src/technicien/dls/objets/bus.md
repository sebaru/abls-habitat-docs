# Le bus `_BUS`

Le `_BUS` envoie une **commande nommée** à un module D.L.S, éventuellement distant.
C'est un mécanisme de diffusion d'ordre, complémentaire des [liens](../liens.md).

---

## Une action, pas un objet à déclarer

Comme le [`_PID`](pid.md), le `_BUS` ne se déclare pas avec `#define`. Il s'écrit directement
comme une action :

```dls
- CONDITION -> _BUS( tech_id="AUTRE_MODULE", commande="MA_COMMANDE" );
```

---

## Options

| Option | Type | Défaut | Rôle |
|---|---|---|---|
| `tech_id` | chaîne | le module courant | Module destinataire de la commande |
| `commande` | chaîne | `""` | Nom de la commande émise |

!!! warning "Caractères autorisés dans `commande`"
    Seuls les lettres, les chiffres, le souligné, l'apostrophe et l'espace sont conservés.
    Tout autre caractère est remplacé par un espace à la compilation. Restez sur des noms
    simples en majuscules : `ARRET_GENERAL`, `MODE_NUIT`.

---

## Exemple

```dls
#define VISU_BOUTON_NUIT <-> _I(forme="lune", libelle="Passer en mode nuit");

- VISU_BOUTON_NUIT_CLIC -> _BUS( tech_id="SALON_ECL",   commande="MODE_NUIT" ),
                           _BUS( tech_id="CHAMBRE_ECL", commande="MODE_NUIT" ),
                           _BUS( tech_id="VOLETS",      commande="MODE_NUIT" );
```

Chaque module destinataire réagit à sa façon à la réception de `MODE_NUIT`.

---

## `_BUS` ou `#link` : lequel choisir ?

Les deux permettent à un module d'en influencer un autre, mais pas de la même manière.

| Critère | `#link` | `_BUS` |
|---|---|---|
| Nature | Référence directe à un **objet** distant | Envoi d'une **commande** nommée |
| Couplage | Fort : le module émetteur connaît la structure interne du destinataire | Faible : il ne connaît qu'un nom de commande |
| Vérification | À la compilation | Le nom de commande n'est pas vérifié |
| Nombre de destinataires | Un objet à la fois | Un module, mais on peut enchaîner les appels |
| Lisibilité | Explicite | Plus abstrait |

!!! tip "Règle de choix"
    - Vous voulez **lire ou forcer un objet précis** d'un autre module : utilisez
      [`#link`](../liens.md).
    - Vous voulez **notifier un changement de contexte** que chaque module interprétera à sa
      manière : utilisez `_BUS`.

!!! danger "Le nom de commande n'est pas vérifié à la compilation"
    Une faute de frappe dans `commande` ou dans `tech_id` ne produit aucune erreur : la commande
    part dans le vide. Vérifiez le comportement réel dans la vue temps réel de la Console.

---

## Bonnes pratiques

- Tenir la **liste des commandes** du domaine dans un module de référence commenté, pour éviter
  les divergences d'orthographe.
- Préférer des noms décrivant un **contexte** (`MODE_NUIT`, `MODE_ABSENCE`) plutôt qu'une action
  sur un équipement précis (`ETEINDRE_LAMPE_3`), sinon `#link` est plus adapté.
- Éviter les boucles : un module qui émet une commande qui lui revient provoque un cycle
  difficile à diagnostiquer.

---

## Voir aussi

- [Liens inter-modules](../liens.md)
- [Anatomie d'un module](../anatomie.md)
