import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditExpenseModal extends StatefulWidget {
  final Map<String, dynamic> expense;
  final Function onExpenseUpdated;

  const EditExpenseModal({Key? key, required this.expense, required this.onExpenseUpdated}) : super(key: key);

  @override
  _EditExpenseModalState createState() => _EditExpenseModalState();
}

class _EditExpenseModalState extends State<EditExpenseModal> {
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late TextEditingController categoryController;

  final String apiUrl = "http://localhost:5000/api/expenses";

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.expense['description']);
    amountController = TextEditingController(text: widget.expense['amount'].toString());
    categoryController = TextEditingController(text: widget.expense['category']);
  }

  void editExpense() async {
    final response = await http.put(
      Uri.parse('$apiUrl/${widget.expense['_id']}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "description": descriptionController.text,
        "amount": double.parse(amountController.text),
        "category": categoryController.text,
      }),
    );

    if (response.statusCode == 200) {
      widget.onExpenseUpdated();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier une Dépense"),
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
        ElevatedButton(onPressed: editExpense, child: const Text("Modifier")),
      ],
    );
  }
}
