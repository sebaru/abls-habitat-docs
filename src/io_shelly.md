# Les Shelly

Ces entrées/sorties s'appuient sur du matériel de la marque Shelly et permettent de mesurer les voltages, intensités, et énergies liés
à un circuit monophasé ou triphasé.

---
## Matériel

Ce connecteur permet de piloter et controler les éléments suivants:

* Une interface monophasée 2 canaux
    * [SHELLY PRO 3 EM Triphasé](https://www.shellyfrance.fr/shelly-pro-3em/2)
* Une interface triphasée 1 canal
    * [SHELLY PRO EM 50 Monophasé](https://www.shellyfrance.fr/shelly-pro-em-50/)

---
## Cablage et installation

Il suffit de brancher les alimentations, les pinces ampèremetriques, et le reseau (wifi ou rj45).

Une fois la connectique assemblée, il suffit de lancer le script suivant pour le raccrocher au serveur principal:

    [watchdog@Server ~]$ ./SRC/scripts/shellypro_set_mqtt.sh @IP_du_shelly @IP_du_master

---
## Mapping D.L.S

Les bits internes suivants sont positionnés par le module Shelly:

Pour le canal 1 du monophasé:

| Acronyme	| Unité | Description
|:------------|:--------:|:----------------
| EM10_ACT_POWER   | W  | Puissance active
| EM10_APRT_POWER  | VA | Puissance apparente
| EM10_CURRENT     | A  | Courant
| EM10_FREQ        | HZ | Fréquence
| EM10_PF          | cos phi | Facteur de charge
| EM10_VOLTAGE     | V  | Voltage
| EM10_ENERGY      | Wh | Energie consommée
| EM10_INJECTION   | Wh | Energie injectée


Pour le canal 2 du monophasé:

| Acronyme	| Unité | Description
|:------------|:--------:|:----------------
| EM11_ACT_POWER   | W  | Puissance active
| EM11_APRT_POWER  | VA | Puissance apparente
| EM11_CURRENT     | A  | Courant
| EM11_FREQ        | HZ | Fréquence
| EM11_PF          | cos phi | Facteur de charge
| EM11_VOLTAGE     | V  | Voltage
| EM11_ENERGY      | Wh | Energie consommée
| EM11_INJECTION   | Wh | Energie injectée

Pour le module triphasé:

| Acronyme	| Unité | Description
|:------------|:--------:|:----------------
| U1          | V | Voltage Phase 1
| U2          | V | Voltage Phase 2
| U3          | V | Voltage Phase 3
| I1          | A | Courant Phase 1
| I2          | A | Courant Phase 2
| I3          | A | Courant Phase 3
| I_TOTAL     | A | Courant Total
| ACT_TOTAL   | W | Puissance Active Totale
| ACT_POWER1  | W | Puissance Active Phase 1
| ACT_POWER2  | W | Puissance Active Phase 2
| ACT_POWER3  | W | Puissance Active Phase 3
| APRT_TOTAL  | VA  | Puissance Apparente Totale
| APRT_POWER1 | VA | Puissance Apparente Phase 1
| APRT_POWER2 | VA | Puissance Apparente Phase 2
| APRT_POWER3 | VA | Puissance Apparente Phase 3
| FREQ1       | HZ | Fréquence Phase 1
| FREQ2       | HZ | Fréquence Phase 2
| FREQ3       | HZ | Fréquence Phase 3
| PF1         | cos phi | Facteur de charg Phase 1
| PF2         | cos phi | Facteur de charg Phase 2
| PF3         | cos phi | Facteur de charg Phase 3
| ENERGY1     | Wh | Energie consommée Phase 1
| ENERGY2     | Wh | Energie consommée Phase 2
| ENERGY3     | Wh | Energie consommée Phase 3
| INJECTION1  | Wh | Energie injectée Phase 1
| INJECTION2  | Wh | Energie injectée Phase 2
| INJECTION3  | Wh | Energie injectée Phase 3

