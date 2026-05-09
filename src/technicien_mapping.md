# Étape 4 — Configurer le mapping I/O ↔ D.L.S

Le **mapping** est l'opération qui relie les entrées/sorties physiques d'un connecteur (thread) aux **mnémoniques D.L.S** du domaine.
Sans mapping, le moteur D.L.S ne sait pas à quel mnémonique correspond quelle borne physique de votre automate ou équipement.

!!! info "Position dans le workflow"
    Le mapping est réalisé **après** la création des threads et la compilation des modules D.L.S.
    Les mnémoniques doivent exister avant de pouvoir les relier à des E/S physiques.
    → Étape précédente : [Créer les modules D.L.S](technicien_dls.md)
    → Étape suivante : [Créer les synoptiques](technicien_synoptiques.md)

---

## Principe du mapping

Chaque **connecteur** expose des points d'entrée/sortie physiques (bornes d'un Wago, broches GPIO, canaux audio…).
Chacun de ces points doit être associé à un **mnémonique D.L.S** pour être exploitable dans la logique d'automatisation.

```
Borne physique (ex: DI 0)  ←→  Mnémonique D.L.S (ex: CHAUFFAGE_RDC:BP_MARCHE)
```

Le mapping est bidirectionnel :
- **Entrée physique → D.L.S** : la valeur lue sur la borne alimente le mnémonique
- **D.L.S → Sortie physique** : la valeur calculée du mnémonique commande la borne

---

## 1. Accéder au mapping Modbus (exemple Wago)

Depuis [/modbus](https://console.abls-habitat.fr/modbus), retrouvez votre thread Wago et cliquez sur l'icône de **mapping** (ou accédez directement via le lien du thread).

La page de mapping Modbus présente quatre onglets :

| Onglet | Description |
|---|---|
| **DI (Digital Inputs)** | Entrées TOR (tout-ou-rien) de l'automate |
| **DO (Digital Outputs)** | Sorties TOR de l'automate |
| **AI (Analog Inputs)** | Entrées analogiques (0-10V, 4-20mA, Pt100…) |
| **AO (Analog Outputs)** | Sorties analogiques |

---

## 2. Mapper une entrée TOR (DI)

### Étape 2.1 — Identifier la borne

Repérez dans votre documentation d'installation le numéro de borne de l'automate Wago correspondant au capteur ou bouton à lire.

### Étape 2.2 — Ajouter le mapping

Dans l'onglet **DI**, cliquez sur **Ajouter un mapping DI**.

Renseignez :

| Champ | Description | Exemple |
|---|---|---|
| **Numéro de borne** | Indice de la borne dans l'automate (commence à 0) | `0` |
| **Tech_ID D.L.S** | Identifiant du module D.L.S cible | `CHAUFFAGE_RDC` |
| **Acronyme** | Nom du mnémonique dans ce module | `BP_MARCHE` |

Cliquez sur **Valider**.

!!! tip "Vérifiez que le mnémonique existe"
    Le mnémonique (`CHAUFFAGE_RDC:BP_MARCHE`) doit être déclaré dans le code D.L.S et le module doit avoir été compilé.
    S'il n'apparaît pas dans la liste déroulante, vérifiez la compilation du module D.L.S.

### Étape 2.3 — Vérifier la mise à jour

Accédez à la vue RUN du module D.L.S ([/dls/run](https://console.abls-habitat.fr/dls/run)) et actionnez physiquement le bouton ou capteur.
La valeur du mnémonique doit basculer en temps réel.

---

## 3. Mapper une sortie TOR (DO)

Dans l'onglet **DO**, cliquez sur **Ajouter un mapping DO**.

| Champ | Description | Exemple |
|---|---|---|
| **Numéro de borne** | Indice de la sortie dans l'automate | `0` |
| **Tech_ID D.L.S** | Identifiant du module D.L.S source | `CHAUFFAGE_RDC` |
| **Acronyme** | Nom du mnémonique de sortie dans ce module | `SORTIE_CHAUFFE` |

!!! warning "Sens du mapping pour les sorties"
    Pour une sortie, c'est le **D.L.S qui pilote la borne physique**.
    Assurez-vous que le mnémonique est bien une `Sortie_TOR` déclarée dans le module.

---

## 4. Mapper une entrée analogique (AI)

Dans l'onglet **AI**, cliquez sur **Ajouter un mapping AI**.

| Champ | Description | Exemple |
|---|---|---|
| **Numéro de borne** | Indice de la borne analogique | `0` |
| **Type de borne** | Type physique (0-10V, 4-20mA, Pt-100) | `750461 - Pt-100` |
| **Tech_ID D.L.S** | Module D.L.S cible | `TEMP_RDC` |
| **Acronyme** | Mnémonique de type `Entrée_Ana` | `TEMP_SALON` |

!!! tip "Facteur de conversion"
    Pour les entrées analogiques, vérifiez la plage de mesure et le facteur de conversion dans la documentation du capteur.
    Le D.L.S reçoit la valeur brute convertie selon le type de borne sélectionné.

---

## 5. Mapper une sortie analogique (AO)

Dans l'onglet **AO**, cliquez sur **Ajouter un mapping AO**.

Le principe est identique aux sorties TOR, mais pour des valeurs numériques (pourcentage d'ouverture de vanne, vitesse de moteur, etc.).

---

## 6. Mapping pour d'autres connecteurs

Le principe est identique pour tous les connecteurs :

### GPIO Raspberry Pi → [/gpiod](https://console.abls-habitat.fr/gpiod)

| Champ | Description |
|---|---|
| **Broche GPIO** | Numéro de broche BCM (ex : GPIO17 → 17) |
| **Sens** | Entrée ou Sortie |
| **Tech_ID + Acronyme** | Mnémonique D.L.S cible |

### Phidget → [/phidget](https://console.abls-habitat.fr/phidget)

Les cartes Phidget s'associent via leur numéro de port et leur canal.

### SHELLY → [/shelly](https://console.abls-habitat.fr/shelly)

Les modules SHELLY s'associent via leur adresse IP et leur canal (relais, mesure de puissance, etc.).

---

## 7. Vérifier l'ensemble des mappings

La page [/mnemos](https://console.abls-habitat.fr/mnemos) liste tous les mnémoniques du domaine.
Filtrez par type (Entrée_TOR, Sortie_TOR, Entrée_Ana…) et vérifiez que les mnémoniques attendus sont bien présents et ont une valeur cohérente.

!!! tip "Astuce diagnostic"
    Si un mnémonique reste à `0` alors qu'il devrait changer :
    1. Vérifiez le mapping (numéro de borne, Tech_ID, acronyme)
    2. Vérifiez que le thread est bien `Actif` et `Connecté` dans [/threads](https://console.abls-habitat.fr/threads)
    3. Activez le mode debug du thread pour voir les échanges détaillés

---

## Résumé des actions

```
1. Accéder à la page du connecteur (ex : /modbus)
2. Ouvrir le mapping du thread concerné
3. Pour chaque E/S physique :
   a. Identifier le numéro de borne
   b. Sélectionner le Tech_ID et l'acronyme D.L.S
   c. Valider
4. Vérifier en vue RUN que les valeurs remontent correctement
5. → Passer à l'étape suivante : créer les synoptiques
```

**Page suivante : [Créer les synoptiques](technicien_synoptiques.md)**
