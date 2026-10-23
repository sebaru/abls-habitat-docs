# Les bits système SYS

Le module **SYS** expose un ensemble de bits positionnés automatiquement par le moteur D.L.S. Ces bits sont accessibles en lecture depuis n'importe quel module, via le préfixe `SYS:`.

Ils se divisent en trois catégories : les **tops horodatés** (monostables périodiques), les **bascules horodatées** (bistables périodiques) et les **bits d'alerte** (entrées TOR gérées par les connecteurs).

---

## Les tops horodatés

Les tops horodatés sont des [monostables](objets/monostables.md) (`_M`) positionnés à `TRUE` une fois par période, puis remis à `FALSE` à la fin du même cycle D.L.S. Ils permettent donc de déclencher une action **exactement une fois** par période.

| Acronyme | Classe | Période | Description |
|:---------|:-------|:-------:|:------------|
| `SYS:TOP_5HZ` | `_M` | 200 ms | Impulsion toutes les 1/5 de secondes |
| `SYS:TOP_2HZ` | `_M` | 500 ms | Impulsion toutes les demi-secondes |
| `SYS:TOP_1SEC` | `_M` | 1 s | Impulsion toutes les secondes |
| `SYS:TOP_5SEC` | `_M` | 5 s | Impulsion toutes les 5 secondes |
| `SYS:TOP_10SEC` | `_M` | 10 s | Impulsion toutes les 10 secondes |
| `SYS:TOP_1MIN` | `_M` | 1 min | Impulsion toutes les minutes |

### SYS:TOP_1SEC

`SYS:TOP_1SEC` est un monostable positionné à `TRUE` **une fois par seconde** par le moteur D.L.S, puis remis automatiquement à `FALSE` à la fin du même cycle.

Il est typiquement utilisé pour :

* incrémenter des compteurs d'impulsion,
* rafraîchir un affichage périodique,
* déclencher un traitement léger à cadence régulière.

Exemple d'usage :

    /* Incrémenter un compteur toutes les secondes tant qu'une condition est vraie */
    - SYS:TOP_1SEC . MA_CONDITION → MON_COMPTEUR;

### SYS:TOP_1MIN

`SYS:TOP_1MIN` est un monostable positionné à `TRUE` **une fois par minute** par le moteur D.L.S, puis remis automatiquement à `FALSE` à la fin du même cycle.

Il est utilisé pour des actions moins fréquentes comme :

* la mise à jour d'une consigne de chauffe,
* le déclenchement d'un bilan périodique,
* toute logique ne nécessitant pas une cadence à la seconde.

Exemple d'usage :

    /* Toutes les minutes, envoyer un message d'état */
    - SYS:TOP_1MIN → MSG_BILAN_PERIODIQUE;

!!! warning
    Ces bits appartiennent au module système `SYS`. Il est donc obligatoire de les préfixer explicitement par `SYS:` dans le code d'un autre module D.L.S.

---

## Les bascules horodatées

Les bits `SYS:FLIPFLOP_*` sont des [bistables](objets/bistables.md) (`_B`) dont le moteur D.L.S inverse périodiquement l'état : de `FALSE` à `TRUE`, puis de `TRUE` à `FALSE`. Contrairement aux tops, ils conservent leur état entre deux basculements au lieu de revenir à `FALSE` à la fin du cycle D.L.S.

| Acronyme | Classe | Intervalle de basculement | Période complète |
|:---------|:-------|:------------------------:|:----------------:|
| `SYS:FLIPFLOP_5HZ` | `_B` | 200 ms | 400 ms |
| `SYS:FLIPFLOP_2HZ` | `_B` | 500 ms | 1 s |
| `SYS:FLIPFLOP_1SEC` | `_B` | 1 s | 2 s |
| `SYS:FLIPFLOP_2SEC` | `_B` | 2 s | 4 s |

La période complète comprend un intervalle à `TRUE` et un intervalle à `FALSE`. Les suffixes `5HZ` et `2HZ` désignent donc la cadence des basculements, pas la fréquence du signal complet.

### SYS:FLIPFLOP_1SEC

`SYS:FLIPFLOP_1SEC` change d'état **toutes les secondes**. Il peut servir à faire clignoter une sortie ou un visuel, avec une seconde à `TRUE`, puis une seconde à `FALSE`.

Exemple d'usage pour une sortie TOR :

    - SYS:FLIPFLOP_1SEC → SORTIE_CLIGNOTANTE;

La sortie suit l'état de la bascule : active pendant 1 seconde, puis inactive pendant 1 seconde, soit une période complète de 2 secondes.

!!! warning
    Ces bits sont pilotés automatiquement par le moteur D.L.S. Utilisez-les en lecture, avec le préfixe `SYS:` dans le code d'un autre module D.L.S.

---

## Les bits d'alerte

Les bits d'alerte sont des [entrées TOR](objets/di.md) (`_DI`) du module `SYS`, positionnées depuis un module lorsqu'une demande d'alerte est émise.

| Acronyme | Classe | Positionné par | Description |
|:---------|:-------|:--------------:|:------------|
| `SYS:TOP_ALERTE_1` | `_DI` | Connecteur externe | Demande d'alerte priorité 1 |
| `SYS:TOP_ALERTE_2` | `_DI` | Connecteur externe | Demande d'alerte priorité 2 |

### SYS:TOP_ALERTE_1 et SYS:TOP_ALERTE_2

Ces deux bits sont des entrées TOR gérées par un connecteur ou un service externe au moteur D.L.S. Ils signalent qu'une **demande d'alerte** a été émise par un cmodule (détecteur d'intrusion, capteur de présence, bouton poussoir d'urgence, etc.).

Exemple d'usage :

    /* Si une demande d'alerte est reçue, déclencher la sirène et notifier */
    - SYS:TOP_ALERTE_1 → SIRENE;
    - SYS:TOP_ALERTE_1 → MSG_ALERTE_INTRUSION;

    /* Alerte secondaire : simple notification */
    - SYS:TOP_ALERTE_2 → MSG_ALERTE_SECONDAIRE;
