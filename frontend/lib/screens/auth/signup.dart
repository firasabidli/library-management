
import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // Service d'inscription

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _signup() async {
  setState(() {
    _isLoading = true;
  });

  final name = _nameController.text;
  final email = _emailController.text;
  final password = _passwordController.text;
  final confirmPassword = _confirmPasswordController.text;

  if (name.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez remplir tous les champs.')),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Les mots de passe ne correspondent pas.')),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  try {
    // Appel à la méthode signup
    bool success = await AuthService.signup(name, email, password);

    if (success) {
      // Si l'inscription est réussie, on appelle ensuite la méthode login pour connecter l'utilisateur
      bool loginSuccess = await AuthService.login(context, email, password);
      if (!loginSuccess) {
        // En cas d'échec de la connexion, vous pouvez afficher un message approprié.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie, mais échec de la connexion automatique.')),
        );
      }
      // Note : la méthode login de AuthService effectue déjà une redirection vers '/home'
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'inscription. Veuillez réessayer.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Une erreur est survenue. Réessayez plus tard.')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF3C41CF), // Couleur de fond
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image en haut
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/image_register.png', // Chemin de l'image locale
                    height: 350, // Taille de l'image
                  ),
                ),
                const SizedBox(height: 16),

                // Texte d'introduction
                Text(
                  "Créez un compte",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Champs de saisie
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nom d\'utilisateur',
                    hintStyle: TextStyle(color: Color(0xFF000000)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xFF000000)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(color: Color(0xFF000000)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirmer mot de passe',
                    hintStyle: TextStyle(color: Color(0xFF000000)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Bouton S'inscrire
                Center(
  child: AnimatedContainer(
    duration: Duration(milliseconds: 300),
    width: _isLoading ? 50 : 200,
    height: 50,
    decoration: BoxDecoration(
      color: Color(0xFF83FF7D),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : GestureDetector(
            onTap: _signup,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Icon(Icons.person_add, color: Colors.white),
                ),
                Expanded(
                  child: Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
  ),
),

                const SizedBox(height: 16),

                // Lien pour aller à la connexion
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Center(
                    child: Text(
                      "Déjà un compte ? Connectez-vous",
                      style: TextStyle(
                        fontSize: 16,
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
