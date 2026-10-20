class SplashModel {
  final bool isInitialized;
  final String statusText;

  const SplashModel({
    this.isInitialized = false,
    this.statusText = 'Yükleniyor...',
  });

  SplashModel copyWith({
    bool? isInitialized,
    String? statusText,
  }) {
    return SplashModel(
      isInitialized: isInitialized ?? this.isInitialized,
      statusText: statusText ?? this.statusText,
    );
  }

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      isInitialized: json['isInitialized'] as bool? ?? false,
      statusText: json['statusText'] as String? ?? 'Yükleniyor...',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isInitialized': isInitialized,
      'statusText': statusText,
    };
  }
}
