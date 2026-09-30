# Déclarer les dépôts de paquets

Les agents Abls-Habitat sont distribués sous forme de paquets natifs, depuis un dépôt unique
signé : <https://pkgs.abls-habitat.fr>.

Cette opération n'est à faire **qu'une fois par machine**.

---

## Architectures et distributions publiées

| Distribution | Suite / version | Architectures |
|---|---|---|
| Debian | `bookworm`, `trixie` | `amd64`, `arm64`, `armhf` |
| Raspberry Pi OS 64 bits | `bookworm`, `trixie` | `arm64` |
| Raspberry Pi OS 32 bits | `bookworm`, `trixie` | `armhf` |
| Fedora / RHEL | courante | `x86_64`, `aarch64`, `noarch` |

!!! warning "Raspberry Pi 32 ou 64 bits ?"
    Vérifiez avant d'installer :

    ```bash
    dpkg --print-architecture   # arm64 ou armhf
    ```

    Un système Raspberry Pi OS 64 bits mal identifié conduit à un `Unable to locate package`
    difficile à diagnostiquer.

---

## Déclaration du dépôt

=== "Debian / Raspberry Pi OS (APT)"

    **1. Installer la clé de signature du dépôt**

    ```bash
    sudo install -d -m 0755 /etc/apt/keyrings
    sudo wget -O /etc/apt/keyrings/abls-archive-keyring.gpg \
         https://pkgs.abls-habitat.fr/abls-archive-keyring.gpg
    sudo chmod 0644 /etc/apt/keyrings/abls-archive-keyring.gpg
    ```

    **2. Déclarer la source correspondant à votre version**

    ```bash
    source /etc/os-release
    sudo wget -O /etc/apt/sources.list.d/abls-pkgs-${VERSION_CODENAME}.sources \
         https://pkgs.abls-habitat.fr/abls-pkgs-${VERSION_CODENAME}.sources
    ```

    `VERSION_CODENAME` est fourni par `/etc/os-release`. Raspberry Pi OS 13 vaut `trixie`
    et télécharge donc `abls-pkgs-trixie.sources`.

    Le fichier obtenu est au format *deb822* :

    ```text
    Types: deb
    URIs: https://pkgs.abls-habitat.fr/deb
    Suites: trixie
    Components: main
    Architectures: amd64 arm64 armhf
    Signed-By: /etc/apt/keyrings/abls-archive-keyring.gpg
    ```

    **3. Rafraîchir le cache**

    ```bash
    sudo apt update
    ```

=== "Fedora / RHEL (DNF)"

    **1. Déclarer le dépôt et importer la clé**

    ```bash
    sudo wget -O /etc/yum.repos.d/abls-rpms.repo https://pkgs.abls-habitat.fr/abls-rpms.repo
    sudo rpm --import https://pkgs.abls-habitat.fr/rpms/keys/RPM-GPG-KEY-ABLS
    ```

    Le fichier obtenu :

    ```ini
    [abls-rpms]
    name=ABLS RPM Repository
    baseurl=https://pkgs.abls-habitat.fr/rpms/$basearch
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://pkgs.abls-habitat.fr/rpms/keys/RPM-GPG-KEY-ABLS
    ```

    **2. Rafraîchir le cache**

    ```bash
    sudo dnf makecache
    ```

---

## Vérifier que le dépôt répond

=== "Debian / Raspberry Pi OS"

    ```bash
    apt-cache policy abls-agent-server
    ```

    Vous devez voir une ligne pointant vers `https://pkgs.abls-habitat.fr/deb`.

=== "Fedora / RHEL"

    ```bash
    dnf info abls-agent-server
    ```

    Le champ `Dépôt` doit indiquer `abls-rpms`.

---

## Contrôler l'empreinte de la clé

La clé publique est également publiée au format ASCII, accompagnée de son empreinte SHA-256 :

```bash
wget -qO- https://pkgs.abls-habitat.fr/abls-archive-keyring.asc | gpg --show-keys
wget -qO- https://pkgs.abls-habitat.fr/rpms/keys/RPM-GPG-KEY-ABLS.sha256
```

!!! tip "Le même dépôt sert APT et DNF"
    Les métadonnées sont séparées (`/deb` et `/rpms`) mais la **clé GPG de signature est
    partagée**. Une machine mixte n'a donc qu'une seule empreinte à contrôler.

---

## Dépannage

| Symptôme | Cause probable | Remède |
|---|---|---|
| `NO_PUBKEY` / `signatures were invalid` | Clé absente ou périmée | Rejouer l'étape 1 |
| `Unable to locate package abls-agent-*` | Mauvaise suite ou architecture | Vérifier `VERSION_CODENAME` et `dpkg --print-architecture` |
| `404 Not Found` sur `.sources` | Version de Debian non publiée | Seules `bookworm` et `trixie` sont publiées |
| `repo_gpgcheck` échoue en DNF | Clé RPM non importée | `sudo rpm --import https://pkgs.abls-habitat.fr/rpms/keys/RPM-GPG-KEY-ABLS` |

---

Le dépôt est déclaré : passez à [l'installation des agents](installation.md).
