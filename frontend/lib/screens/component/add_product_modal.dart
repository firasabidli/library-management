import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductModal extends StatefulWidget {
  final VoidCallback onProductAdded;
  final String userId;

  const AddProductModal({
    Key? key,
    required this.onProductAdded,
    required this.userId,
  }) : super(key: key);

  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController requiredQuantityController = TextEditingController();
  final TextEditingController currentStockController = TextEditingController();
  final TextEditingController userNoteController = TextEditingController();

  Future<void> addNeededProduct() async {
    final String apiUrl = "http://localhost:5000/api/needed-products";
    final Map<String, dynamic> productData = {
      "title": titleController.text,
      "requiredQuantity": int.tryParse(requiredQuantityController.text) ?? 0,
      "currentStock": int.tryParse(currentStockController.text) ?? 0,
      "userNote": {
        "userId": widget.userId,
        "note": userNoteController.text,
      },
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201) {
        widget.onProductAdded();
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: $error")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion au serveur")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un produit nécessaire"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Nom du produit"),
            ),
            TextField(
              controller: requiredQuantityController,
              decoration: const InputDecoration(labelText: "Quantité nécessaire"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: currentStockController,
              decoration: const InputDecoration(labelText: "Stock actuel"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: userNoteController,
              decoration: const InputDecoration(labelText: "Note utilisateur"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: addNeededProduct,
          child: const Text("Ajouter"),
        ),
      ],
    );
  }
}