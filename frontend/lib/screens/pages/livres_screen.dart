// livres_screen.dart
import 'package:flutter/material.dart';
import '../main_scaffold.dart';

class LivresScreen extends StatelessWidget {
  const LivresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      body: const Center(child: Text('Livres')),
    );
  }
}
