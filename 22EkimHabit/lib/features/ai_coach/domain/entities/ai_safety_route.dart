enum SafetyRoute {
  normalCoaching,
  relapseUrge,
  medicalOrMedication,
  alcoholWithdrawalRisk,
  gamblingFinancialCrisis,
  selfHarmOrImmediateDanger,
  abuseOrIllegalRequest,
  promptInjection;

  bool get isCritical =>
      this == selfHarmOrImmediateDanger ||
      this == alcoholWithdrawalRisk ||
      this == medicalOrMedication;

  String? get emergencyHelpline {
    switch (this) {
      case selfHarmOrImmediateDanger:
        return '112 Acil Çağrı Merkezi';
      case alcoholWithdrawalRisk:
        return '115 YEDAM (Yeşilay Danışmanlık) & 112 Acil';
      case gamblingFinancialCrisis:
        return '115 YEDAM (Yeşilay Kumar Danışma)';
      case medicalOrMedication:
        return '182 MHRS / Aile Hekimi veya Doktorunuz';
      default:
        return null;
    }
  }

  String? get cannedSafetyMessage {
    switch (this) {
      case selfHarmOrImmediateDanger:
        return 'Güvenliğin ve sağlığın her şeyden önemlidir. Yaşadığın bu zor anlarda yalnız değilsin. Lütfen hemen 112 Acil Çağrı Merkezini ara veya en yakın sağlık kuruluşuna başvur.';
      case alcoholWithdrawalRisk:
        return 'Ciddi alkol yoksunluğu belirtileri (titreme, yoğun terleme, kafa karışıklığı) tıbbi gözetim gerektiren acil bir sağlık durumudur. Lütfen kendi kendine kesmek yerine 115 YEDAM veya 112 ile iletişime geç.';
      case medicalOrMedication:
        return 'Denge Koçu bir tıp uzmanı veya doktor değildir. Reçeteli ilaçların kullanımını, dozunu veya bırakılmasını mutlaka seni takip eden hekimle ya da eczacınla görüşmelisin.';
      case gamblingFinancialCrisis:
        return 'Kumar dürtüsü veya mali kriz anlarında profesyonel rehberlik almak en güvenli adımdır. Ücretsiz ve gizli destek için 115 YEDAM uzmanlarıyla görüşebilirsin.';
      default:
        return null;
    }
  }
}
