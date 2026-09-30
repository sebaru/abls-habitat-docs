# Docs
Technical Documentation for my personal Abls-Habitat Project

This repository is a mkdocs repo for all the components of my Home Automation Project Abls-Habitat:
* [Abls-Habitat-Agent](https://github.com/sebaru/Watchdog.git): Master and slave Agents deployed
* [Abls-Habitat-API](https://github.com/sebaru/abls-habitat-api.git): Cloud or OnPrem API
* [Abls-Habitat-Console](https://github.com/sebaru/abls-habitat-console.git): Docs for privileges users
* [Abls-Habitat-Home](https://github.com/sebaru/abls-habitat-home.git): Docs for end users

## Organisation de la documentation

La documentation est découpée en **trois volets**, un par rôle, matérialisés par les onglets du
site :

| Onglet | Dossier | Public |
|---|---|---|
| Découverte | `src/*.md` | Tout le monde |
| Administrateur | `src/admin/` | Installe et maintient les agents et le socle |
| Technicien | `src/technicien/` | Écrit le D.L.S, mappe les I/O, fait les synoptiques |
| Utilisateur | `src/utilisateur/` | Utilise l'interface Home au quotidien |

Les anciennes URLs à plat (`/dls_logique/`, `/config_agent/`…) ne sont plus servies : chaque page
vit désormais sous le dossier de son rôle.

## Construire le site

```sh
./install.sh                              # dépendances python
python3 -m mkdocs build --strict          # construction, échoue au moindre lien mort
python3 -m mkdocs serve                   # prévisualisation sur http://127.0.0.1:8000
```

> Utilisez `python3 -m mkdocs` plutôt que la commande `mkdocs` : sur certaines distributions,
> le lanceur système ignore les paquets installés par `pip --user`.

## Régénérer la bibliothèque de visuels

```sh
./update.sh
```

Le script lit `https://static.abls-habitat.fr/inventory.json` et regénère
`src/technicien/visuels/index.md` ainsi que `src/technicien/visuels/categories/*.md`.
**Ces fichiers ne doivent pas être édités à la main.**

Again, this docs are made on my sparetime.
Regards,
Sebaru
