class User {
  final String id;
  final String fullName;
  final String email;
  final int? age;
  final double? weight;
  final double? height;
  final String? medicalHistory;
  final String? activityLevel;
  final String? dietaryGoal;
  final String? dietType;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.age,
    this.weight,
    this.height,
    this.medicalHistory,
    this.activityLevel,
    this.dietaryGoal,
    this.dietType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      fullName: json['full_name'],
      email: json['email'],
      age: json['age'],
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      medicalHistory: json['medical_history'],
      activityLevel: json['activity_level'],
      dietaryGoal: json['dietary_goal'],
      dietType: json['diet_type'],
    );
  }
}
