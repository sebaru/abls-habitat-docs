# Agent SERVER

Le **superviseur local** du site. C'est l'agent central : il n'y en a qu'un par serveur, et le
serveur qui le porte devient le point de rendez-vous des autres agents.

---

## Rôle

- Héberge le **broker MQTT local** auquel se raccordent les autres agents du site.
- **Embarque le moteur D.L.S** : sur le serveur désigné *master*, c'est lui qui exécute les
  modules d'automatisation. Il n'est donc pas nécessaire d'installer `abls-agent-dls` séparément.
- Pilote le **cycle de vie des autres agents** : les ordres `START`, `STOP`, `RESTART` et
  `UPGRADE` envoyés depuis la Console sont relayés par lui vers `systemd`.

!!! tip "C'est le premier paquet à installer"
    Sans lui, les autres agents n'ont pas de bus local et le domaine n'exécute aucune logique.

---

## Pré-requis

| Élément | Exigence |
|---|---|
| Matériel | 2 cœurs, 1 Go de RAM, 4 Go de disque |
| Réseau | Port 1883 joignable depuis les autres machines du site |
| Système | Debian Bookworm/Trixie, Raspberry Pi OS, Fedora 38+ |

---

## Installation

=== "Debian / Raspberry Pi OS"

    ```bash
    sudo apt install abls-agent-server
    ```

=== "Fedora / RHEL"

    ```bash
    sudo dnf install abls-agent-server
    ```

---

## Unité systemd

`abls-agent-server.service` — unité **simple**, non templatée.

```ini
ExecStart=/usr/bin/abls-agent-server
User=abls-agent-server
Group=abls
Restart=always
RestartSec=10s
StateDirectory=abls-agent-server
```

!!! danger "Le `tech_id` ne peut pas venir de la ligne de commande"
    Contrairement aux unités templatées, `ExecStart` ne passe **pas** `--agent-tech-id`.
    Le `agent_tech_id` doit donc figurer dans `/etc/abls/abls-agent.conf` :

    ```json
    { "agent_tech_id": "SERVER_MAISON" }
    ```

    Faute de quoi le service quitte immédiatement avec
    `There is no 'agent_tech_id', in config, exiting.`

---

## Enrôlement

```bash
# 1. Poser le tech_id dans le fichier commun de la machine
sudo install -d -m 0750 -o root -g abls /etc/abls
echo '{ "agent_tech_id": "SERVER_MAISON" }' | sudo tee /etc/abls/abls-agent.conf
sudo chown root:abls /etc/abls/abls-agent.conf && sudo chmod 0640 /etc/abls/abls-agent.conf

# 2. Enregistrer les identifiants du domaine
sudo abls-agent-server --agent-tech-id SERVER_MAISON \
                       --domain-uuid   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
                       --domain-secret 'votre-secret-ici' \
                       --api-url       api.abls-habitat.fr \
                       --save

# 3. Démarrer
sudo systemctl enable --now abls-agent-server.service
```

---

## Paramètres spécifiques

Aucune option de ligne de commande supplémentaire : l'agent `server` n'utilise que les
[paramètres communs](../parametres-communs.md).

Il accepte en revanche, dans son fichier de configuration, une clé `local_agents` décrivant les
agents dont il doit piloter le cycle de vie. Cette liste est normalement alimentée par l'API :
n'y touchez pas à la main.

!!! note "`tps` sur le master"
    Le master porte le moteur D.L.S : `tps` (50 par défaut) y détermine la fréquence
    d'exécution de la logique. Ne l'abaissez que si la machine est manifestement saturée, et
    prévenez le technicien : certains automatismes temporisés en dépendent.

---

## Désigner le serveur master

Un seul serveur du domaine exécute la logique D.L.S. La désignation se fait depuis la Console,
page **Serveurs**. Les autres agents reçoivent automatiquement son adresse dans le champ
`master_hostname` de leur réponse d'enrôlement.

---

## Dépannage

| Symptôme | Piste |
|---|---|
| `There is no 'agent_tech_id'` | Voir l'encadré ci-dessus : le poser dans `abls-agent.conf` |
| Les autres agents ne se connectent pas au bus local | Port 1883 fermé, ou `master_hostname` incorrect côté API |
| Arrêt très long | Normal : l'agent sauvegarde l'état du moteur D.L.S vers l'API. Ne forcez pas |
| Tours par seconde effondrés | Machine saturée, `log_level` à 7, ou module D.L.S coûteux |
| Une commande depuis la Console ne démarre pas un agent | Vérifier que l'unité cible existe et que `abls-agent-server` a les droits `systemd` requis |

```bash
sudo journalctl -u abls-agent-server.service -f
```

---

## Voir aussi

- [Agent DLS](dls.md) — pourquoi il est rarement nécessaire
- [Broker MQTT](../../socle/mqtt.md)
- [Supervision](../../exploitation/supervision.md)
