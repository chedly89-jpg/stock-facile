import 'package:flutter/material.dart';

import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';

class _DetailProduit {
  final Produit produit;
  final Categorie? categorie;

  const _DetailProduit(this.produit, this.categorie);
}

class ProduitDetailScreen extends StatefulWidget {
  final int produitId;

  const ProduitDetailScreen({super.key, required this.produitId});

  @override
  State<ProduitDetailScreen> createState() => _ProduitDetailScreenState();
}

class _ProduitDetailScreenState extends State<ProduitDetailScreen> {
  late Future<_DetailProduit?> _futurDetail;

  @override
  void initState() {
    super.initState();
    _futurDetail = _charger();
  }

  Future<_DetailProduit?> _charger() async {
    final produit = await ProduitDao().lireProduitParId(widget.produitId);
    if (produit == null) {
      return null;
    }
    final categorie = await CategorieDao().lireCategorieParId(
      produit.categorieId,
    );
    return _DetailProduit(produit, categorie);
  }

  String _formaterDate(DateTime d) {
    final jj = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$jj/$mm/${d.year}';
  }

  Widget _ligne(IconData icone, String libelle, String valeur) {
    return ListTile(
      leading: Icon(icone),
      title: Text(libelle),
      trailing: Text(
        valeur,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail du produit')),
      body: FutureBuilder<_DetailProduit?>(
        future: _futurDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final detail = snapshot.data;
          if (detail == null) {
            return const Center(child: Text('Produit introuvable'));
          }

          final p = detail.produit;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _ligne(Icons.label, 'Nom', p.nom),
                      _ligne(
                        Icons.payments,
                        'Prix',
                        '${p.prix.toStringAsFixed(3)} DT',
                      ),
                      _ligne(
                        Icons.inventory_2,
                        'Quantité',
                        p.quantite.toString(),
                      ),
                      _ligne(
                        p.disponible ? Icons.check_circle : Icons.cancel,
                        'Disponible',
                        p.disponible ? 'Oui' : 'Non',
                      ),
                      _ligne(
                        Icons.category,
                        'Catégorie',
                        detail.categorie?.nom ?? 'Inconnue',
                      ),
                      _ligne(
                        Icons.calendar_today,
                        "Date d'ajout",
                        _formaterDate(p.dateAjout),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
