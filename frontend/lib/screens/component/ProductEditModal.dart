import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductEditModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onProductUpdated;

  const ProductEditModal({Key? key, required this.product, required this.onProductUpdated}) : super(key: key);

  @override
  _ProductEditModalState createState() => _ProductEditModalState();
}

class _ProductEditModalState extends State<ProductEditModal> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController supplierController;
  late TextEditingController descriptionController;
  String selectedType = "Fournitures scolaires";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    priceController = TextEditingController(text: widget.product['price'].toString());
    stockController = TextEditingController(text: widget.product['stock'].toString());
    supplierController = TextEditingController(text: widget.product['supplier'].toString());
    descriptionController = TextEditingController(text: widget.product['description'].toString());
    
    // Initialiser selectedType avec la valeur actuelle du produit
    selectedType = widget.product['type'] ?? "Fournitures scolaires";
  }

  void updateProduct() async {
    final response = await http.put(
      Uri.parse("http://localhost:5000/api/products/${widget.product['_id']}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": nameController.text,
        "type": selectedType, // Ajouter le type
        "price": double.parse(priceController.text),
        "stock": int.parse(stockController.text),
        "supplier": supplierController.text,
        "description": descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      widget.onProductUpdated();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la mise à jour du produit")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier le produit"),
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
        ElevatedButton(onPressed: updateProduct, child: const Text("Modifier")),
      ],
    );
  }
}
