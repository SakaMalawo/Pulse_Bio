import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/glass_card.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  int _currentStep = 0;
  String _activityLevel = 'Sédentaire';
  String _dietaryGoal = 'Mieux manger';
  String _dietType = 'Équilibré';

  void _nextStep() {
    if (_currentStep == 0) {
      if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
        return;
      }
      setState(() => _currentStep = 1);
      return;
    }
    _register();
  }

  void _register() async {
    final age = int.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    setState(() => _isLoading = true);
    final success = await _apiService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      age,
      weight,
      height,
      _medicalHistoryController.text,
      _activityLevel,
      _dietaryGoal,
      _dietType,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Compte créé avec succès !')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de l\'inscription')));
    }
  }

  Widget _stepIndicator() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: _currentStep >= 1 ? Colors.green : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text('Étape ${_currentStep + 1}/2', style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildDropdown(String label, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: InputDecoration(labelText: label),
      items: options.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('Inscription'), centerTitle: true, backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E3E32), Color(0xFF1D7F5D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: GlassCard(
                padding: EdgeInsets.all(20.0),
                color: Color.fromRGBO(14, 38, 34, 0.90),
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Rejoignez BioPulse', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: 8),
                          Text('Complétez un rapide profil santé', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 16),
                          LinearProgressIndicator(value: (_currentStep + 1) / 2, color: Colors.green.shade300, backgroundColor: Colors.white12),
                          SizedBox(height: 16),
                          if (_currentStep == 0) ...[
                            _buildInputField(_nameController, 'Nom complet', Icons.person),
                            SizedBox(height: 14),
                            _buildInputField(_emailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                            SizedBox(height: 14),
                            _buildInputField(_passwordController, 'Mot de passe', Icons.lock_outline, obscureText: true),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _nextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: Text('Suivant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ] else ...[
                            Column(
                              children: [
                                _buildInputField(_ageController, 'Âge', Icons.format_list_numbered, keyboardType: TextInputType.number),
                                SizedBox(height: 12),
                                _buildInputField(_weightController, 'Poids (kg)', Icons.monitor_weight, keyboardType: TextInputType.number),
                                SizedBox(height: 12),
                                _buildInputField(_heightController, 'Taille (cm)', Icons.height, keyboardType: TextInputType.number),
                              ],
                            ),
                            SizedBox(height: 12),
                            _buildDropdown('Niveau d\'activité', _activityLevel, ['Sédentaire', 'Modéré', 'Actif', 'Sportif'], (value) => setState(() => _activityLevel = value ?? _activityLevel)),
                            SizedBox(height: 8),
                            _buildDropdown('Objectif nutritionnel', _dietaryGoal, ['Mieux manger', 'Perdre du poids', 'Gagner de l\'énergie', 'Garder la forme'], (value) => setState(() => _dietaryGoal = value ?? _dietaryGoal)),
                            SizedBox(height: 8),
                            _buildDropdown('Type de régime', _dietType, ['Équilibré', 'Végétarien', 'Faible en glucides', 'Sans préférence'], (value) => setState(() => _dietType = value ?? _dietType)),
                            SizedBox(height: 8),
                            TextField(
                              controller: _medicalHistoryController,
                              decoration: InputDecoration(labelText: 'Historique médical (optionnel)', prefixIcon: Icon(Icons.article_outlined)),
                              maxLines: 3,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(onPressed: () => setState(() => _currentStep = 0), child: Text('Retour', style: TextStyle(color: Colors.green.shade200))),
                                ElevatedButton(
                                  onPressed: _nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 26.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  ),
                                  child: Text('Terminer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
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
