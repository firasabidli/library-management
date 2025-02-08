import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddPurchaseModal extends StatefulWidget {
  final Function onPurchaseAdded;
  const AddPurchaseModal({Key? key, required this.onPurchaseAdded}) : super(key: key);

  @override
  _AddPurchaseModalState createState() => _AddPurchaseModalState();
}

class _AddPurchaseModalState extends State<AddPurchaseModal> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();

  final String apiUrl = "http://localhost:5000/api/purchases";

  void addPurchase() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "itemName": itemNameController.text,
        "supplier": supplierController.text,
        "quantity": int.parse(quantityController.text),
        "totalPrice": double.parse(totalPriceController.text),
      }),
    );

    if (response.statusCode == 201) {
      widget.onPurchaseAdded();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un Achat"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: itemNameController, decoration: const InputDecoration(labelText: "Nom de l'article")),
          TextField(controller: supplierController, decoration: const InputDecoration(labelText: "Fournisseur")),
          TextField(controller: quantityController, decoration: const InputDecoration(labelText: "Quantité"), keyboardType: TextInputType.number),
          TextField(controller: totalPriceController, decoration: const InputDecoration(labelText: "Prix Total"), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(onPressed: addPurchase, child: const Text("Ajouter")),
      ],
    );
  }
}
