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

          // Redirection vers Home après connexion
          Navigator.pushReplacementNamed(context, '/home');
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

  // Méthode d'inscription
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
        final data = jsonDecode(response.body);

        String token = data['token'];
        Map<String, dynamic> user = data['user'];

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
      debugPrint("Erreur de signup: $e");
      return false;
    }
  }

  // Déconnexion
  static Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Vérification de connexion
  static Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'token');
    return token != null;
  }

  // Récupérer les infos utilisateur
  static Future<Map<String, String?>> getUserInfo() async {
    return {
      '_id': await _storage.read(key: '_id'),
      'name': await _storage.read(key: 'name'),
      'role': await _storage.read(key: 'role'),
    };
  }

  // Récupérer le token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
