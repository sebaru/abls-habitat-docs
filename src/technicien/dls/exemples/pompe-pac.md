# Exemple : pompe à chaleur

Le module `POMPE_PAC` pilote un télérupteur commandant le circulateur d'une pompe à chaleur.
C'est l'exemple le plus complet : il combine modes de fonctionnement, sécurité par seuil,
détection de défaut par temporisation, compteurs et notifications.

---

## Structure du module

Le module est organisé en sections commentées, dans un ordre stable :

```dls
/* Bits de consommation du module   — ce qu'il lit          */
/* Bits de production du module     — ce qu'il expose       */
/* Bits de notifications            — messages et visuels   */
/* Bits purement internes           — sa mécanique propre   */
/* EVENEMENTS                                               */
/* SYNTHESES DEFAUTS ET ALARMES                             */
/* COMPTE RENDUS DES VIGNETTES                              */
/* FONCTIONS PILOTEES                                       */
```

!!! tip "Adoptez ce découpage"
    Séparer ce que le module **consomme**, ce qu'il **produit** et ce qui lui est **interne**
    rend immédiatement lisible son contrat avec le reste du domaine.

---

## Les déclarations

```dls
/* Bits de consommation du module */
  #define DI_POS_TELE  <-> _DI;                           /* Position du télérupteur */
  #define O_TXT_START  <-> _DI(map_sms="POMPE_PAC ON");   /* Ordre SMS de démarrage */
  #define O_TXT_STOP   <-> _DI(map_sms="POMPE_PAC OFF");  /* Ordre SMS d'arrêt */

/* Bits de production du module */
  #define DO_ACT_TELE        <-> _DO;   /* Commande du télérupteur */
  #define MDEF_REPOS_PAC     <-> _B(libelle="Défaut repos non acquitté du TL");
  #define MDEF_TRAVAIL_PAC   <-> _B(libelle="Défaut travail non acquitté du TL");
  #define TIME_POMPE_PAC     <-> _CH(libelle="Temps de marche pompe PAC");
  #define CI_POMPE_PAC       <-> _CI(libelle="Compteur de manoeuvre TL pompe PAC");

/* Notifications */
  #define MSG_PAC_ON  <-> _MSG(type=etat,   libelle="Pompe PAC activée",   notif_sms=yes);
  #define MSG_PAC_OFF <-> _MSG(type=etat,   libelle="Pompe PAC désactivée", notif_sms=yes);
  #define MSG_PAC_DEF_REPOS <-> _MSG(type=defaut, libelle="Défaut repos TL Pompe PAC",
                                     notif_sms=yes);
  #define MSG_VERROU_TEMP_BALLON_TH <-> _MSG(type=defaut,
      libelle="Température ballon trop haute ($TEMP:BALLON_HAUT): pompe PAC forcée.",
      notif_sms=yes);

  #define VISU_POMPE     <-> _I(forme="2d_pompe",  libelle="Pompe PAC");
  #define VISU_MODE_AUTO <-> _I(forme="auto_manu", libelle="Mode de fonctionnement");

/* Bits internes */
  #define MODE_AUTO <-> _B(groupe=1, libelle="Mode automatique");
  #define MODE_MANU <-> _B(groupe=1, libelle="Mode manuel");

  #define ME_WANT_TELE <-> _B(libelle="Etat attendu du TL (0=ouvert, 1=fermé)");
  #define ME_ACT_TELE  <-> _B(libelle="Demande de manoeuvre du TL");
  #define VERROU_TEMP_BALLON_TH <-> _B(libelle="Verrou température ballon trop haute");

  #define TR_DEF_TELE <-> _T(daa=20, dma=0, dMa=0, dad=0,
                             libelle="Détection de défaut sur Pompe PAC");
  #define TITELE      <-> _T(daa=0, dma=0, dMa=3, dad=0,
                             libelle="Impulsion de manoeuvre du TL PAC");

/* Initialisation */
 - _START -> MODE_AUTO;
```

---

## Les schémas à retenir

### Modes exclusifs avec `groupe`

```dls
#define MODE_AUTO <-> _B(groupe=1, libelle="Mode automatique");
#define MODE_MANU <-> _B(groupe=1, libelle="Mode manuel");
```

Deux bistables du même `groupe` sont **mutuellement exclusifs** : activer l'un désactive l'autre
automatiquement. Vous n'avez pas à écrire la règle de désactivation, et il est impossible de se
retrouver dans un état incohérent.

### Initialisation par `_START`

```dls
- _START -> MODE_AUTO;
```

`_START` n'est vrai que pendant le premier tour d'exécution du module. C'est l'endroit où poser
les valeurs par défaut, et le seul moyen de garantir un état initial connu après redémarrage.

### Bascule par un bouton

```dls
- VISU_MODE_AUTO_CLIC ->
  {
    switch
      | - MODE_AUTO -> MODE_MANU;
      | -           -> MODE_AUTO;
  }
```

Le `switch` évalue les branches dans l'ordre et s'arrête à la première vraie. La dernière branche,
sans condition, joue le rôle de cas par défaut.

### Séparer l'intention et la manœuvre

```dls
- MODE_AUTO . /ME_ACT_TELE ->
  {
    switch
      | - VERROU_TEMP_BALLON_TH -> ME_WANT_TELE;
      | -                       -> /ME_WANT_TELE;
  }
```

`ME_WANT_TELE` porte **l'état souhaité**, `ME_ACT_TELE` porte **la demande de manœuvre**.
Un télérupteur ne se commande pas par un niveau mais par une impulsion : il faut donc comparer
l'état souhaité à l'état lu (`DI_POS_TELE`) et n'émettre l'impulsion qu'en cas d'écart.

!!! tip "Le motif est général"
    Dès que l'actionneur a une mémoire propre (télérupteur, relais bistable, vanne motorisée),
    dissociez systématiquement l'intention de l'ordre de manœuvre. Sinon vous commanderez en
    permanence un équipement déjà dans le bon état.

### Impulsion calibrée par `dMa`

```dls
#define TITELE <-> _T(daa=0, dma=0, dMa=3, dad=0, libelle="Impulsion de manoeuvre");
```

`dMa` (durée maximale d'activation) limite la durée du maintien : l'impulsion dure au plus
3 dixièmes de seconde, même si la condition reste vraie. C'est exactement ce qu'attend une bobine
de télérupteur, qui grillerait sous alimentation permanente.

### Détection de défaut par écart persistant

```dls
#define TR_DEF_TELE <-> _T(daa=20, dma=0, dMa=0, dad=0);
```

`daa` (délai d'activation) retarde la prise en compte de 2 secondes. Si l'état lu du télérupteur
ne correspond toujours pas à l'état commandé après ce délai, c'est un défaut réel et non un
temps de manœuvre normal.

!!! warning "Sans temporisation, vous détecterez un défaut à chaque manœuvre"
    Entre l'impulsion et le basculement mécanique, l'écart est normal. Le `daa` est ce qui
    distingue une transition d'une panne.

### Défaut acquitté et non acquitté

```dls
#define MDEF_REPOS_PAC   <-> _B(libelle="Défaut repos non acquitté");
#define MDEF_REPOS_F_PAC <-> _B(libelle="Défaut repos acquitté (fixe)");
```

Deux bistables pour un même défaut : l'un clignote tant que l'utilisateur n'a pas acquitté,
l'autre reste fixe une fois l'acquittement fait mais le défaut toujours présent.
C'est la convention d'alarme classique en supervision industrielle.

### Verrou de sécurité prioritaire

```dls
- TEMP:BALLON_HAUT >= 70.0 -> VERROU_TEMP_BALLON_TH, MSG_VERROU_TEMP_BALLON_TH;
```

Une condition physique de sécurité force le fonctionnement indépendamment du mode choisi par
l'utilisateur. Le message associé explique **pourquoi** l'équipement ne suit plus la commande,
ce qui évite les appels au support.

!!! tip "Toujours notifier un forçage"
    Un équipement qui ne répond pas à la commande, sans explication, est perçu comme une panne.
    Un message de type `defaut` transforme l'incompréhension en information.

### Compter la marche et les manœuvres

```dls
#define TIME_POMPE_PAC <-> _CH(libelle="Temps de marche pompe PAC");
#define CI_POMPE_PAC   <-> _CI(libelle="Compteur de manoeuvre TL pompe PAC");
```

Le [compteur horaire](../objets/compteurs-horaires.md) cumule le temps de fonctionnement, le
[compteur d'impulsions](../objets/compteurs-impulsions.md) compte les manœuvres.
Les deux sont la base de la maintenance préventive : un nombre de manœuvres anormalement élevé
révèle un cycle court avant que l'équipement ne casse.

### Commande par SMS

```dls
#define O_TXT_START <-> _DI(map_sms="POMPE_PAC ON");
```

L'option `map_sms` suffit à créer la commande texte. Voir
[Commander par SMS](../../../utilisateur/commandes-sms.md).

---

## Pour aller plus loin

- [Bistables](../objets/bistables.md) · [Temporisations](../objets/tempos.md)
- [Compteurs horaires](../objets/compteurs-horaires.md)
- [Messages](../objets/messages.md)
- [Exemple suivant : météo et notifications](meteo.md)
