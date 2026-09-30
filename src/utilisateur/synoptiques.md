# Lire un synoptique

Le **synoptique** est la page principale : une représentation imagée de votre habitat, mise à
jour en temps réel.

---

## Ce que vous voyez

Un synoptique est composé d'images appelées **visuels**. Chacune représente un équipement réel :
une lampe, un volet, une pompe, un capteur de température.

Un visuel vous dit deux choses :

- **par sa forme**, de quel équipement il s'agit ;
- **par sa couleur et son animation**, dans quel état il se trouve.

---

## Le code couleur

Les couleurs sont les mêmes partout dans l'installation.

| Couleur | Signification |
|---|---|
| **Gris** | À l'arrêt, éteint, au repos |
| **Vert** | En marche, allumé, ouvert — fonctionnement normal |
| **Blanc** ou **bleu clair** | Information, état neutre |
| **Jaune** | Attention, situation à surveiller |
| **Orange** | Anomalie, dérangement |
| **Rouge** | Défaut ou danger |
| **Noir** | Information indisponible |

!!! tip "La règle à retenir"
    Plus la couleur est chaude, plus la situation demande votre attention.
    Un synoptique entièrement vert ou gris, c'est une installation qui va bien.

---

## Les animations

| Aspect | Signification |
|---|---|
| **Fixe** | L'état est stable, et il a été pris en compte |
| **Clignotant** | Quelque chose de nouveau réclame votre attention |

!!! note "Un clignotement s'arrête quand vous acquittez"
    Un équipement en défaut clignote tant que personne n'a signalé avoir vu le problème.
    Une fois [acquitté](messages.md#acquitter-un-message), il reste coloré mais cesse de
    clignoter : vous savez que le défaut persiste, sans être sollicité en permanence.

---

## Les valeurs chiffrées

Certains visuels affichent un nombre : une température, une consommation, un pourcentage.

Les cadrans à jauge changent de couleur selon des seuils réglés par votre technicien : vert dans
la plage normale, orange puis rouge au-delà.

---

## Agir sur un équipement

**Cliquez** — ou touchez, sur mobile — le visuel de l'équipement.

Selon ce qui a été prévu :

- une lampe s'allume ou s'éteint ;
- un volet s'ouvre ou se ferme ;
- un mode bascule entre automatique et manuel ;
- une valeur devient modifiable.

!!! note "Le changement n'est pas toujours immédiat"
    Certains équipements prennent du temps : un volet met plusieurs secondes, une pompe à chaleur
    peut attendre une temporisation de sécurité. Le visuel se met à jour lorsque l'équipement a
    réellement changé d'état, pas au moment du clic.

!!! warning "Tous les visuels ne sont pas cliquables"
    Un capteur de température ne se commande pas. Si rien ne se produit au clic, c'est
    probablement un visuel d'information seule — ou votre niveau d'accès ne permet pas cette
    commande.

---

## Passer d'une page à l'autre

Une installation comporte généralement plusieurs synoptiques : une vue d'ensemble, puis une page
par étage, par pièce ou par fonction.

Le sélecteur en haut de page permet de naviguer entre elles. Certains visuels servent aussi de
lien : cliquer sur une pièce du plan général ouvre la page de cette pièce.

---

## Les sections de la page

Selon ce qu'a prévu votre technicien, la page peut contenir plusieurs zones :

| Zone | Contenu |
|---|---|
| **Commandes rapides** | Les actions les plus fréquentes |
| **Caméras** | Les images en direct — voir [Les caméras](cameras.md) |
| **Vue détaillée** | Le plan ou le schéma principal |
| **Courbes** | Des graphiques d'évolution — voir [Les courbes](tableaux-courbes.md) |
| **Messages** | Les derniers événements — voir [Le fil de l'eau](messages.md) |

---

## Si rien ne bouge

L'affichage se met à jour tout seul, en continu. Si les valeurs semblent figées :

1. Rafraîchissez la page.
2. Vérifiez votre connexion réseau.
3. Si le problème persiste, signalez-le au responsable de l'habitat : c'est peut-être
   l'installation elle-même qui ne remonte plus ses informations.

---

## Voir aussi

- [Le fil de l'eau](messages.md)
- [Les courbes](tableaux-courbes.md)
- [Questions fréquentes](faq.md)
