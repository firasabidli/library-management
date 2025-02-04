import 'package:flutter/material.dart';

class GestionProduitsScreen extends StatelessWidget {
  const GestionProduitsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Produits")),
      body: const Center(
        child: Text("Ajouter, modifier et supprimer des produits ici."),
      ),
    );
  }
}
