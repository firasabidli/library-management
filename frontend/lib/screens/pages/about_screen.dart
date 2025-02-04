import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("À propos")),
      body: const Center(
        child: Text(
          "Application de gestion de bibliothèque.\nDéveloppé par Firas Abidli.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
