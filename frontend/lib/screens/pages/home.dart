// home_screen.dart
import 'package:flutter/material.dart';
import '../main_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      body: const Center(child: Text('Home')),
    );
  }
}
