import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';
import 'produits_screen.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  // Tester la connexion à la base de données
  Future<void> testerBase() async {
    try {
      final db = await DatabaseHelper().database;

      final resultat = await db.rawQuery(
        'SELECT COUNT(*) AS nb FROM categories',
      );

      debugPrint('Nombre de catégories : ${resultat.first['nb']}');
    } catch (e) {
      debugPrint('Erreur SQLite : $e');
    }
  }

  // Ajouter une catégorie
  Future<void> testerCategorie(BuildContext context) async {
    final categorie = Categorie(
      nom: 'Électroménager',
      description: 'Petits appareils',
    );

    try {
      final id = await CategorieDao().insererCategorie(categorie);
      debugPrint("Catégorie insérée avec l'id $id");
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cette catégorie existe déjà')),
        );
      } else {
        debugPrint('Erreur SQLite : $e');
      }
    }
  }

  // Ajouter un produit
  Future<void> testerProduit() async {
    final produit = Produit(
      nom: 'Stylo rouge',
      prix: 0.700,
      quantite: 50,
      disponible: true,
      dateAjout: DateTime.now(),
      categorieId: 4,
    );

    try {
      final id = await ProduitDao().insererProduit(produit);
      debugPrint('Produit inséré avec ID : $id');
    } catch (e) {
      debugPrint('Erreur produit : $e');
    }
  }

  // Afficher toutes les catégories
  Future<void> afficherCategories() async {
    try {
      final categories = await CategorieDao().obtenirToutesLesCategories();

      for (final categorie in categories) {
        debugPrint(categorie.toString());
      }
    } catch (e) {
      debugPrint('Erreur lecture catégories : $e');
    }
  }

  // Afficher tous les produits
  Future<void> afficherProduits() async {
    try {
      final produits = await ProduitDao().obtenirTousLesProduits();

      for (final produit in produits) {
        debugPrint(produit.toString());
      }
    } catch (e) {
      debugPrint('Erreur lecture produits : $e');
    }
  }

  // Q4.10 : Tester la contrainte de clé étrangère
  Future<void> testerCleEtrangere() async {
    try {
      final db = await DatabaseHelper().database;

      await db.insert('produits', {
        'nom': 'Produit test',
        'prix': 10.0,
        'quantite': 5,
        'disponible': 1,
        'date_ajout': DateTime.now().toIso8601String(),
        'categorie_id': 9999,
      });

      debugPrint('ERREUR : insertion acceptée !');
    } catch (e) {
      debugPrint('Contrainte de clé étrangère vérifiée : $e');
    }
  }

  // Q4.11 : Tester le prix négatif
  Future<void> testerPrixNegatif() async {
    try {
      final db = await DatabaseHelper().database;

      await db.insert('produits', {
        'nom': 'Produit prix négatif',
        'prix': -2.0,
        'quantite': 5,
        'disponible': 1,
        'date_ajout': DateTime.now().toIso8601String(),
        'categorie_id': 4,
      });

      debugPrint('ERREUR : insertion acceptée !');
    } catch (e) {
      debugPrint('Insertion refusée : $e');
    }
  }

  // Q5.3 : Tester la lecture des produits
  Future<void> testerLectureProduits() async {
    try {
      final db = await DatabaseHelper().database;

      final lignes = await db.query('produits');

      debugPrint('Type du résultat : ${lignes.runtimeType}');
      debugPrint('Résultat brut : $lignes');

      if (lignes.isNotEmpty) {
        try {
          lignes.first['nom'] = 'Test';
          debugPrint('La modification a été acceptée.');
        } catch (e) {
          debugPrint('Erreur de modification de la Map : $e');
        }
      } else {
        debugPrint('Aucun produit disponible pour le test.');
      }

      final produits = await ProduitDao().lireProduits();

      for (final produit in produits) {
        debugPrint(produit.toString());
      }
    } catch (e) {
      debugPrint('Erreur lecture produits : $e');
    }
  }

  // Q5.4 : Rechercher un produit par ID
  Future<void> testerRechercheProduit() async {
    try {
      final produit = await ProduitDao().obtenirProduitParId(3);

      if (produit != null) {
        debugPrint('Produit trouvé : ${produit.toString()}');
      } else {
        debugPrint('Aucun produit trouvé avec ID 3.');
      }
    } catch (e) {
      debugPrint('Erreur recherche produit : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tests SQLite')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: testerBase,
            child: const Text('Tester la base de données'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () => testerCategorie(context),
            child: const Text('Ajouter une catégorie'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerProduit,
            child: const Text('Ajouter un produit'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: afficherCategories,
            child: const Text('Afficher les catégories'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: afficherProduits,
            child: const Text('Afficher les produits'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerCleEtrangere,
            child: const Text('Tester la clé étrangère'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerPrixNegatif,
            child: const Text('Tester le prix négatif'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerLectureProduits,
            child: const Text('Tester la lecture des produits'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: testerRechercheProduit,
            child: const Text('Rechercher produit ID 3'),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProduitsScreen()),
              );
            },
            child: const Text('Ouvrir la liste des produits'),
          ),
        ],
      ),
    );
  }
}
