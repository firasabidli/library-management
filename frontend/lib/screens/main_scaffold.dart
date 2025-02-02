// main_scaffold.dart
import 'package:flutter/material.dart';
import 'navbar_bottom.dart';
import '../services/auth_service.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const MainScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/livres');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/statistiques');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/parametres');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
      case 5:
        AuthService.logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion de Bibliothèque"),
        backgroundColor: const Color(0xFF3C41CF),
      ),
      body: body,
      bottomNavigationBar: NavbarBottom(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
