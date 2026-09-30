# Console et Home

Les deux interfaces web sont des **applications monopage** statiques, servies par Apache et
adossées à l'API. Elles ne portent aucune logique métier.

| Interface | Public | Dépôt | Authentification |
|---|---|---|---|
| **Console** | Techniciens et administrateurs (niveau ≥ 6) | `abls-habitat-console` | `keycloak.js`, côté navigateur |
| **Home** | Utilisateurs finaux | `abls-habitat-home` | `mod_auth_openidc`, côté serveur |

!!! tip "Vous utilisez le Cloud du projet ?"
    Cette page ne vous concerne pas : `console.abls-habitat.fr` et `home.abls-habitat.fr`
    sont déjà en service.

---

## Modules Apache requis

| Interface | Modules |
|---|---|
| Console | `mod_ssl`, `mod_proxy`, `mod_proxy_http` |
| Home | `mod_ssl`, `mod_auth_openidc`, `mod_proxy`, `mod_proxy_http`, `mod_headers` |

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install apache2 libapache2-mod-auth-openidc
    sudo a2enmod ssl proxy proxy_http headers auth_openidc
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install httpd mod_ssl mod_auth_openidc
    ```

---

## Déploiement des fichiers

```bash
sudo git clone https://github.com/sebaru/abls-habitat-console.git /var/www/html/abls-console
sudo git clone https://github.com/sebaru/abls-habitat-home.git    /var/www/html/abls-home
```

Le `DocumentRoot` pointe sur le sous-répertoire `public/` de chaque dépôt.

---

## VirtualHosts

Chaque dépôt fournit un modèle complet et commenté :

- `CONSOLE/httpd-abls-console.conf.sample`
- `HOME/httpd-abls-home.conf.sample`

Copiez-le, remplacez les noms de domaine et les secrets, puis activez-le.

Points structurants communs :

```apache
# Redirection HTTP vers HTTPS
<VirtualHost *:80>
  ServerName my-abls-console.mydomain
  Redirect permanent / https://my-abls-console.mydomain/
</VirtualHost>

<VirtualHost *:443>
  ServerName my-abls-console.mydomain
  SSLEngine on
  SSLCertificateFile    /etc/letsencrypt/live/my-abls-console.mydomain/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/my-abls-console.mydomain/privkey.pem
  SSLProtocol           all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1

  DocumentRoot /var/www/html/abls-console/public
  <Directory "/var/www/html/abls-console/public">
    Options -Indexes
    AllowOverride None
    Require all granted
    # Routage monopage : toute URL inconnue est servie par index.html
    FallbackResource /index.html
  </Directory>
</VirtualHost>
```

!!! warning "`FallbackResource /index.html` est indispensable"
    Sans cette directive, un rechargement de page sur une URL profonde
    (`/dls/params/12`) renvoie un 404 au lieu de l'application.

---

## Configuration côté Console

La Console s'authentifie dans le navigateur avec `keycloak.js`.
Partez du modèle fourni :

```bash
sudo cp /var/www/html/abls-console/public/js/config.js.sample \
        /var/www/html/abls-console/public/js/config.js
```

Renseignez-y l'URL de votre API, l'URL de votre Keycloak et le realm.

---

## Configuration côté Home

Home place l'authentification **côté serveur** : les jetons ne transitent jamais par le
navigateur. `mod_auth_openidc` joue le rôle de *backend for frontend*.

```apache
OIDCProviderMetadataURL https://idp.mydomain/realms/abls-habitat/.well-known/openid-configuration
OIDCClientID            abls-habitat-home
OIDCClientSecret        <CLIENT_SECRET>
OIDCRedirectURI         https://my-abls-home.mydomain/auth/callback
OIDCCryptoPassphrase    <32_CARACTERES_ALEATOIRES>
```

!!! danger "Secrets dans le VirtualHost"
    `OIDCClientSecret` et `OIDCCryptoPassphrase` sont des secrets. Le fichier de configuration
    Apache qui les contient doit être en `0640 root:root`, et ne doit jamais être versionné.

    Générez la passphrase avec :

    ```bash
    openssl rand -base64 32
    ```

---

## Cohérence avec la configuration de l'API

Les URLs publiques doivent être déclarées à l'identique dans
`/etc/abls-habitat-api.conf` :

```json
{
  "home_url":      "https://my-abls-home.mydomain",
  "console_url":   "https://my-abls-console.mydomain",
  "api_url":       "https://my-abls-api.mydomain",
  "allow_origin":  "https://my-abls-home.mydomain"
}
```

!!! warning "`allow_origin`"
    La valeur par défaut `*` accepte toutes les origines. En production, restreignez-la aux
    domaines de vos interfaces.

---

## Certificats TLS

```bash
sudo certbot --apache -d my-abls-console.mydomain -d my-abls-home.mydomain
```

Vérifiez que le renouvellement automatique est actif :

```bash
systemctl list-timers 'certbot*'
```

---

## Mise à jour des interfaces

```bash
sudo git -C /var/www/html/abls-console pull
sudo git -C /var/www/html/abls-home    pull
```

Aucun redémarrage d'Apache n'est nécessaire : les fichiers sont statiques.
Demandez aux utilisateurs de forcer le rechargement de leur navigateur.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| Page blanche | Console du navigateur : `config.js` absent ou mal renseigné |
| 404 au rechargement d'une URL profonde | `FallbackResource /index.html` manquant |
| Boucle de redirection sur Home | `OIDCRedirectURI` ne correspond pas à l'URI déclarée dans Keycloak |
| Erreurs CORS dans la console du navigateur | `allow_origin` de l'API trop restrictif ou mal orthographié |
| Les valeurs ne s'actualisent pas en temps réel | Le listener WebSocket du [broker MQTT](mqtt.md) n'est pas exposé |
