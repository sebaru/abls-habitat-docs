# Les régulateurs `_PID`

Le `_PID` implémente une **régulation proportionnelle, intégrale et dérivée** : il calcule en
continu une commande de sortie pour amener une mesure vers une consigne.

Typiquement : piloter une vanne de mélange pour tenir une température de départ de chauffage,
ou moduler la vitesse d'un circulateur.

---

## Une action, pas un objet à déclarer

Contrairement aux autres types, `_PID` **ne se déclare pas** avec `#define`. Il s'écrit
directement comme une **action**, dans la partie droite d'une règle :

```dls
- CONDITION -> _PID( input=MESURE, consigne=CONSIGNE,
                     kp=KP, ki=KI, kd=KD,
                     min=SORTIE_MIN, max=SORTIE_MAX,
                     output=COMMANDE );
```

Le calcul n'est effectué que pendant les tours où la condition est vraie.

---

## Options

Toutes les options désignent obligatoirement des [registres](registres.md) (`_R`).

| Option | Rôle |
|---|---|
| `input` | Registre portant la **mesure** |
| `consigne` | Registre portant la **valeur visée** |
| `kp` | Registre portant le gain **proportionnel** |
| `ki` | Registre portant le gain **intégral** |
| `kd` | Registre portant le gain **dérivé** |
| `min` | Registre bornant la sortie par le bas |
| `max` | Registre bornant la sortie par le haut |
| `output` | Registre recevant la **commande calculée** |
| `reset` | `reset=1` : remet à zéro l'état interne du régulateur |

!!! danger "Tous les paramètres doivent être des registres"
    Une valeur littérale est refusée à la compilation : `PID : kp must be R.`
    Déclarez un registre, même pour un gain constant.

---

## Exemple complet

```dls
#define TEMP_DEPART   <-> _R(libelle="Température de départ mesurée", unite="°C");
#define TEMP_CONSIGNE <-> _R(libelle="Consigne de départ", unite="°C", rw);

#define PID_KP  <-> _R(libelle="Gain proportionnel", rw);
#define PID_KI  <-> _R(libelle="Gain intégral", rw);
#define PID_KD  <-> _R(libelle="Gain dérivé", rw);
#define PID_MIN <-> _R(libelle="Ouverture minimale", unite="%");
#define PID_MAX <-> _R(libelle="Ouverture maximale", unite="%");

#define VANNE   <-> _R(libelle="Ouverture de la vanne", unite="%");
#define AO_VANNE <-> _AO(libelle="Commande vanne 0-10V");

#define REGULATION_ACTIVE <-> _B(libelle="Régulation en service");

/* Initialisation des gains au démarrage */
- _START -> PID_KP = 2.0, PID_KI = 0.05, PID_KD = 0.0,
            PID_MIN = 0.0, PID_MAX = 100.0;

/* Calcul du PID tant que la régulation est active */
- REGULATION_ACTIVE -> _PID( input=TEMP_DEPART, consigne=TEMP_CONSIGNE,
                             kp=PID_KP, ki=PID_KI, kd=PID_KD,
                             min=PID_MIN, max=PID_MAX,
                             output=VANNE );

/* Report sur la sortie analogique */
- REGULATION_ACTIVE -> AO_VANNE = VANNE;

/* Remise à zéro de l'intégrale quand la régulation est coupée */
- /REGULATION_ACTIVE -> _PID( reset=1, input=TEMP_DEPART );
```

---

## Le `reset`, un réflexe à prendre

L'intégrateur accumule l'écart entre mesure et consigne. Si la régulation est coupée pendant que
l'écart persiste, cette accumulation continue de vivre et provoquera un à-coup au redémarrage —
c'est l'effet dit *d'emballement de l'intégrale*.

!!! warning "Remettez toujours le PID à zéro quand vous le désactivez"
    ```dls
    - /REGULATION_ACTIVE -> _PID( reset=1, input=MESURE );
    ```

    Faites de même après un changement brutal de consigne ou un passage en manuel.

---

## Régler les gains

Une méthode pragmatique, dans cet ordre :

1. **`ki = 0`, `kd = 0`.** Augmenter `kp` jusqu'à obtenir une réaction franche sans oscillation
   entretenue. Un écart résiduel permanent subsiste : c'est normal.
2. **Introduire `ki`** par petites valeurs, jusqu'à ce que l'écart résiduel disparaisse en
   quelques minutes. Trop de `ki` provoque un dépassement puis des oscillations lentes.
3. **`kd` reste souvent à zéro.** Sur des grandeurs thermiques bruitées, le terme dérivé amplifie
   le bruit plus qu'il n'aide.

!!! tip "Déclarez les gains en `rw`"
    Avec l'option `rw`, les registres de gains sont modifiables depuis un synoptique.
    Vous réglez la boucle en observant la réponse réelle, sans recompiler le module.

---

## Bornage

`min` et `max` ne sont pas des garde-fous cosmétiques : ils définissent la plage physique de
l'actionneur. Une sortie bornée protège l'équipement et limite l'emballement de l'intégrale.

Pour une vanne : `min = 0`, `max = 100`.
Pour un circulateur à vitesse minimale imposée : `min = 30`.

---

## Diagnostic

| Symptôme | Cause probable | Correction |
|---|---|---|
| La sortie oscille rapidement | `kp` trop élevé | Diviser `kp` par deux |
| La sortie oscille lentement, avec dépassement | `ki` trop élevé | Réduire `ki` |
| L'écart ne se résorbe jamais | `ki` nul ou trop faible | Augmenter `ki` |
| À-coup au redémarrage de la régulation | Intégrale non remise à zéro | Ajouter la règle de `reset` |
| La sortie reste collée à `max` | Consigne inatteignable, ou mesure erronée | Vérifier le capteur et le mapping |
| `PID : input must be R.` à la compilation | Une option pointe sur autre chose qu'un registre | Déclarer un `_R` |

---

## Voir aussi

- [Registres](registres.md)
- [Sorties analogiques](ao.md)
- [Zone de calculs](../calculs.md)
