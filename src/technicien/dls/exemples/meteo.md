# Exemple : météo et notifications

Le module `METEO` ne pilote rien. Il **met en forme** les données du connecteur
[Météo](../../connecteurs/meteo.md) pour les afficher sur un synoptique et les envoyer par
notification.

Il illustre trois notions : les paramètres de module, les visuels de type cadran, et les messages
à contenu variable.

---

## Le code

```dls
/* DLS de gestion de la météo                                                  */
/* Ce module s'appuie sur le thread METEO_API pour notifier la météo du jour   */

#param PARAM_METEO_TIME        (libelle="Heure de notification de la météo du jour",
                                defaut="07:30");
#param PARAM_METEO_API_TECH_ID (libelle="Tech_id du DLS gérant l'accès à l'API météo",
                                defaut="METEO_API");

#define VISU_DAY0_TEMP_MIN <-> _I(forme="cadran", mode="texte",
                                  input=METEO_API:DAY0_TEMP_MIN);
#define VISU_DAY0_TEMP_MAX <-> _I(forme="cadran", mode="texte",
                                  input=METEO_API:DAY0_TEMP_MAX);

#define VISU_DAY0_PROBA_PLUIE <-> _I(forme="cadran", mode="progress-vor",
                                     min=0.0, max=100.0,
                                     seuil_nh=30.0, seuil_nth=70, decimal=0,
                                     input=METEO_API:DAY0_PROBA_PLUIE);
#define VISU_DAY0_PROBA_GEL   <-> _I(forme="cadran", mode="progress-vor",
                                     min=0.0, max=100.0,
                                     seuil_nh=30.0, seuil_nth=70, decimal=0,
                                     input=METEO_API:DAY0_PROBA_GEL);

#define MSG_SUNRISE <-> _MSG(libelle="Le soleil se lève",    notif_sms);
#define MSG_SUNSET  <-> _MSG(libelle="Le soleil se couche",  notif_sms);

#define MSG_METEO_DU_JOUR_1 <-> _MSG(type=etat,
    libelle="De $METEO_API:DAY0_TEMP_MIN à $METEO_API:DAY0_TEMP_MAX, \
gel=$METEO_API:DAY0_PROBA_GEL, pluie=$METEO_API:DAY0_PROBA_PLUIE",
    notif_sms);

#define MSG_METEO_DU_JOUR_2 <-> _MSG(type=etat,
    libelle="vents $METEO_API:DAY0_VENT_A_10M, rafale à $METEO_API:DAY0_RAFALE_VENT",
    notif_sms);

- METEO_API:SUNRISE -> MSG_SUNRISE;
- METEO_API:SUNSET  -> MSG_SUNSET;
- _HEURE = 07:00    -> MSG_METEO_DU_JOUR_1, MSG_METEO_DU_JOUR_2;
```

---

## Ce qu'il faut en retenir

### L'en-tête documentaire

Les quelques lignes de commentaire en tête indiquent à quoi sert le module, de quoi il dépend et
qui l'a modifié. C'est peu coûteux à écrire, et déterminant six mois plus tard.

### `#param` : les réglages sans recompilation

```dls
#param PARAM_METEO_TIME (libelle="Heure de notification", defaut="07:30");
```

Un paramètre est un réglage modifiable **depuis la Console**, sans toucher au code ni recompiler.
Il apparaît dans la page **Paramètres du D.L.S** du module.

!!! tip "Tout ce qu'un exploitant pourrait vouloir changer doit être un `#param`"
    Heures de déclenchement, seuils, durées, `tech_id` d'un module partenaire.
    Une valeur écrite en dur dans le code impose une intervention technique à chaque ajustement.

Voir [Paramètres de module](../parametres.md).

### Un visuel qui affiche une valeur

```dls
#define VISU_DAY0_TEMP_MIN <-> _I(forme="cadran", mode="texte",
                                  input=METEO_API:DAY0_TEMP_MIN);
```

L'option `input` lie le visuel à un registre ou une entrée analogique : le cadran affiche
directement la valeur, sans aucune règle d'activation.

### Un visuel à seuils colorés

```dls
#define VISU_DAY0_PROBA_PLUIE <-> _I(forme="cadran", mode="progress-vor",
                                     min=0.0, max=100.0,
                                     seuil_nh=30.0, seuil_nth=70, decimal=0,
                                     input=METEO_API:DAY0_PROBA_PLUIE);
```

| Option | Rôle |
|---|---|
| `min`, `max` | Bornes de l'échelle |
| `seuil_nh` | Seuil « niveau haut » — passage en orange |
| `seuil_nth` | Seuil « niveau très haut » — passage en rouge |
| `decimal` | Nombre de décimales affichées |

`decimal=0` évite d'afficher « 42,7 % de probabilité de pluie », ce qui suggère une précision
que la prévision n'a pas.

### Des messages à contenu variable

```dls
libelle="De $METEO_API:DAY0_TEMP_MIN à $METEO_API:DAY0_TEMP_MAX"
```

La syntaxe `$MODULE:OBJET` insère la valeur courante dans le texte, au moment de l'émission.
Un message utile est un message qui porte la donnée : « Il fait 3 degrés » vaut mieux que
« Température basse ».

### Déclencher à heure fixe

```dls
- _HEURE = 07:00 -> MSG_METEO_DU_JOUR_1, MSG_METEO_DU_JOUR_2;
```

!!! warning "Une incohérence à corriger dans cet exemple"
    Le module déclare `PARAM_METEO_TIME` avec `07:30` par défaut… mais la règle utilise
    `_HEURE = 07:00` en dur. Le paramètre est donc sans effet.

    C'est une erreur fréquente : déclarer un paramètre puis oublier de l'utiliser.
    Vérifiez systématiquement que chaque `#param` est réellement référencé.

### Scinder les messages longs

Deux messages plutôt qu'un seul : un SMS est limité en longueur, et un message tronqué perd
précisément sa fin, souvent la plus informative.

---

## Réagir aux éphémérides

`METEO_API:SUNRISE` et `METEO_API:SUNSET` sont des impulsions émises au lever et au coucher du
soleil, calculées pour la commune configurée. Elles sont bien plus pertinentes qu'une heure fixe
pour piloter un éclairage extérieur ou des volets.

```dls
- METEO_API:SUNSET -> JARDIN_ECL:ODLS_WANT_ON;
```

---

## Pour aller plus loin

- [Paramètres de module](../parametres.md)
- [Visuels](../objets/visuels.md) · [Bibliothèque de visuels](../../visuels/index.md)
- [Messages](../objets/messages.md)
- [Exemple suivant : bits système et supervision](sys.md)
