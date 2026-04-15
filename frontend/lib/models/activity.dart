class Activity {
  final int? id;
  final String activityType;
  final int durationMinutes;
  final double? caloriesBurned;
  final DateTime activityDate;
  final String? userId;

  Activity({
    this.id,
    required this.activityType,
    required this.durationMinutes,
    this.caloriesBurned,
    required this.activityDate,
    this.userId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activityType: json['activity_type'],
      durationMinutes: json['duration_minutes'],
      caloriesBurned: json['calories_burned'] != null ? (json['calories_burned'] as num).toDouble() : null,
      activityDate: DateTime.parse(json['activity_date']),
      userId: json['user_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_type': activityType,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'activity_date': activityDate.toIso8601String().split('T').first,
    };
  }
}
