# La zone de calculs D.L.S

## Principe

La zone de calculs fait partie de la [zone de logique](dls_logique.md). Elle utilise la même syntaxe de ligne D.L.S :

    - EXPRESSION → LISTE_ACTIONS;

Mais à la différence de la logique booléenne, ici les expressions et les actions manipulent des **valeurs réelles** (type `arithmétique`). Les éléments arithmétiques sont les [entrées analogiques](dls_entre_ana.md), les [sorties analogiques](dls_sortie_ana.md), les [compteurs](dls_cpti.md), les [compteurs horaires](dls_cpth.md) et les [registres](dls_registres.md).

---

## Opérations arithmétiques de base

### Addition

    - REGISTRE_A + REGISTRE_B → REGISTRE_SOMME;
    - TEMP_EXT + 2.5 → TEMP_CORRIGEE;

### Soustraction

    - TEMP_SORTIE - TEMP_ENTREE → DELTA_TEMP;

### Multiplication

    /* Puissance électrique : P = U × I */
    - UPS:VOLTAGE * UPS:CURRENT → PUISSANCE;

### Division

    /* Rendement */
    - ENERGIE_PRODUITE / ENERGIE_CONSOMMEE → RENDEMENT;

!!! warning
    La division par zéro est indéfinie. Vérifiez que le diviseur est non nul avant d'effectuer une division.

### Combinaison d'opérations

Les opérations peuvent être combinées et parenthésées :

    /* Courbe de chauffe : consigne départ = -1.5 × Temp_ext + 75 */
    - (-1.5 * TEMP_EXT) + 75.0 → CHAUD:CONSIGNE_DEPART;

---

## Fonctions mathématiques

Le langage D.L.S dispose de fonctions mathématiques applicables à une valeur `arithmétique` :

| Fonction            | Description                            | Exemple |
|:--------------------|:---------------------------------------|:--------|
| `_ABS(x)`           | Valeur absolue                         | `_ABS(DELTA)` |
| `_SIN(x)`           | Sinus (x en radians)                   | `_SIN(ANGLE)` |
| `_COS(x)`           | Cosinus (x en radians)                 | `_COS(ANGLE)` |
| `_TAN(x)`           | Tangente (x en radians)                | `_TAN(ANGLE)` |
| `_ASIN(x)`          | Arc sinus                              | `_ASIN(RATIO)` |
| `_ACOS(x)`          | Arc cosinus                            | `_ACOS(RATIO)` |
| `_ATAN(x)`          | Arc tangente                           | `_ATAN(RATIO)` |
| `_EXP(x)`           | Exponentielle (e^x)                    | `_EXP(TAUX)` |
| `_LOG(x)`           | Logarithme naturel (ln)                | `_LOG(VALEUR)` |
| `_SQRT(x)`          | Racine carrée                          | `_SQRT(PUISSANCE)` |

Exemple d'usage :

    /* Calcul de la valeur absolue d'un écart */
    - _ABS(TEMP_CONSIGNE - TEMP_MESURE) → ECART_ABS;

---

## Régulateur PID

La fonction `_PID` permet d'implémenter un régulateur **Proportionnel-Intégral-Dérivé** pour asservir une grandeur physique à une consigne.

### Syntaxe

    - CONDITION → _PID(input=MESURE, consigne=CONSIGNE, kp=KP, ki=KI, kd=KD, outputmin=OUTMIN, outputmax=OUTMAX, output=SORTIE);

Tous les paramètres doivent être des [registres](dls_registres.md).

| Paramètre    | Description |
|:-------------|:------------|
| `input`      | Registre contenant la valeur mesurée (retour) |
| `consigne`   | Registre contenant la valeur souhaitée (setpoint) |
| `kp`         | Gain proportionnel |
| `ki`         | Gain intégral |
| `kd`         | Gain dérivé |
| `outputmin`  | Valeur minimale de la sortie PID |
| `outputmax`  | Valeur maximale de la sortie PID |
| `output`     | Registre de sortie recevant le résultat calculé |

### Réinitialisation du PID

Pour réinitialiser l'intégrateur du PID (notamment lors d'un changement de mode ou d'un démarrage), utilisez l'option `reset` sur le registre `input` :

    - CONDITION_RESET → input(reset);

### Exemple complet

    /* Régulation de température d'une chaudière */
    #define TEMP_MESURE    <-> _AI(libelle="Température départ mesurée", unite="°C");
    #define CONSIGNE       <-> _REGISTRE(libelle="Consigne température", unite="°C");
    #define KP             <-> _REGISTRE(libelle="Gain proportionnel");
    #define KI             <-> _REGISTRE(libelle="Gain intégral");
    #define KD             <-> _REGISTRE(libelle="Gain dérivé");
    #define OUT_MIN        <-> _REGISTRE(libelle="Sortie minimum", unite="%");
    #define OUT_MAX        <-> _REGISTRE(libelle="Sortie maximum", unite="%");
    #define OUVERTURE_VANNE <-> _AO(libelle="Consigne ouverture vanne", unite="%");
    #define RESULTAT_PID   <-> _REGISTRE(libelle="Résultat PID", unite="%");

    /* Initialisation des gains (valeurs fixes en exemple) */
    - 2.5  → KP;
    - 0.1  → KI;
    - 0.05 → KD;
    - 0.0  → OUT_MIN;
    - 100.0 → OUT_MAX;

    /* Exécution du PID si le mode régulation est actif */
    - MODE_REGULATION → _PID(input=TEMP_MESURE, consigne=CONSIGNE, kp=KP, ki=KI, kd=KD,
                             outputmin=OUT_MIN, outputmax=OUT_MAX, output=RESULTAT_PID);

    /* Application du résultat PID sur la vanne */
    - RESULTAT_PID → OUVERTURE_VANNE;

---

## Transfert de valeur entre bits

Il est possible de copier la valeur d'un registre ou d'une entrée analogique vers une sortie ou un autre registre :

    /* Copie directe */
    - AI_TEMPERATURE → REGISTRE_TEMP;

    /* Transfert conditionnel */
    - MODE_CONFORT → CONSIGNE_CONFORT → CONSIGNE_ACTIVE;
    - /MODE_CONFORT → CONSIGNE_ECO → CONSIGNE_ACTIVE;

---

## Priorités et parenthèses

Les règles de priorité arithmétique classiques s'appliquent. Pour forcer un ordre de calcul, utilisez des parenthèses :

    /* Sans parenthèses : A + (B * C) */
    - A + B * C → RESULTAT;

    /* Avec parenthèses : (A + B) * C */
    - (A + B) * C → RESULTAT;
