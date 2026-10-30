
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../models/categorie.dart';
import 'database_helper.dart';

class CategorieDao {
  static const String table = 'categories';

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

  Future<List<Categorie>> obtenirToutesLesCategories() async {
    final Database db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(table);

    return maps.map((map) => Categorie.fromMap(map)).toList();
  }
}
