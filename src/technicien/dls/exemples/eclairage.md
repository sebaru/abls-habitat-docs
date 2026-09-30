# Exemple : éclairage centralisé

Ce module `ALL_ECL` ne pilote aucune lampe directement. Il joue le rôle de **chef d'orchestre** :
il expose deux boutons « tout allumer » et « tout éteindre » sur un synoptique, et relaie l'ordre
à chacun des modules d'éclairage.

C'est l'illustration type des [liens inter-modules](../liens.md).

---

## Le code

```dls
#link CHRDC_ECL:VISU_POS_TL;
#link COUR_ECL:VISU_POS_TL;
#link JARDIN_ECL:VISU_POS_TL;
#link CUISINE_ECL:VISU_POS_TL;
#link SALON_ECL:VISU_POS_TL;

#define O_DLS_ALL_OFF <-> _DI;   /* Ordre de tout éteindre, venant d'un autre module */
#define O_DLS_ALL_ON  <-> _DI;   /* Ordre de tout allumer,  venant d'un autre module */

#define VISU_BOUTON_ALL_ON  <-> _I( forme="ampoule", mode="tout_allumer",
                                    libelle="Allumer toutes les lampes" );
#define VISU_BOUTON_ALL_OFF <-> _I( forme="ampoule", mode="tout_eteindre",
                                    libelle="Eteindre toutes les lampes" );

- _TRUE -> VISU_BOUTON_ALL_ON, VISU_BOUTON_ALL_OFF;

- VISU_BOUTON_ALL_OFF_CLIC + O_DLS_ALL_OFF ->
    CHRDC_ECL:ODLS_WANT_OFF,
    COUR_ECL:ODLS_WANT_OFF,
    JARDIN_ECL:ODLS_WANT_OFF,
    CUISINE_ECL:ODLS_WANT_OFF,
    SALON_ECL:ODLS_WANT_OFF;

- VISU_BOUTON_ALL_ON_CLIC + O_DLS_ALL_ON ->
    CHRDC_ECL:ODLS_WANT_ON,
    COUR_ECL:ODLS_WANT_ON,
    JARDIN_ECL:ODLS_WANT_ON,
    CUISINE_ECL:ODLS_WANT_ON,
    SALON_ECL:ODLS_WANT_ON;

- SECURITE:MODE_AVION ->
  {
    - METEO_API:SUNSET -> SALON_ECL:ODLS_WANT_ON;
    - _HEURE = 22:00   -> SALON_ECL:ODLS_WANT_OFF;
  }
```

---

## Ce qu'il faut en retenir

### `#link` déclare ce que l'on va lire ailleurs

```dls
#link SALON_ECL:VISU_POS_TL;
```

Cette ligne importe l'objet `VISU_POS_TL` du module `SALON_ECL`. Sans elle, la référence
`SALON_ECL:VISU_POS_TL` serait refusée à la compilation.

!!! note "Écrire chez le voisin ne demande pas de `#link`"
    Les actions `SALON_ECL:ODLS_WANT_ON` ne sont pas déclarées en `#link` : la directive ne
    concerne que la **lecture**. Voir [Liens inter-modules](../liens.md).

### Un visuel doit être activé pour exister

```dls
- _TRUE -> VISU_BOUTON_ALL_ON, VISU_BOUTON_ALL_OFF;
```

Un visuel déclaré mais jamais activé n'apparaît pas sur le synoptique.
`_TRUE` le rend visible en permanence. Un bouton conditionnel s'obtient en remplaçant `_TRUE`
par la condition d'affichage.

### Le suffixe `_CLIC` est produit automatiquement

Déclarer `VISU_BOUTON_ALL_ON` crée implicitement `VISU_BOUTON_ALL_ON_CLIC`, vrai le temps
d'un tour lorsque l'utilisateur clique sur le visuel dans son interface.

### `+` est un OU, `.` est un ET

```dls
- VISU_BOUTON_ALL_OFF_CLIC + O_DLS_ALL_OFF -> ...
```

L'ordre part si l'utilisateur clique **ou** si un autre module a levé `O_DLS_ALL_OFF`.
C'est le motif qui permet de commander la même action depuis un bouton, un SMS et un
automatisme, sans dupliquer le code.

### Le point d'entrée `ODLS_`

Chaque module d'éclairage expose une entrée `ODLS_WANT_ON` / `ODLS_WANT_OFF`.
Ce contrat explicite permet à `ALL_ECL` d'ignorer complètement la façon dont chaque pièce est
câblée : télérupteur, relais bistable, variateur.

!!! tip "Le motif à reproduire"
    Exposez dans chaque module de bas niveau une petite interface `ODLS_*`, et laissez les
    modules de coordination s'en servir. Vous pourrez remplacer un télérupteur par un module
    Shelly sans toucher à `ALL_ECL`.

### Le bloc conditionnel

```dls
- SECURITE:MODE_AVION ->
  {
    - METEO_API:SUNSET -> SALON_ECL:ODLS_WANT_ON;
    - _HEURE = 22:00   -> SALON_ECL:ODLS_WANT_OFF;
  }
```

Les règles internes ne sont évaluées que si `SECURITE:MODE_AVION` est vrai : une simulation de
présence qui ne s'active qu'en mode absence. C'est plus lisible et moins coûteux que de répéter
la condition dans chaque règle.

---

## Pour aller plus loin

- [Liens inter-modules](../liens.md)
- [Visuels](../objets/visuels.md)
- [Logique booléenne](../logique.md)
- [Exemple suivant : pompe à chaleur](pompe-pac.md)
