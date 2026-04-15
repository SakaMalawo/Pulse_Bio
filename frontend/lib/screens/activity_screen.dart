import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/activity.dart';
import '../widgets/glass_card.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with TickerProviderStateMixin {
  final _apiService = ApiService();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  List<Activity> _activities = [];
  String? _selectedActivity;
  late AnimationController _progressAnimationController;
  late AnimationController _cardAnimationController;
  
  // Liste d'activités prédéfinies avec informations détaillées
  final List<Map<String, dynamic>> _predefinedActivities = [
    {
      'name': 'Course à pied',
      'icon': Icons.directions_run,
      'color': Colors.red,
      'calories_per_min': 10,
      'description': 'Excellent pour le cardio et l\'endurance',
      'benefits': ['Perte de poids', 'Santé cardiovasculaire', 'Endurance']
    },
    {
      'name': 'Marche rapide',
      'icon': Icons.directions_walk,
      'color': Colors.green,
      'calories_per_min': 6,
      'description': 'Accessible à tous, faible impact',
      'benefits': ['Santé articulaire', 'Gestion du stress', 'Dépense calorique modérée']
    },
    {
      'name': 'Vélo',
      'icon': Icons.pedal_bike,
      'color': Colors.blue,
      'calories_per_min': 8,
      'description': 'Excellent pour les jambes et le cœur',
      'benefits': ['Muscu des jambes', 'Endurance', 'Faible impact']
    },
    {
      'name': 'Natation',
      'icon': Icons.pool,
      'color': Colors.cyan,
      'calories_per_min': 11,
      'description': 'Sport complet, tout le corps',
      'benefits': ['Muscu complète', 'Faible impact', 'Souplesse']
    },
    {
      'name': 'Yoga',
      'icon': Icons.self_improvement,
      'color': Colors.purple,
      'calories_per_min': 3,
      'description': 'Bien-être et flexibilité',
      'benefits': ['Gestion du stress', 'Souplesse', 'Équilibre']
    },
    {
      'name': 'Musculation',
      'icon': Icons.fitness_center,
      'color': Colors.orange,
      'calories_per_min': 7,
      'description': 'Renforcement musculaire complet',
      'benefits': ['Force musculaire', 'Métabolisme', 'Masse osseuse']
    },
    {
      'name': 'Danse',
      'icon': Icons.music_note,
      'color': Colors.pink,
      'calories_per_min': 5,
      'description': 'Fun et excellent pour le cardio',
      'benefits': ['Coordination', 'Endurance', 'Humeur positive']
    },
    {
      'name': 'Football',
      'icon': Icons.sports_soccer,
      'color': Colors.brown,
      'calories_per_min': 9,
      'description': 'Sport d\'équipe complet',
      'benefits': ['Cardio intense', 'Travail d\'équipe', 'Agilité']
    },
  ];
  
  // Objectifs de la semaine avec animations
  final int _weeklyTargetMinutes = 150;
  final int _weeklyTargetActivities = 5;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _loadActivities();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _loadActivities() async {
    setState(() => _isLoading = true);
    final activities = await _apiService.getActivities();
    if (!mounted) return;
    setState(() {
      _activities = activities;
      _isLoading = false;
    });
    _progressAnimationController.forward();
  }

  // Statistiques avec animations
  int get _totalMinutes => _activities.fold(0, (sum, activity) => sum + activity.durationMinutes);
  int get _totalActivities => _activities.length;
  double get _totalCaloriesBurned => _activities.fold(0.0, (sum, activity) => sum + (activity.caloriesBurned ?? 0.0));
  double get _weeklyProgress => (_totalMinutes / _weeklyTargetMinutes).clamp(0.0, 1.0);
  double get _activitiesProgress => (_totalActivities / _weeklyTargetActivities).clamp(0.0, 1.0);

  void _showActivitySelection() async {
    final durationController = TextEditingController();
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Choisir une activité', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Liste des activités
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _predefinedActivities.length,
                  itemBuilder: (context, index) {
                    final activity = _predefinedActivities[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: activity['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(activity['icon'], color: activity['color'], size: 24),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(activity['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text(activity['description'], style: TextStyle(color: Colors.grey.shade600)),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                                          SizedBox(width: 4),
                                          Text('${activity['calories_per_min']} cal/min', style: TextStyle(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            // Bénéfices
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: activity['benefits'].map<Widget>((benefit) => 
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: activity['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(benefit, style: TextStyle(fontSize: 12, color: activity['color'])),
                                ),
                              ).toList(),
                            ),
                            SizedBox(height: 12),
                            // Bouton de sélection
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showDurationDialog(activity);
                                },
                                icon: Icon(Icons.add),
                                label: Text('Choisir cette activité'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: activity['color'],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDurationDialog(Map<String, dynamic> activity) async {
    final durationController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        title: Row(
          children: [
            Icon(activity['icon'], color: activity['color']),
            SizedBox(width: 12),
            Text(activity['name']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Combien de minutes ?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Durée (minutes)',
                hintText: 'Ex: 30',
                prefixIcon: Icon(Icons.timer),
              ),
              autofocus: true,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('Date : ${_selectedDate.toLocal().toIso8601String().substring(0, 10)}')),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: Text('Changer'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final duration = int.tryParse(durationController.text) ?? 0;
              if (duration <= 0) return;
              
              final totalCalories = (duration * activity['calories_per_min']).toDouble();
              
              final newActivity = Activity(
                activityType: activity['name'],
                durationMinutes: duration,
                caloriesBurned: totalCalories,
                activityDate: _selectedDate,
              );
              
              final success = await _apiService.addActivity(newActivity);
              if (!mounted) return;
              if (success) {
                Navigator.pop(context);
                _cardAnimationController.forward();
                _loadActivities();
              }
            },
            child: Text('Ajouter'),
            style: ElevatedButton.styleFrom(backgroundColor: activity['color']),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Suivi des activités', style: Theme.of(context).textTheme.headlineSmall),
              ElevatedButton.icon(
                onPressed: _showActivitySelection,
                icon: Icon(Icons.add),
                label: Text('Ajouter'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Section objectifs et suivi avec animations
          AnimatedBuilder(
            animation: _progressAnimationController,
            builder: (context, child) {
              return GlassCard(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Objectifs de la semaine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _animatedProgressCard('Minutes d\'exercice', _totalMinutes, _weeklyTargetMinutes, _weeklyProgress, Colors.blue, Icons.timer),
                    SizedBox(height: 12),
                    _animatedProgressCard('Nombre d\'activités', _totalActivities, _weeklyTargetActivities, _activitiesProgress, Colors.green, Icons.fitness_center),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _animatedStatCard('Calories brûlées', '${_totalCaloriesBurned.toStringAsFixed(0)} kcal', Icons.local_fire_department, Colors.orange)),
                        SizedBox(width: 12),
                        Expanded(child: _animatedStatCard('Moyenne/activité', '${_totalActivities > 0 ? (_totalMinutes / _totalActivities).toStringAsFixed(0) : 0} min', Icons.calculate, Colors.purple)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 16),
          Text('Vos activités', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _activities.isEmpty
                    ? GlassCard(
                        padding: EdgeInsets.all(28.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.directions_run, size: 64, color: Colors.grey.shade400),
                              SizedBox(height: 16),
                              Text('Aucune activité enregistrée', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                              SizedBox(height: 8),
                              Text('Commencez par ajouter votre première activité !', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _activities.length,
                        itemBuilder: (context, index) {
                          final activity = _activities[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.directions_run, color: Colors.green.shade700),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(activity.activityType, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        SizedBox(height: 4),
                                        Text('${activity.durationMinutes} min • ${activity.activityDate.toIso8601String().substring(0, 10)}', style: TextStyle(color: Colors.grey.shade700)),
                                      ],
                                    ),
                                  ),
                                  if (activity.caloriesBurned != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text('${activity.caloriesBurned} kcal', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange.shade800)),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _animatedProgressCard(String title, int current, int target, double progress, Color color, IconData icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                Text('$current/$target', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
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
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            Text('${(value * 100).toStringAsFixed(0)}% atteint', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        );
      },
    );
  }

  Widget _animatedStatCard(String title, dynamic value, IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                        Text(value.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
