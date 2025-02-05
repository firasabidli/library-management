import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../component/ProductAddModal.dart';
import '../component/ProductEditModal.dart';

class GestionProduitsScreen extends StatefulWidget {
  const GestionProduitsScreen({Key? key}) : super(key: key);

  @override
  _GestionProduitsScreenState createState() => _GestionProduitsScreenState();
}

class _GestionProduitsScreenState extends State<GestionProduitsScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  final String apiUrl = "http://localhost:5000/api/products";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Récupération des produits depuis l'API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception("Erreur lors du chargement des produits");
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

  // Suppression avec confirmation
  void deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      setState(() {
        products.removeWhere((product) => product['_id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produit supprimé avec succès")),
      );
    }
  }

  void confirmDeleteProduct(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous vraiment supprimer ce produit ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              deleteProduct(id);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Ouvrir les modals
  void openAddProductModal() {
    showDialog(
      context: context,
      builder: (context) => ProductAddModal(onProductAdded: fetchProducts),
    );
  }

  void openEditProductModal(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => ProductEditModal(product: product, onProductUpdated: fetchProducts),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Produits")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: openAddProductModal,
              child: const Text("Ajouter un produit"),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Nom")),
                          DataColumn(label: Text("Type")),
                          DataColumn(label: Text("Prix")),
                          DataColumn(label: Text("Stock")),
                          DataColumn(label: Text("Fournisseur")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: products.map((product) {
                          return DataRow(cells: [
                            DataCell(Text(product['name'])),
                            DataCell(Text(product['type'])),
                            DataCell(Text("${product['price']} DT")),
                            DataCell(Text("${product['stock']} unités")),
                            DataCell(Text(product['supplier'] ?? "N/A")),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => openEditProductModal(product),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => confirmDeleteProduct(product['_id']),
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
