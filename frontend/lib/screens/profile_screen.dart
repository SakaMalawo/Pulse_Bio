import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/meal.dart';
import '../models/activity.dart';
import '../widgets/glass_card.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _apiService = ApiService();
  User? _user;
  List<Meal> _meals = [];
  List<Activity> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final profile = await _apiService.getProfile();
    final meals = await _apiService.getMeals();
    final activities = await _apiService.getActivities();
    setState(() {
      _user = profile;
      _meals = meals;
      _activities = activities;
      _isLoading = false;
    });
  }

  void _logout() async {
    await _apiService.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  double get _totalCalories => _meals.fold(0.0, (sum, meal) => sum + meal.calories);
  int get _totalActivities => _activities.length;
  int get _totalWorkoutMinutes => _activities.fold(0, (sum, activity) => sum + activity.durationMinutes);
  double get _totalCaloriesBurned => _activities.fold(0.0, (sum, activity) => sum + (activity.caloriesBurned ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(child: Text('Impossible de charger le profil.'))
              : ListView(
                  children: [
                    Text('Mon profil', style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 12),
                    GlassCard(
                      padding: EdgeInsets.all(22.0),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 32, backgroundColor: Colors.green.shade700, child: Icon(Icons.person, size: 32, color: Colors.white)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_user!.fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade900)),
                                SizedBox(height: 4),
                                Text(_user!.email, style: TextStyle(color: Colors.grey.shade700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    GlassCard(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mes statistiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _statCard('Repas', '${_meals.length}', Icons.restaurant_menu, Colors.blue)),
                              SizedBox(width: 12),
                              Expanded(child: _statCard('Calories', '${_totalCalories.toStringAsFixed(0)}', Icons.local_fire_department, Colors.orange)),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _statCard('Activités', '${_totalActivities}', Icons.directions_run, Colors.green)),
                              SizedBox(width: 12),
                              Expanded(child: _statCard('Minutes', '${_totalWorkoutMinutes}', Icons.timer, Colors.purple)),
                            ],
                          ),
                          if (_totalCaloriesBurned > 0) ...[
                            SizedBox(height: 12),
                            _statCard('Calories brûlées', '${_totalCaloriesBurned.toStringAsFixed(0)}', Icons.fitness_center, Colors.red),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    GlassCard(
                      padding: EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Informations santé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          _infoLine('Nom complet', _user!.fullName),
                          _infoLine('Email', _user!.email),
                          if (_user!.age != null) _infoLine('Âge', '${_user!.age} ans'),
                          if (_user!.weight != null) _infoLine('Poids', '${_user!.weight} kg'),
                          if (_user!.height != null) _infoLine('Taille', '${_user!.height} cm'),
                          if (_user!.medicalHistory != null && _user!.medicalHistory!.isNotEmpty) _infoLine('Historique', _user!.medicalHistory!),
                          if (_user!.activityLevel != null) _infoLine('Activité', _user!.activityLevel!),
                          if (_user!.dietaryGoal != null) _infoLine('Objectif', _user!.dietaryGoal!),
                          if (_user!.dietType != null) _infoLine('Régime', _user!.dietType!),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(onPressed: _logout, icon: Icon(Icons.logout), label: Text('Se déconnecter')),
                  ],
                ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade900)),
        ],
      ),
    );
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text('$label :', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800))),
          Expanded(flex: 3, child: Text(value, style: TextStyle(color: Colors.grey.shade700))),
        ],
      ),
    );
  }
}
