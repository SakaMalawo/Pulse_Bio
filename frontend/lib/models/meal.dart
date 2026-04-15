class Meal {
  final int? id;
  final String food;
  final double calories;
  final double? protein;
  final double? carbohydrates;
  final double? fats;
  final DateTime mealTime;
  final DateTime? eatenAt;
  final String? userId;

  Meal({
    this.id,
    required this.food,
    required this.calories,
    this.protein,
    this.carbohydrates,
    this.fats,
    required this.mealTime,
    this.eatenAt,
    this.userId,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      food: json['food'] ?? json['food_name'] ?? '',
      calories: json['calories'] != null ? (json['calories'] as num).toDouble() : 0.0,
      protein: json['protein'] != null ? (json['protein'] as num).toDouble() : null,
      carbohydrates: json['carbohydrates'] != null ? (json['carbohydrates'] as num).toDouble() : null,
      fats: json['fats'] != null ? (json['fats'] as num).toDouble() : null,
      mealTime: DateTime.parse(json['meal_time'] ?? json['eaten_at'] ?? DateTime.now().toIso8601String()),
      eatenAt: json['eaten_at'] != null ? DateTime.parse(json['eaten_at']) : null,
      userId: json['user_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food,
      'food_name': food,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fats': fats,
      'meal_time': mealTime.toIso8601String(),
      'eaten_at': eatenAt?.toIso8601String(),
    };
  }
}
