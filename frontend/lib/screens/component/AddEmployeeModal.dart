import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddEmployeeModal extends StatefulWidget {
  final VoidCallback onEmployeeAdded;

  const AddEmployeeModal({Key? key, required this.onEmployeeAdded}) : super(key: key);

  @override
  _AddEmployeeModalState createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployeeModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  void addEmployee() async {
    if (nameController.text.isEmpty || positionController.text.isEmpty || salaryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://localhost:5000/api/employees"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": nameController.text,
          "position": positionController.text,
          "salary": double.parse(salaryController.text),
        }),
      );

      if (response.statusCode == 201) {
        widget.onEmployeeAdded();
        Navigator.pop(context);
      } else {
        throw Exception("Erreur lors de l'ajout");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter un employé"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
          TextField(controller: positionController, decoration: const InputDecoration(labelText: "Poste")),
          TextField(controller: salaryController, decoration: const InputDecoration(labelText: "Salaire"), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(onPressed: addEmployee, child: const Text("Ajouter")),
      ],
    );
  }
}
