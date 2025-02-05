import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../component/UserAddModal.dart';
import '../component/UserEditModal.dart';

class GestionUtilisateursScreen extends StatefulWidget {
  const GestionUtilisateursScreen({Key? key}) : super(key: key);

  @override
  _GestionUtilisateursScreenState createState() => _GestionUtilisateursScreenState();
}

class _GestionUtilisateursScreenState extends State<GestionUtilisateursScreen> {
  List<Map<String, dynamic>> users = [];
  final String apiUrl = "http://localhost:5000/api/users";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Récupération des utilisateurs depuis l'API
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        users = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    }
  }

  // Suppression avec confirmation
  void deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      setState(() {
        users.removeWhere((user) => user['_id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utilisateur supprimé avec succès")),
      );
    }
  }

  void confirmDeleteUser(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous vraiment supprimer cet utilisateur ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              deleteUser(id);
              Navigator.pop(context);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Ouvrir les modals
  void openAddUserModal() {
    showDialog(
      context: context,
      builder: (context) => UserAddModal(onUserAdded: fetchUsers),
    );
  }

  void openEditUserModal(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => UserEditModal(user: user, onUserUpdated: fetchUsers),
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Gestion des Utilisateurs")),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: openAddUserModal,
            child: const Text("Ajouter un utilisateur"),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Permet le scroll vertical
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Permet le scroll horizontal
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Nom")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Rôle")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['name'])),
                    DataCell(Text(user['email'])),
                    DataCell(Text(user['role'])),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => openEditUserModal(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDeleteUser(user['_id']),
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
