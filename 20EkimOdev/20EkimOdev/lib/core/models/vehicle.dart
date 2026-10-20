class Vehicle {
  final String id;
  final String brand; // Marka (Renault, BMW, Mercedes...)
  final String model; // Model (Megane, 320i...)
  final String
  vehicleClass; // Sınıf (Ekonomik, Konfor, Prestij, Lüks, SUV, Spor)
  final String bodyType; // Cinsi (Sedan, Hatchback, SUV, Coupe...)
  final int year; // Üretim Yılı (2021, 2022, 2023, 2024...)
  final String engine; // Motor (1.3 TCe, 2.0 TwinPower, Elektrikli...)
  final String transmission; // Şanzıman (Otomatik, Manuel)
  final String fuelType; // Yakıt (Benzin, Dizel, Hibrit, Elektrik)
  final int dailyPrice; // Günlük Fiyat (TL)
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int seatCount;
  final int luggageCount;
  final bool isAvailable;
  final String rentalCompany;
  final List<String> features;

  // GPS & Telemetri özellikleri (Canlı Map ekranı için)
  final double latitude;
  final double longitude;
  final int currentSpeed; // km/s
  final int fuelPercentage; // %
  final bool isDoorLocked;
  final String engineStatus;
  final String currentAddress;
  final String plateNumber;

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.vehicleClass,
    required this.bodyType,
    required this.year,
    required this.engine,
    required this.transmission,
    required this.fuelType,
    required this.dailyPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.seatCount,
    required this.luggageCount,
    this.isAvailable = true,
    this.rentalCompany = 'RotaRent Prime',
    this.features = const [
      'Geri Görüş Kamerası',
      'Apple CarPlay / Android Auto',
      'Hız Sabitleyici',
      'Şerit Takip Sistemi',
      'Bluetooth & USB',
    ],
    this.latitude = 40.9833,
    this.longitude = 29.0277,
    this.currentSpeed = 0,
    this.fuelPercentage = 82,
    this.isDoorLocked = true,
    this.engineStatus = 'Park Halinde',
    this.currentAddress = 'Bağdat Caddesi No: 142, Kadıköy, İstanbul',
    this.plateNumber = '34 RTR 1923',
  });

  String get fullName => '$brand $model';
  String get formattedPrice => '₺$dailyPrice / gün';

  Vehicle copyWith({
    String? id,
    String? brand,
    String? model,
    String? vehicleClass,
    String? bodyType,
    int? year,
    String? engine,
    String? transmission,
    String? fuelType,
    int? dailyPrice,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? seatCount,
    int? luggageCount,
    bool? isAvailable,
    String? rentalCompany,
    List<String>? features,
    double? latitude,
    double? longitude,
    int? currentSpeed,
    int? fuelPercentage,
    bool? isDoorLocked,
    String? engineStatus,
    String? currentAddress,
    String? plateNumber,
  }) {
    return Vehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      vehicleClass: vehicleClass ?? this.vehicleClass,
      bodyType: bodyType ?? this.bodyType,
      year: year ?? this.year,
      engine: engine ?? this.engine,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      seatCount: seatCount ?? this.seatCount,
      luggageCount: luggageCount ?? this.luggageCount,
      isAvailable: isAvailable ?? this.isAvailable,
      rentalCompany: rentalCompany ?? this.rentalCompany,
      features: features ?? this.features,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      fuelPercentage: fuelPercentage ?? this.fuelPercentage,
      isDoorLocked: isDoorLocked ?? this.isDoorLocked,
      engineStatus: engineStatus ?? this.engineStatus,
      currentAddress: currentAddress ?? this.currentAddress,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }
}
