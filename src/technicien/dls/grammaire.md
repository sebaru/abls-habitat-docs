# Grammaire D.L.S — Référence complète

Cette page constitue la **référence grammaticale complète** du langage D.L.S.

```
module := listeDefinitions listeInstructions

listeDefinitions :=
    | #define ACRONYME <-> CLASSE (OPTIONS);
    | #link TECH_ID:ACRONYME (OPTIONS);
    | #param ACRONYME (OPTIONS);

listeInstructions :=
    | - EXPRESSION -> LISTE_ACTIONS;
    | - EXPRESSION -- OPTIONS -> LISTE_ACTIONS;
    | - EXPRESSION -> { listeInstructions }
    | switch listeCase

listeCase :=
    | | - EXPRESSION -> LISTE_ACTIONS;
    | | - -> LISTE_ACTIONS;   /* cas par défaut */

EXPRESSION :=
    | EXPRESSION . EXPRESSION          /* ET booléen */
    | EXPRESSION + EXPRESSION          /* OU booléen / Addition arithmétique */
    | EXPRESSION - EXPRESSION          /* Soustraction arithmétique */
    | EXPRESSION * EXPRESSION          /* Multiplication arithmétique */
    | EXPRESSION / EXPRESSION          /* Division arithmétique */
    | / ( EXPRESSION )                 /* NON booléen */
    | ( EXPRESSION )                   /* Parenthèses */
    | EXPRESSION < EXPRESSION          /* Comparaison → booléen */
    | EXPRESSION <= EXPRESSION
    | EXPRESSION = EXPRESSION
    | EXPRESSION >= EXPRESSION
    | EXPRESSION > EXPRESSION
    | _HEURE ORDRE HH:MM               /* Comparaison horaire */
    | _LUNDI | _MARDI | ... | _DIMANCHE
    | _START | _TRUE | _FALSE
    | _EXP(EXPRESSION) | _SIN(EXPRESSION) | ...
    | NOMBRE_REEL
    | ACRO_ALIAS (OPTIONS)             /* Bit interne, avec options optionnelles */

LISTE_ACTIONS :=
    | ACTION
    | LISTE_ACTIONS , ACTION

ACTION :=
    | ACRONYME (OPTIONS)               /* Positionner un bit avec options optionnelles */
    | / ACRONYME                       /* Forcer un bit à FAUX (booléen) */
    | _PID (OPTIONS)                   /* Calcul PID */
    | _NOP                             /* Aucune action */
```
