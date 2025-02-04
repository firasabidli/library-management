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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF3C41CF),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pushNamed(context, '/contact');
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text('CRUD'),
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Gestion utilisateurs'),
                  onTap: () {
                    Navigator.pushNamed(context, '/gestion-utilisateurs');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.production_quantity_limits),
                  title: const Text('Gestion des produits'),
                  onTap: () {
                    Navigator.pushNamed(context, '/gestion-produits');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Employés'),
                  onTap: () {
                    Navigator.pushNamed(context, '/employees');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money_off),
                  title: const Text('Dépenses'),
                  onTap: () {
                    Navigator.pushNamed(context, '/expenses');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_add_check),
                  title: const Text('Produits nécessaires'),
                  onTap: () {
                    Navigator.pushNamed(context, '/neededproducts');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Achats'),
                  onTap: () {
                    Navigator.pushNamed(context, '/purchases');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: NavbarBottom(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
