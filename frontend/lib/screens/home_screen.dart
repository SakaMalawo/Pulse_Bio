import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../models/activity.dart';
import '../widgets/glass_card.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = ApiService();
  List<Meal> _meals = [];
  List<Activity> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final meals = await _apiService.getMeals();
    final activities = await _apiService.getActivities();
    setState(() {
      _meals = meals;
      _activities = activities;
      _isLoading = false;
    });
  }

  double get _totalCalories => _meals.fold(0.0, (sum, meal) => sum + meal.calories);
  double get _totalProtein => _meals.fold(0.0, (sum, meal) => sum + (meal.protein ?? 0.0));
  double get _totalCarbs => _meals.fold(0.0, (sum, meal) => sum + (meal.carbohydrates ?? 0.0));
  double get _totalFats => _meals.fold(0.0, (sum, meal) => sum + (meal.fats ?? 0.0));
  int get _totalActivities => _activities.length;
  int get _totalWorkoutMinutes => _activities.fold(0, (sum, activity) => sum + activity.durationMinutes);
  double get _totalCaloriesBurned => _activities.fold(0.0, (sum, activity) => sum + (activity.caloriesBurned ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Bienvenue dans BioPulse', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 8),
                Text('Votre suivi nutritionnel en un coup d\'œil', style: TextStyle(color: Colors.grey.shade700)),
                SizedBox(height: 22),
                GlassCard(
                  padding: EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Résumé nutritionnel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _dataTile('Repas', '${_meals.length}', Icons.restaurant_menu, Colors.blue)),
                          SizedBox(width: 8),
                          Expanded(child: _dataTile('Calories', '${_totalCalories.toStringAsFixed(0)} kcal', Icons.local_fire_department, Colors.orange)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _dataTile('Protéines', '${_totalProtein.toStringAsFixed(1)}g', Icons.fitness_center, Colors.green)),
                          SizedBox(width: 8),
                          Expanded(child: _dataTile('Glucides', '${_totalCarbs.toStringAsFixed(1)}g', Icons.grain, Colors.brown)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _dataTile('Lipides', '${_totalFats.toStringAsFixed(1)}g', Icons.opacity, Colors.purple)),
                          SizedBox(width: 8),
                          Expanded(child: _dataTile('Activités', '${_totalActivities}', Icons.directions_run, Colors.red)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GlassCard(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Objectifs de la semaine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      _progressBar('Calories quotidiennes', _totalCalories, 2000, Colors.orange),
                      SizedBox(height: 12),
                      _progressBar('Activités physiques', _totalActivities.toDouble(), 5, Colors.green),
                      SizedBox(height: 12),
                      _progressBar('Minutes d\'exercice', _totalWorkoutMinutes.toDouble(), 150, Colors.blue),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Derniers repas', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 12),
                if (_meals.isEmpty)
                  GlassCard(
                    padding: EdgeInsets.all(22.0),
                    child: Center(child: Text('Aucun repas enregistré pour le moment.', style: TextStyle(fontSize: 16))),
                  )
                else
                  Column(
                    children: _meals.take(5).map((meal) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GlassCard(
                          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: Colors.green.shade700, child: Icon(Icons.restaurant_menu, color: Colors.white)),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(meal.food, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text('${meal.calories} kcal • ${meal.eatenAt.toString().substring(0, 16)}', style: TextStyle(color: Colors.grey.shade700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
    );
  }

  Widget _dataTile(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            SizedBox(height: 12),
            Text(title, style: TextStyle(color: Colors.grey.shade800, fontSize: 12)),
            SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade900)),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(String title, double current, double goal, Color color) {
    final progress = (current / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            Text('${current.toStringAsFixed(0)}/${goal.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
