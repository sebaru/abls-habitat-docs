# Gérer les mnémoniques

Les **mnémoniques** sont les variables internes du domaine Abls-Habitat.
Chaque mnémonique représente un point de données : état d'un capteur, valeur d'une mesure, résultat d'un calcul D.L.S, commande vers une sortie…

La page [/mnemos](https://console.abls-habitat.fr/mnemos) est la vue centralisée de l'ensemble des variables du domaine.
Elle est particulièrement utile pour diagnostiquer des problèmes et vérifier l'état du système.

---

## 1. Accéder à la page des mnémoniques

Depuis la console, accédez à [/mnemos](https://console.abls-habitat.fr/mnemos).

La page affiche **tous les mnémoniques** du domaine, classés par type.

!!! tip "Les mnémoniques sont créés automatiquement"
    Les mnémoniques sont générés lors de la **compilation des modules D.L.S** et lors de la **configuration des mappings I/O**.
    Vous n'avez pas besoin de les créer manuellement.

---

## 2. Types de mnémoniques

| Type | Classe | Description |
|---|---|---|
| **Bistable** | `B` | Variable binaire (vrai/faux) calculée par le D.L.S |
| **Monostable** | `M` | Impulsion brève générée par le D.L.S |
| **Tempo** | `TEMPO` | Temporisateur utilisé dans la logique D.L.S |
| **Entrée TOR** | `DI` | Valeur lue depuis une entrée physique tout-ou-rien |
| **Sortie TOR** | `DO` | Valeur envoyée vers une sortie physique TOR |
| **Entrée Ana** | `AI` | Valeur lue depuis une entrée analogique |
| **Sortie Ana** | `AO` | Valeur envoyée vers une sortie analogique |
| **Registre** | `R` | Variable numérique calculée par le D.L.S |
| **Compteur impulsion** | `CI` | Compteur d'impulsions physiques |
| **Compteur horaire** | `CH` | Compteur de temps de fonctionnement |
| **Horloge** | `HORLOGE` | Plage horaire programmée |
| **Message** | `MSG` | Message textuel déclenché par le D.L.S |
| **Visuel** | `VISUEL` | Lien entre un motif graphique et le D.L.S |
| **Lien** | `LINK` | Référence croisée entre deux modules D.L.S |

---

## 3. Consulter et filtrer les mnémoniques

La page [/mnemos](https://console.abls-habitat.fr/mnemos) s'organise en **onglets par type** de mnémonique.

Pour chaque mnémonique sont affichés :

| Colonne | Description |
|---|---|
| **Tech_ID** | Module D.L.S auquel appartient ce mnémonique |
| **Acronyme** | Nom du mnémonique dans son module |
| **Valeur** | Valeur actuelle (mise à jour en temps réel) |
| **Libellé** | Description humaine du mnémonique |

Utilisez la **barre de recherche** pour filtrer par Tech_ID ou acronyme.

---

## 4. Activer l'archivage d'un mnémonique

L'archivage permet de conserver l'historique d'une valeur (entrée analogique, registre, compteur) pour l'afficher sous forme de courbe.

Pour activer l'archivage d'un mnémonique :

1. Accédez à l'onglet du type correspondant (ex : **Entrées Ana**)
2. Repérez la colonne **Archivage**
3. Cliquez sur la liste déroulante du mnémonique concerné
4. Choisissez la résolution d'archivage souhaitée :

| Option | Description |
|---|---|
| **Aucun** | Pas d'archivage |
| **Faible** | Archivage basse résolution (économie de stockage) |
| **Moyen** | Résolution intermédiaire |
| **Élevé** | Haute résolution (plus gourmand en stockage) |

!!! tip "Archivage et courbes"
    Une fois l'archivage activé, les données apparaissent dans les courbes du tableau de bord et dans les [Archives](console_archives.md).
    La résolution d'archivage impacte la taille de la base de données.

---

## 5. Configurer le niveau d'accès d'une horloge

Les **horloges** (plages horaires programmées) ont un niveau d'accès qui détermine quels utilisateurs peuvent les modifier depuis l'interface.

Depuis l'onglet **Horloges** :

1. Repérez l'horloge à configurer
2. Modifiez le champ **Niveau d'accès** (de 0 à 9)
3. La modification est prise en compte immédiatement

---

## 6. Diagnostiquer avec les mnémoniques

La page des mnémoniques est un outil de diagnostic puissant :

### Vérifier qu'une entrée physique remonte

1. Allez dans l'onglet **Entrées TOR** (ou **Entrées Ana**)
2. Recherchez le mnémonique correspondant à votre capteur
3. Actionnez physiquement le capteur
4. Vérifiez que la valeur change dans le tableau (rafraîchissement automatique)

Si la valeur ne change pas :
- Vérifiez le mapping dans la page du connecteur
- Vérifiez que le thread est actif et connecté ([/threads](https://console.abls-habitat.fr/threads))

### Vérifier qu'une sortie est commandée

1. Allez dans l'onglet **Sorties TOR**
2. Recherchez le mnémonique correspondant à votre actionneur
3. Déclenchez la logique D.L.S (via un bouton de synoptique ou en forçant un bistable)
4. Vérifiez que la valeur passe à `1`

### Suivre une variable D.L.S

1. Allez dans l'onglet **Bistables** ou **Registres**
2. Recherchez par Tech_ID le module concerné
3. Observez les valeurs pendant l'exécution

!!! tip "Utilisez la vue RUN pour un suivi plus complet"
    La page [/dls/run](https://console.abls-habitat.fr/dls/run) offre une vue plus détaillée et interactive de tous les mnémoniques d'un seul module.
    Utilisez-la pour suivre en détail la logique d'un module spécifique.

---

## 7. Comprendre les liens (LINK)

Les **liens** permettent à un module D.L.S de lire un mnémonique appartenant à un autre module.
Ils apparaissent dans l'onglet **Liens** de la page des mnémoniques.

Exemple : le module `ECLAIRAGE_SALON` peut lire le bistable `CMD_CHAUFFE` du module `CHAUFFAGE_RDC` via un lien.

Les liens sont déclarés dans le code D.L.S avec la syntaxe `<TechID_source>:<Acronyme>`.

---

## 8. Bonnes pratiques

- **Donnez des libellés clairs** à vos mnémoniques dans le code D.L.S : ils apparaissent ici et dans les synoptiques
- **Activez l'archivage** uniquement sur les points pertinents pour éviter une base de données trop volumineuse
- **Utilisez régulièrement cette page** lors de la mise en service pour valider les remontées d'informations
- **Mémorisez les Tech_ID** de vos modules : ils sont la clé de tous les liens dans le système

---

## Aide-mémoire des conventions de nommage recommandées

| Type | Convention | Exemple |
|---|---|---|
| Module D.L.S | `<FONCTION>_<ZONE>` | `CHAUFFAGE_RDC` |
| Bistable | `CMD_<ACTION>` ou `ETAT_<ELEMENT>` | `CMD_CHAUFFE`, `ETAT_PORTE` |
| Entrée TOR | `BP_<ELEMENT>` ou `DET_<ELEMENT>` | `BP_MARCHE`, `DET_MOUVEMENT` |
| Sortie TOR | `SORTIE_<ELEMENT>` | `SORTIE_CHAUFFE`, `SORTIE_LUMIERE` |
| Entrée Ana | `TEMP_<ZONE>` ou `PUIS_<ELEMENT>` | `TEMP_SALON`, `PUIS_POMPE` |
| Registre | `REG_<GRANDEUR>` | `REG_CONSIGNE_TEMP` |
| Tempo | `TEMPO_<ACTION>` | `TEMPO_ARRET`, `TEMPO_ECLAIRAGE` |
| Message | `MSG_<EVENEMENT>` | `MSG_ALARME_TEMP` |
