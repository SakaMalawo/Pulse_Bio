import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/glass_card.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    setState(() => _isLoading = true);
    final token = await _apiService.login(_emailController.text, _passwordController.text);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (token != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la connexion')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('Connexion'), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -0.5),
            radius: 1.4,
            colors: [Color(0xFF122E24), Color(0xFF0B1E15)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: GlassCard(
                padding: EdgeInsets.all(20.0),
                color: Color.fromRGBO(18, 52, 42, 0.86),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset('assets/images/biopulse.webp', width: 100, height: 100, fit: BoxFit.contain),
                    ),
                    SizedBox(height: 16),
                    Text('Connexion', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Accédez à votre espace santé', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 15)),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            child: Text('Se connecter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                      child: Text('Créer un compte', style: TextStyle(color: Colors.green.shade200)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen())),
                      child: Text('Mot de passe oublié ?', style: TextStyle(color: Colors.green.shade200)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
