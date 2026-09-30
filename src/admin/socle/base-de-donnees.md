# Base de données

L'API s'appuie sur **MariaDB**. Deux rôles distincts, éventuellement portés par le même serveur :

| Rôle | Clés de configuration | Contenu |
|---|---|---|
| Base principale | `db_hostname`, `db_port`, `db_password` | Domaines, agents, modules D.L.S, synoptiques, utilisateurs |
| Base d'archives | `db_arch_hostname`, `db_arch_port` | Historique des valeurs et des messages |

!!! info
    Si `db_arch_hostname` et `db_arch_port` sont identiques à `db_hostname` et `db_port`,
    l'API n'ouvre qu'une seule connexion pour les deux rôles.

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install mariadb-server
    sudo systemctl enable --now mariadb
    sudo mariadb-secure-installation
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install mariadb-server
    sudo systemctl enable --now mariadb
    sudo mariadb-secure-installation
    ```

---

## Création du schéma

L'API crée et fait évoluer elle-même ses tables au démarrage : il n'y a pas de script de schéma
à jouer manuellement. Elle a en revanche besoin d'un compte disposant des droits de création.

```sql
CREATE USER 'abls'@'%' IDENTIFIED BY 'un-mot-de-passe-solide';
GRANT ALL PRIVILEGES ON *.* TO 'abls'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

!!! warning "Droits étendus"
    L'API crée une base par domaine. Elle a donc besoin de droits globaux, et non de droits
    restreints à une base nommée. Isolez l'instance MariaDB si cela pose problème.

Renseignez ensuite `/etc/abls-habitat-api.conf` :

```json
{
  "db_hostname": "127.0.0.1",
  "db_port":     3306,
  "db_password": "un-mot-de-passe-solide"
}
```

---

## Séparer les archives

Les archives grossissent vite : une valeur analogique archivée à la minute représente environ
525 000 lignes par an et par mnémonique. Les isoler sur un serveur ou un volume dédié simplifie
la sauvegarde et le dimensionnement.

```json
{
  "db_hostname":      "127.0.0.1",
  "db_arch_hostname": "archives.interne.lan",
  "db_arch_port":     3306
}
```

La rétention se règle côté domaine, depuis la Console :
voir [paramétrer les archives](../../technicien/parcours/09-archives.md).

---

## Réglages MariaDB utiles

```ini
# /etc/mysql/mariadb.conf.d/60-abls.cnf
[mysqld]
max_connections      = 200
innodb_buffer_pool_size = 1G
innodb_file_per_table   = ON
```

- `max_connections` : l'API ouvre plusieurs connexions par domaine actif.
- `innodb_file_per_table` : indispensable pour pouvoir récupérer de l'espace après purge des
  archives.

---

## Sauvegarde

Voir [Sauvegarde et restauration](../exploitation/sauvegarde.md) pour la procédure complète.
En résumé :

```bash
sudo mariadb-dump --all-databases --single-transaction --routines --events \
  | gzip > /var/backups/abls-$(date +%F).sql.gz
```

!!! danger "Une sauvegarde non testée n'est pas une sauvegarde"
    Restaurez périodiquement sur une instance de test. Une base d'archives volumineuse peut
    rendre la restauration bien plus longue que prévu.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| L'API ne démarre pas, erreur de connexion SQL | Vérifier `db_hostname`, le `bind-address` de MariaDB, le pare-feu |
| `Access denied for user 'abls'` | Le `GRANT` n'a pas été appliqué, ou l'hôte source ne correspond pas |
| Lenteurs à l'affichage des courbes | Base d'archives sous-dimensionnée ; augmenter `innodb_buffer_pool_size` ou réduire la rétention |
| Disque plein | Purger les archives depuis la Console, puis `OPTIMIZE TABLE` |
