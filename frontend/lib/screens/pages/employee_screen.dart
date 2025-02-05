import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../component/AddEmployeeModal.dart';
import '../component/EditEmployeeModal.dart';
import '../component/PaySalaryModal.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  EmployeesScreenState createState() => EmployeesScreenState();
}

class EmployeesScreenState extends State<EmployeesScreen> {
  List<Map<String, dynamic>> employees = [];
  bool isLoading = true;
  final String apiUrl = "http://localhost:5000/api/employees";

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  // 📌 Récupération des employés depuis l'API
  Future<void> fetchEmployees() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          employees = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception("Erreur lors du chargement des employés");
      }
    } catch (error) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    }
  }

  // 📌 Suppression d'un employé
  void deleteEmployee(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200) {
        setState(() {
          employees.removeWhere((emp) => emp['_id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employé supprimé avec succès")),
        );
      } else {
        throw Exception("Erreur lors de la suppression");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    }
  }

  // 📌 Confirmation de suppression
  void confirmDeleteEmployee(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous vraiment supprimer cet employé ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              deleteEmployee(id);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 📌 Ouvrir le modal d'ajout d'un employé
  void openAddEmployeeModal() {
    showDialog(
      context: context,
      builder: (context) => AddEmployeeModal(onEmployeeAdded: fetchEmployees),
    );
  }

  // 📌 Ouvrir le modal de paiement de salaire
  void openPaySalaryModal(Map<String, dynamic> employee) {
    showDialog(
      context: context,
      builder: (context) => PaySalaryModal(employee: employee, onSalaryPaid: fetchEmployees),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Employés")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: openAddEmployeeModal,
              child: const Text("Ajouter un employé"),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Nom")),
                        DataColumn(label: Text("Poste")),
                        DataColumn(label: Text("Salaire")),
                        DataColumn(label: Text("Payé")),
                        DataColumn(label: Text("Restant")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: employees.map((employee) {
                        return DataRow(cells: [
                          DataCell(Text(employee['name'])),
                          DataCell(Text(employee['position'])),
                          DataCell(Text("${employee['salary']} DT")),
                          DataCell(Text("${employee['paidAmount']} DT")),
                          DataCell(Text("${employee['pendingAmount']} DT")),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_money, color: Colors.green),
                                onPressed: () => openPaySalaryModal(employee),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => EditEmployeeModal(
                                    employee: employee,
                                    onEmployeeUpdated: fetchEmployees,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => confirmDeleteEmployee(employee['_id']),
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
