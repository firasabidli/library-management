import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dépenses")),
      body: const Center(
        child: Text("Suivi des dépenses ici."),
      ),
    );
  }
}
