# L'API Météo

![](https://static.abls-habitat.fr//img/meteo.svg)

Ces données sont issues de l'API Météo Concept.

---
## Configuration

Ce connecteur se configure à l'aide de des données suivantes::

* Le token d'accès à l'API Météo Concept
    * [Site de l'API](https://api.meteo-concept.com/login)
* Le code INSEE de la commune pour laquelle récupérer les données météo
    * [COG - Code INSEE](https://fr.wikipedia.org/wiki/Code_officiel_g%C3%A9ographique)

---
## Mapping D.L.S

Les bits internes suivants sont positionnés par ce connecteur Météo. `%d` va de 0 (aujourd'hui) à 13 (J+13).
| Acronyme | Unité | Description
| DAY`%d`_WEATHER              | code | Météo prévisionnelle
| DAY`%d`_TEMP_MIN             | °C   | Température minimum
| DAY`%d`_TEMP_MAX             | °C   | Température maximum
| DAY`%d`_PROBA_PLUIE          | %    | Probabilité de pluie (0-100%)
| DAY`%d`_PROBA_GEL            | %    | Probabilité de gel (0-100%)
| DAY`%d`_PROBA_BROUILLARD     | %    | Probabilité de brouillard (0-100%)
| DAY`%d`_PROBA_VENT_70        | %    | Probabilité de vent > 70km/h  (0-100%)
| DAY`%d`_PROBA_VENT_100       | %    | Probabilité de vent > 100km/h (0-100%)
| DAY`%d`_RAFALE_VENT_SI_ORAGE | km/h | Vitesse des rafales de vent si orage
| DAY`%d`_VENT_A_10M           | km/h |Vent moyen à 10 mètres
| DAY`%d`_DIRECTION_VENT       | °    | Direction du vent
| DAY`%d`_RAFALE_VENT          | km/h | Vitesse des rafales de vent


