# Commander par SMS

Vous pouvez piloter certains équipements et interroger votre habitat en envoyant un **simple
message texte**, sans ouvrir l'interface.

C'est particulièrement utile quand vous n'avez pas de connexion Internet.

---

## Comment ça marche

Vous envoyez un SMS au numéro de votre habitat, contenant une commande prédéfinie.
L'installation l'exécute et, selon les cas, vous répond.

```text
Vous  →  POMPE_PAC ON
Vous  ←  Pompe PAC activée
```

---

## Connaître les commandes disponibles

Il n'y a pas de liste universelle : les commandes sont créées sur mesure par votre technicien.

**Demandez-lui la liste** de celles qui sont actives sur votre habitat, et gardez-la à portée
de main.

Quelques exemples typiques :

| Commande | Effet |
|---|---|
| `TEMP` | Renvoie les températures de l'habitat |
| `POMPE_PAC ON` | Démarre la pompe à chaleur |
| `POMPE_PAC OFF` | Arrête la pompe à chaleur |

---

## Les règles à respecter

!!! warning "Écrivez la commande exactement"
    Le texte doit correspondre à ce qui a été programmé, espaces et majuscules compris.
    Une commande mal orthographiée est simplement ignorée — vous ne recevrez aucun message
    d'erreur.

!!! tip "Désactivez le correcteur automatique"
    Sur téléphone, le correcteur transforme volontiers `POMPE_PAC` en autre chose.
    Vérifiez le texte avant d'envoyer.

---

## Sécurité

!!! note "Seuls les utilisateurs connus sont écoutés"
    L'installation vérifie que le numéro émetteur correspond à un utilisateur du domaine,
    et que son niveau d'accès autorise la commande demandée.

    Un SMS venant d'un numéro inconnu n'a aucun effet.

!!! danger "Protégez votre téléphone"
    Si votre téléphone est perdu ou volé, la personne qui le détient peut envoyer des commandes
    en votre nom. Signalez-le immédiatement au responsable de l'habitat pour qu'il retire votre
    numéro.

---

## Si la commande reste sans effet

Vérifiez dans l'ordre :

1. **L'orthographe exacte** de la commande.
2. Que votre **numéro est bien enregistré** dans votre profil.
3. Que votre **niveau d'accès** autorise cette action.
4. Que la commande **existe encore** — elle a pu être renommée ou supprimée.

Consultez le [fil de l'eau](messages.md) : si la commande a été reçue, elle y a généralement
laissé une trace.

---

## Voir aussi

- [Être notifié](notifications.md)
- [Mon profil](profil.md)
