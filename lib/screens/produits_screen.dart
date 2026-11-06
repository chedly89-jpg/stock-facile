import 'package:flutter/material.dart';

import '../database/produit_dao.dart';
import '../models/produit.dart';
import '../widgets/produit_tile.dart';
import 'produit_detail_screen.dart';

class ProduitsScreen extends StatefulWidget {
  const ProduitsScreen({super.key});

  @override
  State<ProduitsScreen> createState() => _ProduitsScreenState();
}

class _ProduitsScreenState extends State<ProduitsScreen> {
  final ProduitDao _dao = ProduitDao();

  late Future<List<Produit>> _futurProduits;

  @override
  void initState() {
    super.initState();

    // Charger les produits une seule fois
    _futurProduits = _dao.lireProduits();
  }

  // Actualiser la liste
  void _rafraichir() {
    setState(() {
      _futurProduits = _dao.lireProduits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
        actions: [
          IconButton(
            onPressed: _rafraichir,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),

      body: FutureBuilder<List<Produit>>(
        future: _futurProduits,

        builder: (context, snapshot) {
          // 1. Chargement en cours
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Erreur
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // Récupérer les produits
          final produits = snapshot.data ?? [];

          // 3. Liste vide
          if (produits.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text('Aucun produit', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          // 4. Afficher les produits
          return RefreshIndicator(
            onRefresh: () async {
              _rafraichir();
              await _futurProduits;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: produits.length,

              itemBuilder: (context, index) {
                final produit = produits[index];

                return ProduitTile(
                  produit: produit,
                  onTap: () async {
                    final modifie = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProduitDetailScreen(produitId: produit.id!),
                      ),
                    );
                    if (modifie == true) {
                      _rafraichir();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
