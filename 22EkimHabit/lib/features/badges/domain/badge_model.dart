class BadgeDefinition {
  final String id;
  final String title;
  final String description;
  final String iconKey;
  final String requirementDescription;

  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.requirementDescription,
  });

  static const List<BadgeDefinition> all = [
    BadgeDefinition(
      id: 'first_step',
      title: 'İlk Adım',
      description: 'İlk alışkanlığını oluşturdun ve ilk kaydını aldın.',
      iconKey: 'flag',
      requirementDescription: '1 alışkanlık ve 1 kayıt',
    ),
    BadgeDefinition(
      id: 'seven_days',
      title: '7 Gün Güçlü',
      description: 'Negatif veya pozitif alışkanlıkta 7 günlük seriye ulaştın.',
      iconKey: 'military_tech',
      requirementDescription: '7 gün / periyot streak',
    ),
    BadgeDefinition(
      id: 'thirty_periods',
      title: '30 Periyot İstikrar',
      description: 'Bir alışkanlıkta 30 başarılı periyoda ulaştın.',
      iconKey: 'verified',
      requirementDescription: '30 gün / periyot streak',
    ),
    BadgeDefinition(
      id: 'water_friend',
      title: 'Su Dostu',
      description: 'Günlük su hedefini başarıyla tamamladın.',
      iconKey: 'water_drop',
      requirementDescription: 'Su alışkanlığında en az 2000 ml tamamlama',
    ),
    BadgeDefinition(
      id: 'book_worm',
      title: 'Kitap Kurdu',
      description: 'Düzenli kitap okuma kaydı oluşturdun.',
      iconKey: 'menu_book',
      requirementDescription: 'Kitap okuma alışkanlığında 5 kayıt',
    ),
    BadgeDefinition(
      id: 'hundred_km',
      title: '100 km Yolcu',
      description: 'Yürüyüş veya koşuda toplam 100 km mesafeyi aştın.',
      iconKey: 'directions_run',
      requirementDescription: '100 km toplam mesafe',
    ),
    BadgeDefinition(
      id: 'restarted',
      title: 'Yeniden Başladım',
      description: 'Zorlandın ama pes etmedin, söz vererek yeniden başladın.',
      iconKey: 'refresh',
      requirementDescription: '1 söz verme ve yeniden başlama',
    ),
  ];
}

class UserBadge {
  final String badgeId;
  final DateTime earnedAt;
  final double progress; // 0.0 - 1.0

  const UserBadge({
    required this.badgeId,
    required this.earnedAt,
    this.progress = 1.0,
  });

  Map<String, dynamic> toJson() => {
    'badgeId': badgeId,
    'earnedAt': earnedAt.toIso8601String(),
    'progress': progress,
  };

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      badgeId: json['badgeId'] as String,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      progress: (json['progress'] as num?)?.toDouble() ?? 1.0,
    );
  }
}
