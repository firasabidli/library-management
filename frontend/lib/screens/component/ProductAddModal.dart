import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductAddModal extends StatefulWidget {
  final VoidCallback onProductAdded;

  const ProductAddModal({Key? key, required this.onProductAdded}) : super(key: key);

  @override
  _ProductAddModalState createState() => _ProductAddModalState();
}

class _ProductAddModalState extends State<ProductAddModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = "Fournitures scolaires";

  void addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs obligatoires doivent être remplis")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://localhost:5000/api/products"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": nameController.text,
          "type": selectedType,
          "price": double.parse(priceController.text),
          "stock": int.parse(stockController.text),
          "supplier": supplierController.text,
          "description": descriptionController.text,
        }),
      );

      if (response.statusCode == 201) {
        widget.onProductAdded();
        Navigator.pop(context);
      } else {
        throw Exception("Erreur lors de l'ajout du produit");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un produit"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
          DropdownButtonFormField(
            value: selectedType,
            onChanged: (value) => setState(() => selectedType = value.toString()),
            items: ["Fournitures scolaires", "Tabac"]
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
          ),
          TextField(controller: priceController, decoration: const InputDecoration(labelText: "Prix"), keyboardType: TextInputType.number),
          TextField(controller: stockController, decoration: const InputDecoration(labelText: "Stock"), keyboardType: TextInputType.number),
          TextField(controller: supplierController, decoration: const InputDecoration(labelText: "Fournisseur")),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(onPressed: addProduct, child: const Text("Ajouter")),
      ],
    );
  }
}
