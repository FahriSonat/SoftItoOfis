/// Test edilebilir ve zaman kaydırmalarına olanak sağlayan saat arayüzü
abstract class Clock {
  DateTime now();
}

/// Standart sistem saati
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// Testler ve simülasyonlar için sabit/ayarlanabilir saat
class TestClock implements Clock {
  DateTime _current;

  TestClock([DateTime? initial])
    : _current = initial ?? DateTime(2026, 10, 23, 10, 0, 0);

  @override
  DateTime now() => _current;

  void setTime(DateTime time) {
    _current = time;
  }

  void advance(Duration duration) {
    _current = _current.add(duration);
  }
}
