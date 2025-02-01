import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Méthode de connexion
  static Future<bool> login(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        Map<String, dynamic> user = data['user'];

        if (token.isNotEmpty) {
          await _storage.write(key: 'token', value: token);
          await _storage.write(key: '_id', value: user['id']);
          await _storage.write(key: 'name', value: user['name']);
          await _storage.write(key: 'role', value: user['role']);

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          return true;
        } else {
          throw Exception('Token manquant dans la réponse');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Erreur d\'authentification: ${errorData['message']}');
      }
    } catch (e) {
      debugPrint("Erreur de login: $e");
      return false;
    }
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    final email = _emailController.text;
    final password = _passwordController.text;
    final BuildContext currentContext = context;

    try {
      bool success = await AuthService.login(currentContext, email, password);

      if (!success && currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Échec de la connexion. Vérifiez vos informations.')),
        );
      }
    } catch (e) {
      if (currentContext.mounted) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue. Réessayez plus tard.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF3C41CF),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/image_login.png',
                    height: 350,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Bienvenue sur",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Text(
                  "HOMELAND",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
               Center(
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    width: _isLoading ? 50 : 200,
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xFF83FF7D),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : GestureDetector(
            onTap: _login,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.login, color: Colors.white),
                const SizedBox(width: 8),
                // Utilisez Flexible pour éviter les débordements
                Flexible(
                  child: const Text(
                    "Se connecter",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
  ),
),

                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // Action pour le mot de passe oublié
                  },
                  child: const Center(
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Center(
                    child: Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}