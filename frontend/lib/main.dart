// main.dart
import 'package:flutter/material.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/pages/home.dart';
import 'screens/pages/livres_screen.dart';
import 'screens/pages/statistiques_screen.dart';
import 'screens/pages/parametres_screen.dart';
import 'screens/pages/profil_screen.dart';
import 'screens/pages/about_screen.dart';
import 'screens/pages/contact_screen.dart';
import 'screens/pages/employee_screen.dart';
import 'screens/pages/expenses_screen.dart';
import 'screens/pages/gestion_produit_screen.dart';
import 'screens/pages/gestion_utilisateur_screen.dart';
import 'screens/pages/needed_products_screen.dart';
import 'screens/pages/purchases_screen.dart';
import 'auth_middleware.dart'; // Pour la protection de la home
import 'no_auth_middleware.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion de bibliothèque',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => NoAuthMiddleware(child: const SignupScreen()),
        '/login': (context) => NoAuthMiddleware(child: const LoginScreen()),
        '/home': (context) => AuthMiddleware(child: const HomeScreen()),
        '/livres': (context) => AuthMiddleware(child: const LivresScreen()),
        '/statistiques': (context) => AuthMiddleware(child: const StatistiquesScreen()),
        '/parametres': (context) => AuthMiddleware(child: const ParametresScreen()),
        '/profil': (context) => AuthMiddleware(child: const ProfilScreen()),
        '/about': (context) => AuthMiddleware(child: const AboutScreen()),
        '/contact': (context) => AuthMiddleware(child: const ContactScreen()),
        '/gestion-utilisateurs': (context) => AuthMiddleware(child: const GestionUtilisateursScreen()),
        '/gestion-produits': (context) => AuthMiddleware(child: const GestionProduitsScreen()),
        '/employees': (context) => AuthMiddleware(child: const EmployeesScreen()),
        '/expenses': (context) => AuthMiddleware(child: const ExpensesScreen()),
        '/neededproducts': (context) => AuthMiddleware(child: const NeededProductsScreen()),
        '/purchases': (context) => AuthMiddleware(child: const PurchasesScreen()),
      },
    );
  }
}
