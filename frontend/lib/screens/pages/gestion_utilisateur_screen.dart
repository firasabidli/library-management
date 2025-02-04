import 'package:flutter/material.dart';

class GestionUtilisateursScreen extends StatelessWidget {
  const GestionUtilisateursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Utilisateurs")),
      body: const Center(
        child: Text("Liste et gestion des utilisateurs ici."),
      ),
    );
  }
}
