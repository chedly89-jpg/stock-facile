import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

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

  // Obtenir tous les produits
  Future<List<Produit>> obtenirTousLesProduits() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(table);

    return maps.map((map) => Produit.fromMap(map)).toList();
  }

  // Obtenir tous les produits triés par nom
  Future<List<Produit>> obtenirTousLesProduitsTries() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: 'nom ASC',
    );

    return maps.map((map) => Produit.fromMap(map)).toList();
  }

  // Obtenir un produit par son identifiant
  Future<Produit?> obtenirProduitParId(int id) async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Produit.fromMap(maps.first);
  }

  // Q5.3 : Lire les produits
  Future<List<Produit>> lireProduits() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> lignes = await db.query(
      table,
      orderBy: 'nom ASC',
    );

    return lignes.map((ligne) => Produit.fromMap(ligne)).toList();
  }

  Future<Produit?> lireProduitParId(int id) async {
    final Database db = await DatabaseHelper().database;
    final lignes = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return lignes.isEmpty ? null : Produit.fromMap(lignes.first);
  }
}
