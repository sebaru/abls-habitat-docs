# Les bits système SYS

Le module **SYS** expose un ensemble de bits positionnés automatiquement par le moteur D.L.S. Ces bits sont accessibles en lecture depuis n'importe quel module, via le préfixe `SYS:`.

Ils se divisent en deux catégories : les **tops horodatés** (monostables périodiques) et les **bits d'alerte** (entrées TOR gérées par les connecteurs).

---

## Les tops horodatés

Les tops horodatés sont des [monostables](dls_monostables.md) (`_M`) positionnés à `TRUE` une fois par période, puis remis à `FALSE` à la fin du même cycle D.L.S. Ils permettent donc de déclencher une action **exactement une fois** par période.

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

## Les bits d'alerte

Les bits d'alerte sont des [entrées TOR](dls_entre_tor.md) (`_DI`) du module `SYS`, positionnées depuis un module lorsqu'une demande d'alerte est émise.

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


