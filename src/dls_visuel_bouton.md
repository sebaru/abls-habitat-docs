# Les Visuels Bouton

Les visuels **bouton** d'un module D.L.S sont des visuels de `forme`="bouton" représentant un bouton dont le titre est son `libelle`
et affiché de la couleur `color`.
Par exemple, voici la définition complète d'un visuel **bouton**:

    /* Nous sommes dans le D.L.S "TECH_ID" */
    /* Déclaration d'un visuel de forme 'bouton' */
    #define MON_BOUTON <-> _I(forme="bouton", libelle="Cliquez moi !", color="blue", cligno);

Cette déclaration permet de creer un bouton **Cliquez moi !**, de couleur **bleu**, et **clignotant**.

Afin de capter l'évènement de clic de la part de l'utilisateur,
bit **DI** nommé par la concaténation de son acronyme et de **_CLIC** lui est automatiquement accroché.

Exemple:

    #define MON_BOUTON <-> _I(forme="bouton", libelle="Cliquez moi !", color="blue");
    /*------MON_BOUTON_CLIC <-> _DI; Automatiquement le bit DI MON_BOUTON_CLIC est créé */

    /* En cas de clic, UNE_ACTION est lancée */
    - MON_BOUTON_CLIC -> UNE_ACTION;


---
##Désactiver le clic bouton

Un bouton peut ne plus être cliquable, en utilisant l'option `disable`.
Ainsi, il devient grisé et un appui dessus restera sans suite.

Par défaut, un bouton n'est pas `disable`, et reste donc cliquable.

Exemple:

    /* Déclaration d'un visuel de forme 'bouton' */
    #define MON_BOUTON <-> _I(forme="bouton", libelle="Fermer", color="blue");
    /* Si la porte est ouverte, le bouton "fermer" n'est plus cliquable */
    - PORTE_OUVERTE -> MON_BOUTON(disable);

---
##Les couleurs des boutons

Les couleurs possibles des boutons sont les suivantes:

* blue
* red
* orange
* green
* gray
* black

---
##Attribut de clignotement

Un bouton, peut éventuellement etre clignotant, si l'option `cligno` est renseignée dans ses options.
Cependant, l'usage de cet attribut peut nuire a la compréhension.

Exemple:

    #define MON_BOUTON <-> _I(forme="bouton", libelle="Cliquez moi !", color="blue");
    - TEMPS:IL_PLEUT -> MON_BOUTON(cligno);  /* En cas de pluie, le bouton est clignotant */
    - TEMPS:IL_PLEUT -> MON_BOUTON(cligno=1);/* Cette syntaxe est autorisée également */
