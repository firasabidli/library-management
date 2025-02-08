import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/auth_service.dart'; // Import ajouté
import '../component/add_product_modal.dart';
import '../component/edit_product_modal.dart';

class NeededProductsScreen extends StatefulWidget {
  const NeededProductsScreen({Key? key}) : super(key: key);

  @override
  _NeededProductsScreenState createState() => _NeededProductsScreenState();
}

class _NeededProductsScreenState extends State<NeededProductsScreen> {
  List<dynamic> neededProducts = [];
  bool isLoading = true;
  String? userId; // Variable pour stocker l'ID utilisateur
  final String apiUrl = "http://localhost:5000/api/needed-products";

  @override
  void initState() {
    super.initState();
    fetchNeededProducts();
    fetchUserId(); // Appel pour récupérer l'ID utilisateur
  }

  Future<void> fetchUserId() async {
    try {
      Map<String, String?> userInfo = await AuthService.getUserInfo();
      setState(() {
        userId = userInfo['_id'];
      });
    } catch (e) {
      print("Erreur de récupération de l'ID utilisateur: $e");
    }
  }

  Future<void> fetchNeededProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          neededProducts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Erreur de chargement.");
      }
    } catch (error) {
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleProductStatus(String id, bool newStatus) async {
    await http.put(
      Uri.parse("$apiUrl/state/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": newStatus ? 1 : 0}),
    );
    fetchNeededProducts();
  }

  Future<void> generatePDF() async {
    final response = await http.get(Uri.parse("$apiUrl/generate-pdf"));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF généré avec succès !")),
      );
    }
  }

  void openAddProductModal() {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utilisateur non authentifié !")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AddProductModal(
        onProductAdded: fetchNeededProducts,
        userId: userId!, // Passage de l'ID utilisateur
      ),
    );
  }

  void openEditProductModal(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => EditProductModal(
        product: product,
        onProductUpdated: fetchNeededProducts,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produits Nécessaires")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: neededProducts.length,
              itemBuilder: (context, index) {
                final product = neededProducts[index];
                bool isChecked = product['status'] == 1;

                return ListTile(
                  leading: Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      toggleProductStatus(product['_id'], value!);
                    },
                  ),
                  title: Text(
                    product['title'],
                    style: TextStyle(
                      decoration: isChecked
                          ? TextDecoration.lineThrough // Texte barré si isChecked = true
                          : TextDecoration.none, // Pas de décoration sinon
                    ),
                  ),
                  subtitle: Text(
                    "Quantité: ${product['requiredQuantity']} | Stock: ${product['currentStock']}",
                    style: TextStyle(
                      decoration: isChecked
                          ? TextDecoration.lineThrough // Texte barré si isChecked = true
                          : TextDecoration.none, // Pas de décoration sinon
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => openEditProductModal(product),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: openAddProductModal,
            child: const Icon(Icons.add),
            tooltip: "Ajouter un produit",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: generatePDF,
            child: const Icon(Icons.picture_as_pdf),
            tooltip: "Générer PDF",
          ),
        ],
      ),
    );
  }
}