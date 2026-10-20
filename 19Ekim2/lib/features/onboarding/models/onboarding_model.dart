class OnboardingModel {
  final String title;
  final String description;
  final String iconName;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.iconName,
  });

  OnboardingModel copyWith({
    String? title,
    String? description,
    String? iconName,
  }) {
    return OnboardingModel(
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
    );
  }

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['iconName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'iconName': iconName,
    };
  }
}
