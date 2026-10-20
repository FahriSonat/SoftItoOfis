import 'package:flutter_test/flutter_test.dart';
import 'package:rotarent/features/booking/domain/booking_price.dart';

void main() {
  const calculator = BookingPriceCalculator();

  test('fiyat dökümünü deterministik hesaplar', () {
    final price = calculator.calculate(dailyRate: 1000, dayCount: 3);

    expect(price.subtotal, 3000);
    expect(price.total, 3300);
  });

  test('geçersiz gün sayısını reddeder', () {
    expect(
      () => calculator.calculate(dailyRate: 1000, dayCount: 0),
      throwsArgumentError,
    );
  });
}
