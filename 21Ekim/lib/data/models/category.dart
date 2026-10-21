enum CategoryType { income, expense, both }

enum Rule503020Type {
  needs,    // Zorunlu İhtiyaçlar (%50)
  wants,    // İstekler & Yaşam (%30)
  savings,  // Tasarruf & Borç (%20)
}

class Category {
  final String id;
  final String name;
  final CategoryType type;
  final String colorHex;
  final String? iconName;
  final bool isSystem;
  final Rule503020Type? rule503020Type;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.colorHex,
    this.iconName,
    this.isSystem = false,
    this.rule503020Type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'colorHex': colorHex,
      'iconName': iconName,
      'isSystem': isSystem,
      'rule503020Type': rule503020Type?.name,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CategoryType.values.byName(json['type'] as String),
      colorHex: json['colorHex'] as String,
      iconName: json['iconName'] as String?,
      isSystem: json['isSystem'] as bool? ?? false,
      rule503020Type: json['rule503020Type'] != null
          ? Rule503020Type.values.byName(json['rule503020Type'] as String)
          : null,
    );
  }
}
