import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditPurchaseModal extends StatefulWidget {
  final Map<String, dynamic> purchase;
  final Function onPurchaseUpdated;

  const EditPurchaseModal({Key? key, required this.purchase, required this.onPurchaseUpdated}) : super(key: key);

  @override
  _EditPurchaseModalState createState() => _EditPurchaseModalState();
}

class _EditPurchaseModalState extends State<EditPurchaseModal> {
  late TextEditingController itemNameController;
  late TextEditingController supplierController;
  late TextEditingController quantityController;
  late TextEditingController totalPriceController;

  final String apiUrl = "http://localhost:5000/api/purchases";

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.purchase['itemName']);
    supplierController = TextEditingController(text: widget.purchase['supplier']);
    quantityController = TextEditingController(text: widget.purchase['quantity'].toString());
    totalPriceController = TextEditingController(text: widget.purchase['totalPrice'].toString());
  }

  void editPurchase() async {
    final response = await http.put(
      Uri.parse('$apiUrl/${widget.purchase['_id']}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "itemName": itemNameController.text,
        "supplier": supplierController.text,
        "quantity": int.parse(quantityController.text),
        "totalPrice": double.parse(totalPriceController.text),
      }),
    );

    if (response.statusCode == 200) {
      widget.onPurchaseUpdated();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier un Achat"),
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
        ElevatedButton(onPressed: editPurchase, child: const Text("Modifier")),
      ],
    );
  }
}
