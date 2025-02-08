import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onProductUpdated;

  const EditProductModal({
    Key? key,
    required this.product,
    required this.onProductUpdated,
  }) : super(key: key);

  @override
  _EditProductModalState createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController requiredQuantityController = TextEditingController();
  final TextEditingController currentStockController = TextEditingController();
  final TextEditingController userNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs avec les données du produit
    titleController.text = widget.product['title'];
    requiredQuantityController.text = widget.product['requiredQuantity'].toString();
    currentStockController.text = widget.product['currentStock'].toString();
    userNoteController.text = widget.product['userNote']['note'] ?? '';
  }

  Future<void> updateProduct() async {
    final String apiUrl = "http://localhost:5000/api/needed-products/${widget.product['_id']}";
    final Map<String, dynamic> updatedData = {
      "title": titleController.text,
      "requiredQuantity": int.tryParse(requiredQuantityController.text) ?? 0,
      "currentStock": int.tryParse(currentStockController.text) ?? 0,
      "userNote": {
        "userId": widget.product['userNote']['userId'],
        "note": userNoteController.text,
      },
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        widget.onProductUpdated(); // Rafraîchir la liste des produits
        Navigator.pop(context); // Fermer la modal
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
      title: const Text("Modifier un produit"),
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
          onPressed: updateProduct,
          child: const Text("Enregistrer"),
        ),
      ],
    );
  }
}