/// Price values are stored as whole TRY units in the current fake-data MVP.
/// A production implementation should use integer kuruş values from the API.
class BookingPrice {
  const BookingPrice({
    required this.subtotal,
    required this.serviceFee,
    required this.insuranceFee,
    required this.discount,
  });

  final int subtotal;
  final int serviceFee;
  final int insuranceFee;
  final int discount;

  int get total => subtotal + serviceFee + insuranceFee - discount;
}

class BookingPriceCalculator {
  const BookingPriceCalculator({
    this.serviceFee = 150,
    this.insuranceFee = 450,
    this.discount = 300,
  });

  final int serviceFee;
  final int insuranceFee;
  final int discount;

  BookingPrice calculate({required int dailyRate, required int dayCount}) {
    if (dailyRate < 0 || dayCount < 1) {
      throw ArgumentError(
        'Günlük ücret negatif olamaz ve gün sayısı en az 1 olmalıdır.',
      );
    }
    return BookingPrice(
      subtotal: dailyRate * dayCount,
      serviceFee: serviceFee,
      insuranceFee: insuranceFee,
      discount: discount,
    );
  }
}
