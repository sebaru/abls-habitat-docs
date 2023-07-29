# Programmation D.L.S: la zone de logique

C'est dans cette zone où toute l'intelligence logique du plugin va résider.
C'est elle qui définit l'ensemble des comportements attendus en fonction de l'environnement du module.

Cette zone est composée d'une suite de lignes (appelée dans la suite « ligne D.L.S ») dont le contenu suit la syntaxe suivante :

     - EXPRESSION -> LISTE_ACTIONS;

Elle commence par un tiret « - », suivi d'une **EXPRESSION**, suivi par une flèche (tiret « - » puis supérieur « > »), une liste d'actions séparées par des virgules et enfin, un point virgule terminal.

---

## Lier une expression à une action

Une **EXPRESSION** est un ensemble d'unités [`Booléennes`](#les-unites-boolennes) ou [`Arithmétiques`](#les-unites-arithmetique)
liées entre elles par des [opérateurs de base](#operateurs-de-base).

!!! warning
    Les operateurs ne peuvent être appliqués à des **EXPRESSION** de types différents. Par exemple, il n'est pas possible
    d'ajouter un `booléen` à une valeur `arithmétique`.

La « LISTE_ACTIONS » est une liste d'une ou plusieurs [actions](#lesactions), séparées par des virgules.

Voici un exemple de syntaxe :

    /* Un exemple */
    - PORTE:OUVERTE . ( /VERROU + TEMPO_BIPE ) → VISUEL_PORTE(mode="ouvert,couleur="red");

---

## Les unités `booléennes`

Les unités `booléennes` sont les suivantes:

| Classe    | Représentation 	|	Exemple |	Description |
|:---------:|:----------------|:--------|:----------- |
| [_DI](dls_entre_tor.md)       | Entrée TOR        |	PORTE:OUVERTE             |	Une entrée TOR peut avoir 2 valeurs : 0 ou 1 et représente l'état physique d'un capteur
| [_DO](dls_sortie_tor.md) 	    | Sortie TOR 	      | VANNE:OUVRIR 	            | Une sortie TOR peut avoir 2 valeurs : 0 ou 1, et représente l'état souhaité d'un actionneur
| [_B](dls_bistables.md) 	     | Bistable          |	SYS:FLIPFLOP_1SEC 	       | Bit dont la valeur est 0 ou 1, maintenu dans le temps. <br>Il faut explicitement coder la mise à zero du bit pour que celui-ci soit effectivement remis à 0.
| [_M](dls_monostables.md) 	   | Monostable 	      |SYS:TOP_1SEC 	             | Les monostables sont des bits furtifs, non maintenus dans le temps.<br>Si la condition initiale qui imposait le maintien du bit n'est plus vraie,<br>ce bit va alors tomber de lui-meme à 0.
| [_T](dls_tempo.md) 	         | Temporisation 	   | GARAGE:TEMPO_OUV_PORTE 	  | Les temporisations permettent de décaler, maintenir ou limiter dans le temps<br> un evenement particulier
| [_HORLOGE](dls_horloge.md) 	 | Horloge 	         | SALON:DMD_FERMETURE_VOLET |	Les horloges sont des valeurs binaires positionnées a une heure bien précise de la journée
| [_WATCHDOG](dls_watchdog.md)	| Watchdog 	        | PRESENCE:CPT_A_REBOURS 	  | Les comptes a rebours permettent de decompter le temps à partir d'un evenement<br>et de réagir si cet evenement n'est pas revenu au bout d'une consigne précise.
|  	| _TRUE | _TRUE | Cette unité est toujours ***vraie***
|  	| _FALSE | _FALSE | Cette unité est toujours ***fausse***


---

## Les unités `arithmétiques`

Les unités `arithmétiques` sont les suivantes:

| Classe    | Représentation 	|	Exemple |	Description |
|:---------:|:----------------|:--------|:----------- |
| [_AI](dls_entre_ana.md) 	    | Entrée Analogique | TEMP:JARDIN 	             | Une entrée Analogique représente une valeur d'un capteur analogique.<br> Celle-ci dispose d'options permettant au systeme de savoir comment interpréter<br>les informations fournies par les capteurs (4/20mA, 0-10V, ...)
| [_AO](dls_sortie_ana.md) 	   | Sortie Analogique |	CHAUDIERE:CONSIGNE 	      | Une sortie Analogique represente la valeur souhaitée d'un actionneur analogique. <br> Elle dispose d'options permettant au systeme de traduire une valeur reelle en valeur<br>compréhensible par les actionneurs.
| [_CI](dls_cpti.md) 	         | Compteur d'impulsions | 	PUIT:LITRE 	         | Incrémenté à chaque front montant de sa condition de pilotage
| [_CH](dls_cpth.md) 	         | Compteur Horaire 	| POMPE:DUREE_VIE 	         | Temps seconde représentant la durée effective de maintien de sa condition de pilotage
| [_R](dls_registres.md) 	     | Registre 	        | EDF:EQUIV_KWH 	           | Les registres permettent de manipuler des points de consignes, de seuil,<br>et permettent de réaliser des calculs
| | nombre a virgule | 22.3 | représente le nombre décimal 22.3 |
| | nombre a virgule | -1.2 | représente le nombre décimal -1.2 |

---

## Opérateurs de base pour lier les unités

### Le « . », ET

Dans une **EXPRESSION**, le « . » permet d'opérer la fonction logique ET entre deux sous-expressions de type `booléennes`.
Le résultat associé sera `booléen` lui aussi.

« a . b est vrai » si et seulement si « a est vrai » et « b est vrai ».

Exemple de syntaxe :

    /* Si a et b sont vrais alors nous positionnons c */
    - a . b → c;

!!! warning
    Le ET n'a pas de sens dans une « LISTE_ACTIONS ».

### Le « + », OU, Addition

Dans une **EXPRESSION**, le « + » permet d'opérer deux fonctions:

* la fonction logique OU entre deux sous-expressions de type `booléennes`. Dans ce cas le résultat sera `booléen`.

* la fonction mathématique d'addition entre deux sous-expressions de type `arithmétique`. Dans ce cas le résultat sera `arithmétique`.

Exemple de syntaxe :

    /* c aura la valeur de 10.0 (4+6) */
    - 4.0 + 6.0 → c;

    /* Si a, ou b, est vrai alors nous positionnons c */
    - a + b → c;

!!! warning
    Le OU n'a pas de sens dans une « LISTE_ACTIONS ».

### Le « - »: Soustraction

Dans une **EXPRESSION**, le « - » permet d'opérer la fonction mathématique de soustraction entre deux sous-expressions de type `arithmétiques`.
Dans ce cas le résultat sera également `arithmétique`.

    /* c prendra la valeur de a - b */
    - a - b → c;

!!! warning
    Le « - » n'a pas de sens dans une « LISTE_ACTIONS ».

### Le « / » : Complément et division

Dans une **EXPRESSION** `booléenne` ou une « LISTE_ACTIONS », le complément « / » permet d'opérer la fonction logique NON sur l'expression `booléenne` suivante.
Dans ce cas, le résultat est `booléen`.

    « /a est vrai » si « a est faux ».

    /* Si a est faux alors nous positionnons c à VRAI */
    - /a → c;

Dans une **EXPRESSION** `arithmétique`, le « / » permet d'opérer la fonction mathématique de division entre deux sous-expressions `arithmétiques`.
« 10 / 2.0 » sera la valeur 5.0.

    /* c représentera le coefficient temp_chaud divisé par temp_froid */
    - TEMP_CHAUD / TEMP_FROID → c;

### Le « * » : Multiplication

Dans une **EXPRESSION** `arithmétique`, le « * » permet d'opérer la fonction mathématique de multiplication entre deux sous-expressions `arithmétiques`.
« 10.0 * 2.0 » sera la valeur 20.0.

    /* c obtient la valeur de 20.0 */
    - 10.0 * 2.0 → c;

    /* c représentera la puissance P=U*I */
    - UPS_VOLTAGE * UPS_CURRENT → c;

---

## Les comparaisons

### La comparaison `arithmétique`

Dans une **EXPRESSION** `arithmétique`, les opérateurs « <, <=, =, >=, > » permettent d'opérer une comparaison entre deux valeurs `arithmétiques`.
le résultat sera lui `booléen`.

    /* Si TEMP est strictement supérieure à 15, c est positionné à 1 */
    - TEMP > 15.0 → c;

    /* Si TEMP est inférieure ou égale à -5, c est positionné à 1 */
    - TEMP <= -5.0 → c;

### Les comparaisons horaires

Dans une **EXPRESSION** `arithmétique`, le mot clef **_HEURE** peut s'utiliser dans une comparaison pour agir selon l'heure de la journée.
le résultat sera lui `booléen`.

    /* c est positioné à 1 à 7 heure du matin */
    - _HEURE = 07:00 → c;

    /* HEURE_OUVREE est vraie entre 09h et 18h */
    - _HEURE >=09:00 . _HEURE <=18:00 -> HEURE_OUVREE;

---

## Précédences et parenthèses

Les priorités d'opérations sont les suivantes, dans l'ordre décroissant de priorité (du plus prioritaire au moins prioritaire):

1. Le NON
1. Le ET
1. Le OU

Ce système de priorité peut être modifié en utilisant les parenthèses ouvrantes et fermantes.

Exemple de syntaxe:

    /* Si a est vrai, ou b et c sont vrais, alors nous positionnons d à 1 */
    -  a + b . c → d;

    /* Si a ou b est vrai, et c est vrai alors nous positionnons d à 1 */
    - (a+b) . c  → d;

    /* Si a est vrai, et que l'on a ni b ni c, alors nous positionnons c à 0 */
    - a . /(b+c) → /c;

---

##Logique étendue

Il est possible de compléter un comportement par des options. La modification du comportement sera fonction des options elles-mêmes.
La syntaxe retenue est la suivante:

     - EXPRESSION -- liste_options -> LISTE_ACTIONS;

Aujourd'hui, les options disponibles sont les suivantes;

* daa = valeur : Ajoute un délai (en dixième de seconde) entre le momemt ou l'**EXPRESSION** devient vraie et le moment ou la LISTE_ACTIONS sera effectivement réalisée

Exemples:

    - EXPRESSION -- daa = 100 -> ACTION; /* ACTION sera lancée 10 secondes après que l'EXPRESSION devienne vraie. */

---

##Les actions

La **LISTE_ACTIONS** est une liste d'**ACTION** séparées par des virgules. Selon le type de l'**EXPRESSION**, elle peut etre
interprétée de deux manières différentes.

###Les actions `booléennes`

Lorsque l'**EXPRESSION** est de type `booléen`, chacune des **ACTIONS** de la **LISTE_ACTIONS** représente une opération à réaliser
lorsque cette **EXPRESSION** est VRAIE.

Dans ce cas, les **ACTIONS** possibles sont:

* Positionner une [sortie TOR](dls_sortie_tor.md)
* Positionner un [bistable](dls_bistables.md)
* Positionner un [monostable](dls_monostables.md)
* Positionner une [temporisation](dls_tempo.md)
* Positionner un [compteur d'impulsion](dls_cpti.md)
* Positionner un [compteur horaire](dls_cpth.md)
* Positionner un [watchdog](dls_watchdog.md)

Exemple:

    /* Si a et b sont vraies, La sortie contacteur est activée */
    /* et le compteur horaire de service continue de compter */
    - a . b → DO_SORTIE_CT, CH_CT;

###Les actions `arithmétiques`

Lorsque l'**EXPRESSION** est de type `arithmétique`, chacune des **ACTIONS** de la **LISTE_ACTIONS** représente l'élément cible devant
recevoir la valeur arithmétique de l'**EXPRESSION**.

Dans ce cas, la seule **ACTION** possibles aujourd'hui est:

* Positionner un [registre](dls_registres.md)

Exemple:

    /* MON_REGISTRE obtient la valeur de 10.0 */
    - 10.0 -> MON_REGISTRE;

---
## Les options
Chaque unités ou action peut être complétée par une liste d'options pour moduler son interprétation ou configurer ses paramètres.
Ces options sont décrites dans chacune des pages présentant les classes de bits internes.
