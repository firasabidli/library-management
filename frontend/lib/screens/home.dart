import 'package:flutter/material.dart';
import '../services/auth_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Liste des écrans pour chaque élément de la navbar (sans l'élément "logout")
  final List<Widget> _pages = [
    const Center(child: Text('Accueil')),
    const Center(child: Text('Livres')),
    const Center(child: Text('Statistiques')),
    const Center(child: Text('Paramètres')),
    const Center(child: Text('Profil')),
  ];

  // Fonction de déconnexion
  void _logout() async{
    // Ici tu pourrais ajouter la logique de déconnexion (par exemple effacer les données de session)
await AuthService.logout();
    // Ensuite, rediriger vers la page de connexion
    Navigator.pushReplacementNamed(context, '/login'); // Redirige vers la page de connexion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion de Bibliothèque"),
        backgroundColor: const Color(0xFF3C41CF), // Couleur de l'AppBar
      ),
      body: _currentIndex < _pages.length ? _pages[_currentIndex] : const SizedBox(), // Affiche la page si l'index est valide
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF3C41CF), // Couleur de fond de la navbar
          primaryColor: Colors.white, // Couleur des éléments sélectionnés
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(color: Colors.white70), // Couleur des éléments non sélectionnés
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 5) {
              // Si l'utilisateur clique sur l'élément logout, on appelle la fonction de déconnexion
              _logout();
            } else {
              setState(() {
                _currentIndex = index; // Change la page affichée
              });
            }
          },
          selectedItemColor: Colors.white, // Couleur de l'élément sélectionné
          unselectedItemColor: Colors.white70, // Couleur des éléments non sélectionnés
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Livres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistiques',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Paramètres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: '', // Pas de label pour l'icône logout
            ),
          ],
        ),
      ),
    );
  }
}
