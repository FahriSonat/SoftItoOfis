class NutritionModel {
  final String id;
  final String mealName;
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String mealType;

  const NutritionModel({
    required this.id,
    required this.mealName,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.mealType,
  });

  NutritionModel copyWith({
    String? id,
    String? mealName,
    int? calories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    String? mealType,
  }) {
    return NutritionModel(
      id: id ?? this.id,
      mealName: mealName ?? this.mealName,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      mealType: mealType ?? this.mealType,
    );
  }

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      id: json['id'] as String? ?? '',
      mealName: json['mealName'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      proteinGrams: (json['proteinGrams'] as num?)?.toDouble() ?? 0.0,
      carbsGrams: (json['carbsGrams'] as num?)?.toDouble() ?? 0.0,
      fatGrams: (json['fatGrams'] as num?)?.toDouble() ?? 0.0,
      mealType: json['mealType'] as String? ?? 'Öğün',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealName': mealName,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'mealType': mealType,
    };
  }
}
