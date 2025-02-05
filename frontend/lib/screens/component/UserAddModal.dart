import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAddModal extends StatefulWidget {
  final Function onUserAdded;

  const UserAddModal({Key? key, required this.onUserAdded}) : super(key: key);

  @override
  _UserAddModalState createState() => _UserAddModalState();
}

class _UserAddModalState extends State<UserAddModal> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String role = 'user';

  Future<void> submitUser() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse("http://localhost:5000/api/users"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"name": name, "email": email, "password": password, "role": role}),
    );

    if (response.statusCode == 201) {
      widget.onUserAdded();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Utilisateur ajouté avec succès")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un utilisateur"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Nom"),
              onChanged: (value) => name = value,
              validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: (value) => email = value,
              validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Mot de passe"),
              onChanged: (value) => password = value,
              obscureText: true,
              validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
            ),
            DropdownButtonFormField(
              value: role,
              items: ['user', 'admin'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) => setState(() => role = value as String),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(onPressed: submitUser, child: const Text("Enregistrer")),
      ],
    );
  }
}
