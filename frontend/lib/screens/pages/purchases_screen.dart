import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../component/add_purchase_modal.dart';
import '../component/edit_purchase_modal.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  List<Map<String, dynamic>> purchases = [];
  bool isLoading = true;
  final String apiUrl = "http://localhost:5000/api/purchases";

  @override
  void initState() {
    super.initState();
    fetchPurchases();
  }

  // Récupération des achats
  Future<void> fetchPurchases() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          purchases = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception("Erreur lors du chargement");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    }
  }

  // Suppression d'un achat
  void deletePurchase(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      setState(() {
        purchases.removeWhere((purchase) => purchase['_id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Achat supprimé avec succès")),
      );
    }
  }

  void confirmDeletePurchase(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous supprimer cet achat ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              deletePurchase(id);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void openAddPurchaseModal() {
    showDialog(
      context: context,
      builder: (context) => AddPurchaseModal(onPurchaseAdded: fetchPurchases),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Achats")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: openAddPurchaseModal,
              child: const Text("Ajouter un achat"),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Article")),
                        DataColumn(label: Text("Fournisseur")),
                        DataColumn(label: Text("Quantité")),
                        DataColumn(label: Text("Prix Total")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: purchases.map((purchase) {
                        return DataRow(cells: [
                          DataCell(Text(purchase['itemName'])),
                          DataCell(Text(purchase['supplier'])),
                          DataCell(Text(purchase['quantity'].toString())),
                          DataCell(Text("${purchase['totalPrice']} DT")),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => EditPurchaseModal(
                                    purchase: purchase,
                                    onPurchaseUpdated: fetchPurchases,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => confirmDeletePurchase(purchase['_id']),
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
