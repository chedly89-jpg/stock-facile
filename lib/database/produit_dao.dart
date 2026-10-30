
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import '../models/produit.dart';
import 'database_helper.dart';

class ProduitDao {
  static const String table = 'produits';

  // Insérer un produit
  Future<int> insererProduit(Produit produit) async {
    final Database db = await DatabaseHelper().database;

    try {
      final id = await db.insert(
        table,
        produit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return id;
    } on DatabaseException catch (e) {
      debugPrint('Erreur insertion produit : $e');
      rethrow;
    }
  }

  // Récupérer tous les produits
  Future<List<Produit>> obtenirTousLesProduits() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps =
        await db.query(table);

    return maps.map((map) => Produit.fromMap(map)).toList();
  }
}
