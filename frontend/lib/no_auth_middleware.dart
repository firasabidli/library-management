import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/pages/home.dart';
class NoAuthMiddleware extends StatefulWidget {
  final Widget child;

  const NoAuthMiddleware({Key? key, required this.child}) : super(key: key);

  @override
  _NoAuthMiddlewareState createState() => _NoAuthMiddlewareState();
}

class _NoAuthMiddlewareState extends State<NoAuthMiddleware> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    String? token = await _storage.read(key: 'token');
    setState(() {
      _isAuthenticated = token != null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Si l'utilisateur est authentifié, rediriger vers Home.
    if (_isAuthenticated) {
      // On peut utiliser Navigator.pushReplacement pour éviter que l'utilisateur ne revienne à la page précédente.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
      return const SizedBox(); // Affiche temporairement rien
    }
    
    // Sinon, afficher la page demandée (login ou signup)
    return widget.child;
  }
}
