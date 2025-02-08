import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddExpenseModal extends StatefulWidget {
  final Function onExpenseAdded;
  const AddExpenseModal({Key? key, required this.onExpenseAdded}) : super(key: key);

  @override
  _AddExpenseModalState createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final String apiUrl = "http://localhost:5000/api/expenses";

  void addExpense() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "description": descriptionController.text,
        "amount": double.parse(amountController.text),
        "category": categoryController.text,
      }),
    );

    if (response.statusCode == 201) {
      widget.onExpenseAdded();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter une Dépense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
          TextField(controller: amountController, decoration: const InputDecoration(labelText: "Montant"), keyboardType: TextInputType.number),
          TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Catégorie")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(onPressed: addExpense, child: const Text("Ajouter")),
      ],
    );
  }
}
