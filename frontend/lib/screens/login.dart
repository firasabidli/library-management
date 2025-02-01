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
        decoration: const BoxDecoration(color: Color(0xFF3C41CF)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset('assets/image_login.png', height: 350),
              ),
              const SizedBox(height: 16),
              const Text("Bienvenue sur", style: TextStyle(fontSize: 16, color: Colors.white)),
              const Text(
                "HOMELAND",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              _buildTextField(_emailController, "Email"),
              const SizedBox(height: 16),
              _buildTextField(_passwordController, "Mot de passe", obscureText: true),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildTextButton("Mot de passe oublié ?", () {}),
              const SizedBox(height: 16),
              _buildTextButton("Créer un compte", () => Navigator.pushNamed(context, '/signup')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isLoading ? 50 : 200,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF83FF7D),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 3)),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : GestureDetector(
                onTap: _login,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.login, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Se connecter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
