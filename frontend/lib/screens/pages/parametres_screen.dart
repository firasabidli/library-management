// parametres_screen.dart
import 'package:flutter/material.dart';
import '../main_scaffold.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      body: const Center(child: Text('Parametres')),
    );
  }
}
