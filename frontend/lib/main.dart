// main.dart
import 'package:flutter/material.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/pages/home.dart';
import 'screens/pages/livres_screen.dart';
import 'screens/pages/statistiques_screen.dart';
import 'screens/pages/parametres_screen.dart';
import 'screens/pages/profil_screen.dart';
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
      },
    );
  }
}
