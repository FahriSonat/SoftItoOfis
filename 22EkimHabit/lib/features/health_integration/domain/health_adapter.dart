enum HealthDataType {
  steps,
  distanceMeters,
  activeMinutes,
  sleepMinutes,
  waterMl,
}

class HealthRecord {
  final HealthDataType type;
  final double value;
  final DateTime recordedAt;
  final String source; // 'HealthKit', 'HealthConnect', 'Manual'

  const HealthRecord({
    required this.type,
    required this.value,
    required this.recordedAt,
    required this.source,
  });
}

abstract class HealthIntegrationAdapter {
  Future<bool> isSupported();
  Future<bool> requestPermissions(List<HealthDataType> types);
  Future<List<HealthRecord>> fetchRecords(
    HealthDataType type,
    DateTime start,
    DateTime end,
  );
}

/// Standart dürüst adapter: Platform izinleri veya donanım yoksa güvenli fallback sağlar
class LocalHealthIntegrationAdapter implements HealthIntegrationAdapter {
  final Set<String> _processedIds = {};

  @override
  Future<bool> isSupported() async => false; // MVP aşamasında dürüst unavailable

  @override
  Future<bool> requestPermissions(List<HealthDataType> types) async => false;

  @override
  Future<List<HealthRecord>> fetchRecords(
    HealthDataType type,
    DateTime start,
    DateTime end,
  ) async {
    return [];
  }

  /// Deduplication: Aynı zaman ve kaynaktaki kaydın iki kez işlenmesini önler
  bool deduplicateRecord(String uniqueExternalId) {
    if (_processedIds.contains(uniqueExternalId)) {
      return false; // Çift kayıt!
    }
    _processedIds.add(uniqueExternalId);
    return true; // Yeni kayıt
  }
}
