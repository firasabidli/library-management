import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact")),
      body: const Center(
        child: Text(
          "Email: contact@bibliotheque.com\nTéléphone: +216 99 999 999",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
