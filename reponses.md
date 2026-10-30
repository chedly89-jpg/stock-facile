# Réponses du TP StockFacile

## Partie 00

**Q0.5.** Pourquoi ne faut-il pas envoyer les fichiers `.db` sur GitHub alors qu'on envoie `schema.sql` ?

Un fichier `.db` est un fichier binaire qui change à chaque utilisation de l'application : Git ne peut pas comparer deux versions ni fusionner leurs différences, et chaque commit alourdirait inutilement le dépôt. Il contient aussi des données de test, voire des données personnelles ou réelles, qui n'ont rien à faire sur un dépôt public. Le fichier `schema.sql`, lui, est un simple texte : il est léger, lisible, comparable d'un commit à l'autre, et il suffit à recréer une base vide identique.

## Partie 01

**Q1.3.**

- **Stockage de `disponible` et `date_ajout` :** SQLite n'a ni type `BOOLEAN` ni type `DATETIME`. `disponible` est stocké comme un entier (`INTEGER`) : 1 pour vrai, 0 pour faux. `date_ajout` est stockée comme du texte (`TEXT`) au format ISO 8601, par exemple `2026-10-01T09:00:00`.
- **`AUTOINCREMENT` :** SQLite génère automatiquement l'`id` de chaque nouvelle ligne (1, 2, 3...) et ne réutilise jamais un identifiant déjà donné.
- **`UNIQUE` sur `nom` :** deux catégories ne peuvent pas avoir le même nom ; un doublon est refusé.
- **`CHECK (prix >= 0)` :** la base refuse toute ligne dont le prix est négatif.
- **`ON DELETE RESTRICT` :** on ne peut pas supprimer une catégorie tant qu'au moins un produit lui est rattaché ; la suppression provoque une erreur.

**Q1.4.** Pourquoi écrit-on `'Huile d''olive'` avec deux apostrophes ?

En SQL, l'apostrophe sert à délimiter une chaîne de caractères. Une apostrophe seule dans `'Huile d'olive'` terminerait la chaîne trop tôt et provoquerait une erreur de syntaxe. En doublant l'apostrophe (`''`), on indique à SQLite que c'est un caractère du texte et non la fin de la chaîne.

**Q1.6.** Messages d'erreur obtenus :

- **a) prix négatif :**
  `CHECK constraint failed: prix >= 0`
  La contrainte `CHECK (prix >= 0)` empêche d'insérer un prix négatif.

- **b) catégorie inexistante :**
  `FOREIGN KEY constraint failed`
  La catégorie 99 n'existe pas dans la table `categories`, la clé étrangère `categorie_id` est donc invalide.

- **c) suppression d'une catégorie qui contient des produits :**
  `FOREIGN KEY constraint failed`
  `ON DELETE RESTRICT` interdit de supprimer une catégorie encore utilisée par des produits.

**Q1.7.** Que contient le fichier `schema.sql` ?

Il contient les instructions SQL qui décrivent la structure de la base : les `CREATE TABLE` des tables `categories` et `produits`, avec leurs colonnes, leurs types, leurs clés primaires, leurs contraintes (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`) et la clé étrangère. Il ne contient pas les données (grâce à l'option « Exporter uniquement le schéma »). Avec ce fichier, on peut recréer une base vide identique.

**Q1.8.** Pourquoi faut-il fermer la base avant qu'un autre programme écrive dans le même fichier ?

Un fichier SQLite ne doit pas être modifié par deux programmes en même temps. Si DB Browser garde la base ouverte avec des modifications non enregistrées, il peut verrouiller le fichier : l'application reçoit alors une erreur du type « database is locked ». De plus, chaque programme peut voir un état différent de la base, ce qui risque de produire des données incohérentes ou de perdre des modifications. Fermer la base (ou enregistrer puis fermer) garantit que le fichier est dans un état stable.