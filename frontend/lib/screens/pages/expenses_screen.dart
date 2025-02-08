import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../component/add_expense_modal.dart';
import '../component/edit_expense_modal.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;
  final String apiUrl = "http://localhost:5000/api/expenses";

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  // Récupération des dépenses
  Future<void> fetchExpenses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          expenses = List<Map<String, dynamic>>.from(json.decode(response.body));
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

  // Suppression d'une dépense
  void deleteExpense(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      setState(() {
        expenses.removeWhere((exp) => exp['_id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dépense supprimée avec succès")),
      );
    }
  }

  void confirmDeleteExpense(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous supprimer cette dépense ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              deleteExpense(id);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void openAddExpenseModal() {
    showDialog(
      context: context,
      builder: (context) => AddExpenseModal(onExpenseAdded: fetchExpenses),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Dépenses")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: openAddExpenseModal,
              child: const Text("Ajouter une dépense"),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Description")),
                        DataColumn(label: Text("Montant")),
                        DataColumn(label: Text("Catégorie")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: expenses.map((expense) {
                        return DataRow(cells: [
                          DataCell(Text(expense['description'])),
                          DataCell(Text("${expense['amount']} DT")),
                          DataCell(Text(expense['category'])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => EditExpenseModal(
                                    expense: expense,
                                    onExpenseUpdated: fetchExpenses,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => confirmDeleteExpense(expense['_id']),
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
