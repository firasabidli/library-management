import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaySalaryModal extends StatefulWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onSalaryPaid;

  const PaySalaryModal({Key? key, required this.employee, required this.onSalaryPaid}) : super(key: key);

  @override
  _PaySalaryModalState createState() => _PaySalaryModalState();
}

class _PaySalaryModalState extends State<PaySalaryModal> {
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;

  Future<void> paySalary() async {
    final double amountToPay = double.tryParse(_amountController.text) ?? 0;

    if (amountToPay <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un montant valide.")),
      );
      return;
    }

    if (amountToPay > widget.employee['pendingAmount']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le montant dépasse le salaire restant.")),
      );
      return;
    }

    setState(() => isLoading = true);

    final String apiUrl = "http://localhost:5000/api/employees/${widget.employee['_id']}/pay";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": amountToPay}),
      );

      if (response.statusCode == 200) {
        widget.onSalaryPaid();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Salaire payé avec succès !")),
        );
      } else {
        throw Exception("Erreur lors du paiement.");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${error.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Payer le salaire"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Nom : ${widget.employee['name']}"),
          Text("Salaire total : ${widget.employee['salary']} DT"),
          Text("Déjà payé : ${widget.employee['paidAmount']} DT"),
          Text("Restant : ${widget.employee['pendingAmount']} DT"),
          const SizedBox(height: 10),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Montant à payer",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : paySalary,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Payer"),
        ),
      ],
    );
  }
}
