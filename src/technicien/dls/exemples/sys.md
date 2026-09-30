# Exemple : bits système et supervision

Le module `SYS` surveille le domaine lui-même. Il ne pilote aucun équipement : il transforme les
[bits système](../bits-systeme.md) du moteur en messages compréhensibles.

C'est le module que tout domaine devrait avoir, et souvent le dernier écrit.

---

## Le code

```dls
#define MSG_OUT_OF_MEMORY     <-> _MSG(type=alarme, libelle="Running out of memory !");
#define MSG_MQTT_CONNECTED    <-> _MSG(type=etat,   libelle="MQTT API connecté");
#define MSG_MQTT_DISCONNECTED <-> _MSG(type=defaut, libelle="Connexion au MQTT API perdue");
#define STARTED               <-> _MSG(type=etat,   libelle="Started !");

- _TRUE            -> STARTED;
- MAXRSS > 100000  -> MSG_OUT_OF_MEMORY;
-  MQTT_CONNECTED  -> MSG_MQTT_CONNECTED;
- /MQTT_CONNECTED  -> MSG_MQTT_DISCONNECTED;
```

---

## Ce qu'il faut en retenir

### Les bits système s'utilisent sans déclaration

`MAXRSS` et `MQTT_CONNECTED` ne font l'objet d'aucun `#define` : ils sont fournis par le moteur.
La liste complète figure dans [Bits système SYS](../bits-systeme.md).

Les plus utiles :

| Bit | Nature | Usage |
|---|---|---|
| `MQTT_CONNECTED` | booléen | Liaison vers l'API |
| `MAXRSS` | numérique | Mémoire consommée par le moteur, en kilo-octets |
| `TOP_1MIN` | impulsion | Un front par minute |

### Un message n'est émis qu'une fois

```dls
- MQTT_CONNECTED -> MSG_MQTT_CONNECTED;
```

Bien que la condition soit vraie en permanence, le message n'apparaît qu'**au changement d'état**.
Le moteur gère lui-même cette bascule pour les objets `_MSG` : il n'est pas nécessaire de
construire une détection de front.

!!! warning "Ce n'est vrai que pour les messages"
    Pour une annonce [audio](../../connecteurs/audio.md) ou toute autre action répétable,
    vous devez explicitement détecter le front avec un bistable.

### La paire état / défaut

```dls
-  MQTT_CONNECTED -> MSG_MQTT_CONNECTED;   /* type=etat   */
- /MQTT_CONNECTED -> MSG_MQTT_DISCONNECTED; /* type=defaut */
```

Deux messages symétriques, de types différents. L'utilisateur voit apparaître le défaut, puis
son retour à la normale. Un défaut qui disparaît sans message de retour laisse un doute.

### Un seuil plutôt qu'une valeur exacte

```dls
- MAXRSS > 100000 -> MSG_OUT_OF_MEMORY;
```

!!! tip "Faites-en un `#param`"
    Ce seuil de 100 Mo est écrit en dur. Il dépend de la machine et de la taille du domaine :

    ```dls
    #param PARAM_SEUIL_MEMOIRE (libelle="Seuil d'alerte mémoire (ko)", defaut="100000");
    ```

---

## Un module de supervision plus complet

Le module d'origine est minimal. Voici ce qu'il est utile d'y ajouter.

### Signaler le redémarrage du moteur

```dls
#define MSG_REDEMARRAGE <-> _MSG(type=etat,
                                 libelle="Le moteur D.L.S a redémarré",
                                 notif_sms);

- _START -> MSG_REDEMARRAGE;
```

Un redémarrage inattendu est le premier symptôme d'un problème. Le voir passer change tout.

### Surveiller la perte d'un agent

Un [watchdog](../objets/watchdog.md) rearmé périodiquement par un agent détecte son silence :

```dls
#define WD_MODBUS <-> _WATCHDOG(libelle="Surveillance agent Modbus");
#define MSG_MODBUS_MUET <-> _MSG(type=defaut,
                                 libelle="L'agent Modbus ne répond plus",
                                 notif_sms);

- MODBUS_CHAUFFERIE:VIE -> WD_MODBUS = 600;   /* réarmement 60 secondes */
- WD_MODBUS             -> MSG_MODBUS_MUET;
```

### Suivre la charge du moteur

```dls
#define MSG_MOTEUR_LENT <-> _MSG(type=derangement,
                                 libelle="Le moteur D.L.S ne tient plus la cadence");

- TPS < 40 -> MSG_MOTEUR_LENT;
```

Un moteur qui décroche annonce des temporisations imprécises et des commandes en retard.
Corrélez avec les indications de la page
[Supervision](../../../admin/exploitation/supervision.md) côté administrateur.

---

## La limite de l'auto-supervision

!!! danger "Qui surveille le surveillant ?"
    Si le moteur D.L.S s'arrête, le module `SYS` s'arrête avec lui : aucune alerte ne partira.
    De même, si l'agent SMS est en panne, l'alerte annonçant sa panne ne pourra pas être envoyée.

    L'auto-supervision détecte les **dégradations**, pas les **arrêts complets**.
    Doublez-la par une sonde externe, indépendante du domaine.

---

## Pour aller plus loin

- [Bits système SYS](../bits-systeme.md)
- [Watchdog](../objets/watchdog.md)
- [Supervision côté administrateur](../../../admin/exploitation/supervision.md)
