import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/glass_card.dart';

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with TickerProviderStateMixin {
  final _apiService = ApiService();
  List<Meal> _meals = [];
  bool _isLoading = true;
  late AnimationController _cardAnimationController;
  
  // Base de données d'aliments avec informations nutritionnelles
  final List<Map<String, dynamic>> _foodDatabase = [
    {
      'name': 'Poulet grillé',
      'category': 'Protéines',
      'icon': Icons.egg,
      'color': Colors.red,
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fats': 3.6,
      'description': 'Excellente source de protéines maigres',
      'benefits': ['Muscle', 'Satiété', 'Faible en gras']
    },
    {
      'name': 'Riz brun',
      'category': 'Glucides',
      'icon': Icons.grain,
      'color': Colors.brown,
      'calories': 111,
      'protein': 2.6,
      'carbs': 23,
      'fats': 0.9,
      'description': 'Glucides complexes à digestion lente',
      'benefits': ['Énergie durable', 'Fibres', 'Vitamines B']
    },
    {
      'name': 'Avocat',
      'category': 'Lipides',
      'icon': Icons.opacity,
      'color': Colors.green,
      'calories': 160,
      'protein': 2,
      'carbs': 8.5,
      'fats': 14.7,
      'description': 'Graisses saines et antioxydants',
      'benefits': ['Coeur', 'Peau', 'Vitamines']
    },
    {
      'name': 'Saumon',
      'category': 'Protéines',
      'icon': Icons.set_meal,
      'color': Colors.pink,
      'calories': 208,
      'protein': 20,
      'carbs': 0,
      'fats': 13,
      'description': 'Riche en oméga-3 et protéines',
      'benefits': ['Cerveau', 'Anti-inflammatoire', 'Vitamine D']
    },
    {
      'name': 'Quinoa',
      'category': 'Glucides',
      'icon': Icons.grass,
      'color': Colors.amber,
      'calories': 120,
      'protein': 4.4,
      'carbs': 21,
      'fats': 1.9,
      'description': 'Protéine complète et sans gluten',
      'benefits': ['Protéines', 'Fibres', 'Minéraux']
    },
    {
      'name': 'Amandes',
      'category': 'Lipides',
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'calories': 164,
      'protein': 6,
      'carbs': 6,
      'fats': 14,
      'description': 'Noix riches en nutriments',
      'benefits': ['Coeur', 'Énergie', 'Vitamine E']
    },
    {
      'name': 'Épinards',
      'category': 'Légumes',
      'icon': Icons.eco,
      'color': Colors.green.shade700,
      'calories': 23,
      'protein': 2.9,
      'carbs': 3.6,
      'fats': 0.4,
      'description': 'Super aliment riche en nutriments',
      'benefits': ['Fer', 'Vitamines', 'Antioxydants']
    },
    {
      'name': 'Banane',
      'category': 'Fruits',
      'icon': Icons.breakfast_dining,
      'color': Colors.yellow,
      'calories': 89,
      'protein': 1.1,
      'carbs': 23,
      'fats': 0.3,
      'description': 'Énergie rapide et potassium',
      'benefits': ['Potassium', 'Énergie', 'Digestion']
    },
  ];

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _loadMeals();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _loadMeals() async {
    setState(() => _isLoading = true);
    final meals = await _apiService.getMeals();
    setState(() {
      _meals = meals;
      _isLoading = false;
    });
  }

  double get _totalCalories => _meals.fold(0.0, (sum, meal) => sum + meal.calories);
  double get _totalProtein => _meals.fold(0.0, (sum, meal) => sum + (meal.protein ?? 0.0));
  double get _totalCarbs => _meals.fold(0.0, (sum, meal) => sum + (meal.carbohydrates ?? 0.0));
  double get _totalFats => _meals.fold(0.0, (sum, meal) => sum + (meal.fats ?? 0.0));
  double get _avgCalories => _meals.isEmpty ? 0.0 : _totalCalories / _meals.length;

  void _showFoodSelection() async {
    final quantityController = TextEditingController();
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                  Text('Choisir un aliment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Liste des aliments
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _foodDatabase.length,
                itemBuilder: (context, index) {
                  final food = _foodDatabase[index];
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
                                  color: food['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(food['icon'], color: food['color'], size: 24),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(food['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text(food['description'], style: TextStyle(color: Colors.grey.shade600)),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: food['color'].withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(food['category'], style: TextStyle(fontSize: 12, color: food['color'])),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Informations nutritionnelles
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _nutritionInfo('Calories', '${food['calories']}', Icons.local_fire_department, Colors.orange),
                              _nutritionInfo('Protéines', '${food['protein']}g', Icons.fitness_center, Colors.red),
                              _nutritionInfo('Glucides', '${food['carbs']}g', Icons.grain, Colors.brown),
                              _nutritionInfo('Lipides', '${food['fats']}g', Icons.opacity, Colors.green),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Bénéfices
                          Text('Bénéfices nutritionnels :', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: food['benefits'].map<Widget>((benefit) => 
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: food['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(benefit, style: TextStyle(fontSize: 12, color: food['color'])),
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
                                _showQuantityDialog(food);
                              },
                              icon: Icon(Icons.add),
                              label: Text('Ajouter cet aliment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: food['color'],
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
    );
  }

  void _showQuantityDialog(Map<String, dynamic> food) async {
    final quantityController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        title: Row(
          children: [
            Icon(food['icon'], color: food['color']),
            SizedBox(width: 12),
            Text(food['name']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Quelle quantité ? (en portions)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantité',
                hintText: 'Ex: 1.5',
                prefixIcon: Icon(Icons.scale),
              ),
              autofocus: true,
            ),
            SizedBox(height: 16),
            Text('Valeurs nutritionnelles pour 1 portion :', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${food['calories']} cal', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                Text('${food['protein']}g P', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                Text('${food['carbs']}g G', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.w600)),
                Text('${food['fats']}g L', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final quantity = double.tryParse(quantityController.text) ?? 0;
              if (quantity <= 0) return;
              
              final totalCalories = (food['calories'] * quantity).toDouble();
              final totalProtein = (food['protein'] * quantity).toDouble();
              final totalCarbs = (food['carbs'] * quantity).toDouble();
              final totalFats = (food['fats'] * quantity).toDouble();
              
              final meal = Meal(
                food: food['name'],
                calories: totalCalories,
                protein: totalProtein,
                carbohydrates: totalCarbs,
                fats: totalFats,
                mealTime: DateTime.now(),
                eatenAt: DateTime.now(),
              );
              
              final success = await _apiService.addMeal(meal);
              if (!mounted) return;
              if (success) {
                Navigator.pop(context);
                _cardAnimationController.forward();
                _loadMeals();
              }
            },
            child: Text('Ajouter'),
            style: ElevatedButton.styleFrom(backgroundColor: food['color']),
          ),
        ],
      ),
    );
  }

  Widget _nutritionInfo(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
      ],
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
              Text('Nutrition', style: Theme.of(context).textTheme.headlineSmall),
              ElevatedButton.icon(
                onPressed: _showFoodSelection,
                icon: Icon(Icons.add),
                label: Text('Ajouter'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Section statistiques nutritionnelles
          GlassCard(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aperçu nutritionnel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _nutrientCard('Calories totales', '${_totalCalories.toStringAsFixed(0)} kcal', Icons.local_fire_department, Colors.orange)),
                    SizedBox(width: 12),
                    Expanded(child: _nutrientCard('Protéines', '${_totalProtein.toStringAsFixed(1)}g', Icons.fitness_center, Colors.red)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _nutrientCard('Glucides', '${_totalCarbs.toStringAsFixed(1)}g', Icons.grain, Colors.brown)),
                    SizedBox(width: 12),
                    Expanded(child: _nutrientCard('Lipides', '${_totalFats.toStringAsFixed(1)}g', Icons.opacity, Colors.green)),
                  ],
                ),
                SizedBox(height: 16),
                // Conseils nutritionnels
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue.shade600),
                          SizedBox(width: 8),
                          Text('Conseils nutritionnels', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                        ],
                      ),
                      SizedBox(height: 12),
                      _nutritionAdvice(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text('Vos repas', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _meals.isEmpty
                    ? GlassCard(
                        padding: EdgeInsets.all(28.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.restaurant, size: 64, color: Colors.grey.shade400),
                              SizedBox(height: 16),
                              Text('Aucun repas enregistré', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                              SizedBox(height: 8),
                              Text('Commencez par ajouter votre premier repas !', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _meals.length,
                        itemBuilder: (context, index) {
                          final meal = _meals[index];
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
                                    child: Icon(Icons.restaurant, color: Colors.green.shade700),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(meal.food, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        SizedBox(height: 4),
                                        Text('${meal.calories.toStringAsFixed(0)} kcal', style: TextStyle(color: Colors.grey.shade700)),
                                        if (meal.protein != null && meal.carbohydrates != null && meal.fats != null)
                                          Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Text('P: ${meal.protein?.toStringAsFixed(1)}g | G: ${meal.carbohydrates?.toStringAsFixed(1)}g | L: ${meal.fats?.toStringAsFixed(1)}g', 
                                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                          ),
                                      ],
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
    );
  }

  Widget _nutrientCard(String title, String value, IconData icon, Color color) {
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutritionAdvice() {
    String advice;
    IconData icon;
    Color color;
    
    if (_totalCalories < 1200) {
      advice = 'Votre apport calorique est faible. Pensez à ajouter des aliments plus denses en énergie.';
      icon = Icons.warning;
      color = Colors.orange;
    } else if (_totalCalories > 2500) {
      advice = 'Votre apport calorique est élevé. Essayez de privilégier les aliments moins caloriques.';
      icon = Icons.warning;
      color = Colors.red;
    } else {
      advice = 'Bon équilibre calorique ! Continuez comme ça.';
      icon = Icons.check_circle;
      color = Colors.green;
    }
    
    if (_totalProtein < 50) {
      advice += ' Considérez d\'augmenter votre apport en protéines.';
    }
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(advice, style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }
}
