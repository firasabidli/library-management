import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Méthode pour se connecter
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extraction du token et des informations utilisateur
        String token = data['token'];
        Map<String, dynamic> user = data['user'];

        if (token.isNotEmpty) {
          // Sauvegarder le token dans le stockage sécurisé
          await _storage.write(key: 'token', value: token);

          // Sauvegarder les informations utilisateur dans le stockage sécurisé
          await _storage.write(key: '_id', value: user['id']);
          await _storage.write(key: 'name', value: user['name']);
          await _storage.write(key: 'role', value: user['role']);

          return true;
        } else {
          throw Exception('Token manquant dans la réponse');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Erreur d\'authentification: ${errorData['message']}');
      }
    } catch (e) {
      print("Erreur de login: $e");
      rethrow;
    }
  }

  // Méthode pour s'inscrire (signup)
  static Future<bool> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // L'utilisateur a été créé avec succès
        final data = jsonDecode(response.body);

        String token = data['token'];
        Map<String, dynamic> user = data['user'];

        // Sauvegarder le token et les informations utilisateur
        await _storage.write(key: 'token', value: token);
        await _storage.write(key: '_id', value: user['id']);
        await _storage.write(key: 'name', value: user['name']);
        await _storage.write(key: 'role', value: user['role']);

        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Erreur d\'inscription: ${errorData['message']}');
      }
    } catch (e) {
      print("Erreur de signup: $e");
      rethrow;
    }
  }

  // Méthode pour se déconnecter
  static Future<void> logout() async {
    // Supprimer les données du stockage sécurisé
    await _storage.delete(key: 'token');
    await _storage.delete(key: '_id');
    await _storage.delete(key: 'name');
    await _storage.delete(key: 'role');
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    // Vérifier si un token existe
    String? token = await _storage.read(key: 'token');
    return token != null;
  }

  // Méthode pour récupérer les informations de l'utilisateur
  static Future<Map<String, String?>> getUserInfo() async {
    String? id = await _storage.read(key: '_id');
    String? name = await _storage.read(key: 'name');
    String? role = await _storage.read(key: 'role');

    return {
      '_id': id,
      'name': name,
      'role': role,
    };
  }

  // Méthode pour récupérer le token (si nécessaire)
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
