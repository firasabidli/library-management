// statistiques_screen.dart
import 'package:flutter/material.dart';
import '../main_scaffold.dart';

class StatistiquesScreen extends StatelessWidget {
  const StatistiquesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      body: const Center(child: Text('Statistiques')),
    );
  }
}
