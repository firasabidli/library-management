import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditEmployeeModal extends StatefulWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onEmployeeUpdated;

  const EditEmployeeModal({Key? key, required this.employee, required this.onEmployeeUpdated}) : super(key: key);

  @override
  _EditEmployeeModalState createState() => _EditEmployeeModalState();
}

class _EditEmployeeModalState extends State<EditEmployeeModal> {
  late TextEditingController nameController;
  late TextEditingController positionController;
  late TextEditingController salaryController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee['name']);
    positionController = TextEditingController(text: widget.employee['position']);
    salaryController = TextEditingController(text: widget.employee['salary'].toString());
  }

  void updateEmployee() async {
    setState(() {
      isLoading = true;
    });

    final String apiUrl = "http://localhost:5000/api/employees/${widget.employee['_id']}";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": nameController.text,
          "position": positionController.text,
          "salary": double.parse(salaryController.text),
        }),
      );

      if (response.statusCode == 200) {
        widget.onEmployeeUpdated();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employé mis à jour avec succès")),
        );
      } else {
        throw Exception("Erreur lors de la mise à jour");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modifier l'employé"),
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
        ElevatedButton(
          onPressed: isLoading ? null : updateEmployee,
          child: isLoading ? const CircularProgressIndicator() : const Text("Enregistrer"),
        ),
      ],
    );
  }
}
