# Programmation D.L.S: les calculs

Le calcul D.L.S permet, en fonction d'une condition prédéfinie,
de calculer la valeur a positionner dans un registre ou une sortie analogique en fonction d'expression booléennes ou arithmétiques.
Tout comme la ligne logique, celle-ci commence par un tiret « - », suivi d'une « EXPRESSION »
qui représente l'expression du calcul arithmétique a réaliser, suivi d'une flèche (tiret « - » puis supérieur « > »),
et pour finir d'un alias représentant le registre de destination ou la sortie analogique associée. Le point virgule terminal reste obligatoire.

Exemple, le resultat du calcul de l'**EXPRESSION** est reportée dans l'alias **RESULTAT**.

     - EXPRESSION -> RESULTAT;

2nd Exemple:

     /* Dans VENT.dls */
     #define VITESSE <-> _R(libelle="vitesse du vent", unite="m/s");
     - VITESSE + 1.0 -> VITESSE;

Toutes les secondes, le registre **VITESSE** est augmenté de 1.
