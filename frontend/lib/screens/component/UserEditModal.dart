import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserEditModal extends StatefulWidget {
  final Function onUserUpdated;
  final Map<String, dynamic> user;

  const UserEditModal({Key? key, required this.onUserUpdated, required this.user}) : super(key: key);

  @override
  _UserEditModalState createState() => _UserEditModalState();
}

class _UserEditModalState extends State<UserEditModal> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    name = widget.user['name'];
    email = widget.user['email'];
    role = widget.user['role'];
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.put(
      Uri.parse("http://localhost:5000/api/users/${widget.user['_id']}"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"name": name, "email": email, "role": role}),
    );

    if (response.statusCode == 200) {
      widget.onUserUpdated();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Utilisateur mis à jour avec succès")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier l'utilisateur"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(initialValue: name, onChanged: (value) => name = value),
            TextFormField(initialValue: email, onChanged: (value) => email = value),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")), ElevatedButton(onPressed: updateUser, child: const Text("Enregistrer"))],
    );
  }
}
