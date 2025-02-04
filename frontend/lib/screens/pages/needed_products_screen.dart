import 'package:flutter/material.dart';

class NeededProductsScreen extends StatelessWidget {
  const NeededProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produits nécessaires")),
      body: const Center(
        child: Text("Liste des produits nécessaires ici."),
      ),
    );
  }
}
