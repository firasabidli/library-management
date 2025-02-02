// profil_screen.dart
import 'package:flutter/material.dart';
import '../main_scaffold.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 4,
      body: const Center(child: Text('Profil')),
    );
  }
}
