import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/categorie.dart';
import 'database_helper.dart';

class CategorieDao {
  static const String table = 'categories';

  // Insérer une catégorie
  Future<int> insererCategorie(Categorie categorie) async {
    final Database db = await DatabaseHelper().database;

    try {
      final id = await db.insert(
        table,
        categorie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return id;
    } on DatabaseException catch (e) {
      debugPrint('Erreur insertion catégorie : $e');
      rethrow;
    }
  }

  // Obtenir toutes les catégories
  Future<List<Categorie>> obtenirToutesLesCategories() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(table);

    return maps.map((map) => Categorie.fromMap(map)).toList();
  }

  // Obtenir toutes les catégories triées par nom
  Future<List<Categorie>> obtenirToutesLesCategoriesTriees() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: 'nom ASC',
    );

    return maps.map((map) => Categorie.fromMap(map)).toList();
  }

  Future<List<Categorie>> lireCategories() async {
    final Database db = await DatabaseHelper().database;
    final lignes = await db.query(table, orderBy: 'nom ASC');
    return lignes.map((ligne) => Categorie.fromMap(ligne)).toList();
  }

  Future<Categorie?> lireCategorieParId(int id) async {
    final Database db = await DatabaseHelper().database;
    final lignes = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return lignes.isEmpty ? null : Categorie.fromMap(lignes.first);
  }
}
