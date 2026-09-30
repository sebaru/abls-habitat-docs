# Programmation D.L.S: les Paramètres

Les paramètres permettent de rendre un module D.L.S **configurable** : certaines valeurs numériques ou textuelles du code source peuvent être externalisées, nommées, et modifiées depuis l'interface web sans toucher au code du module.

---
## À quoi sert `#param` ?

Un module D.L.S est compilé avant d'être exécuté. Toutes les valeurs codées en dur dans le source (seuils, durées, adresses, identifiants…) sont figées à la compilation.

La directive `#param` permet de **définir un paramètre nommé** associé au module. Ce paramètre est stocké en base de données et son nom est utilisé comme variable de substitution (`$ACRONYME`) dans le reste du code source.

**Avant chaque compilation**, le moteur remplace automatiquement chaque occurrence de `$ACRONYME` par la valeur courante du paramètre. Modifier la valeur d'un paramètre depuis la console **déclenche une recompilation automatique** du module.

!!! note
    Cela permet, par exemple, de régler une consigne de température ou une durée de temporisation depuis l'interface web, sans modifier ni republier le code source du module D.L.S.

---
## Syntaxe

    #param ACRONYME (libelle="Description lisible", defaut=valeur_par_defaut);

| Élément               | Description |
|:----------------------|:------------|
| `ACRONYME`            | Nom du paramètre, en majuscules. Sera référencé dans le code sous la forme `$ACRONYME`. |
| `libelle`             | Texte affiché à l'opérateur dans l'interface web pour identifier ce paramètre. |
| `defaut`              | Valeur initiale appliquée lors de la première compilation. Peut être un entier ou une chaîne de caractères. |

!!! warning
    Lors d'une recompilation, la valeur courante en base de données est **conservée**. Seul le `libelle` est mis à jour. La valeur par défaut n'est utilisée qu'à la création initiale du paramètre.

---
## Utilisation dans le code source

Pour utiliser la valeur d'un paramètre dans le code, préfixez son acronyme avec `$` :

    $ACRONYME

Le moteur substitue cette chaîne par la valeur stockée avant de lancer la compilation. Le `$ACRONYME` peut apparaître n'importe où dans le code source : dans les options d'une classe, dans une condition ou dans une action.

---
## Exemples

### Consigne de seuil numérique

Un module de régulation de chauffage dont le seuil de déclenchement doit être réglable par l'utilisateur :

    /* Zone des paramètres */
    #param SEUIL_CHAUFFE (libelle="Seuil de déclenchement du chauffage (°C)", defaut=19);

    /* Zone des acronymes */
    #define TEMP_INT  <-> _AI(libelle="Température intérieure");
    #define CDE_CHAUF <-> _DO(libelle="Commande chaudière");

    /* Zone de logique */
    - ( TEMP_INT < $SEUIL_CHAUFFE ) -> CDE_CHAUF;

Dans cet exemple, si l'opérateur modifie `SEUIL_CHAUFFE` à `21` depuis la console, le module est recompilé et la condition devient `TEMP_INT < 21`.

---
### Durée de temporisation réglable

    /* Zone des paramètres */
    #param DUREE_ALERTE (libelle="Durée avant déclenchement de l'alerte (secondes)", defaut=30);

    /* Zone des acronymes */
    #define DETECTEUR <-> _DI(libelle="Détecteur de présence");
    #define TEMPO_ALERTE <-> _T(daa=$DUREE_ALERTE);
    #define MSG_ALERTE <-> _MSG(libelle="Alerte intrusion");

    /* Zone de logique */
    - DETECTEUR -> TEMPO_ALERTE;
    - TEMPO_ALERTE:ETAT -> MSG_ALERTE;

---
### Paramètre de type chaîne de caractères

Les paramètres peuvent également être des chaînes, utiles pour références d'équipements ou d'adresses :

    /* Zone des paramètres */
    #param ADRESSE_IP (libelle="Adresse IP de l'équipement", defaut="192.168.1.100");

    /* Zone des acronymes */
    #define PING_OK <-> _DI(libelle="Équipement joignable");

---
### Module générique instancié plusieurs fois

Un même modèle de module (p. ex. gestion d'une prise connectée) peut être paramétré différemment pour chaque instance :

    /* Module PRISE_SALON */
    #param TECH_SHELLY (libelle="Tech_id du module Shelly associé", defaut="SHELLY_01");

    #link $TECH_SHELLY:ETAT;

    - $TECH_SHELLY:ETAT -> MON_BISTABLE;

---
## Gestion depuis la console

Les paramètres d'un module D.L.S sont visibles et modifiables depuis la console, dans le menu **Configuration → Modules D.L.S**, en sélectionnant le module concerné puis l'onglet **Paramètres**.

Chaque paramètre est affiché avec :

* son **acronyme**
* son **libellé** (tel que défini dans `#param`)
* sa **valeur courante**, modifiable par l'opérateur

Toute modification de valeur **déclenche automatiquement une recompilation** du module D.L.S concerné.

---
## Points clés à retenir

* `#param` se place dans la **zone de définition** du module (avant la logique).
* La référence dans le code se fait avec le préfixe `$` : `$ACRONYME`.
* La valeur par défaut n'est utilisée **qu'à la première compilation** (création initiale).
* Modifier un paramètre depuis la console **recompile automatiquement** le module.
* Les paramètres sont propres à chaque module D.L.S (scope `tech_id`).
