import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../booking/domain/booking_price.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController(text: 'Ahmet Yılmaz');
  final _cardNumberController = TextEditingController(
    text: '5421 8934 1029 4821',
  );
  final _expiryController = TextEditingController(text: '08/28');
  final _cvvController = TextEditingController(text: '482');

  int _rentalDays = 3;
  bool _agreedToObligations = false;
  bool _use3DSecure = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToObligations) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lütfen kiralama yükümlülüklerini ve sözleşmeyi onaylayınız.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate safe payment authorization
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    final selectedVehicle = ref.read(selectedVehicleForPaymentProvider);

    // Set the booked vehicle as the active rented vehicle for GPS tracking!
    ref
        .read(activeRentalVehicleProvider.notifier)
        .setActiveVehicle(selectedVehicle);

    // Show booking success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 56,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Ödeme Başarılı!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Rezervasyon Kodunuz: #RTR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primarySeed,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${selectedVehicle.fullName} aracınız başarıyla kiralandı. Canlı GPS haritasından aracınızın anlık konumunu takip edebilirsiniz.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'Aracımı GPS ile Takip Et 📍',
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.gps);
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.home);
                },
                child: const Text('Ana Sayfaya Dön'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vehicle = ref.watch(selectedVehicleForPaymentProvider);

    const priceCalculator = BookingPriceCalculator();
    final price = priceCalculator.calculate(
      dailyRate: vehicle.dailyPrice,
      dayCount: _rentalDays,
    );
    final subtotal = price.subtotal;
    final insuranceFee = price.insuranceFee;
    final serviceFee = price.serviceFee;
    final total = price.total;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Ana Sayfaya Dön',
          onPressed: () {
            ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.home);
          },
        ),
        title: const Text('Ödeme ve Rezervasyon'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Seçili Araç Özeti Kartı
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : AppColors.lightCardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: vehicle.imageUrl.startsWith('assets/')
                          ? Image.asset(
                              vehicle.imageUrl,
                              width: 90,
                              height: 65,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 90,
                                    height: 65,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.directions_car),
                                  ),
                            )
                          : Image.network(
                              vehicle.imageUrl,
                              width: 90,
                              height: 65,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 90,
                                    height: 65,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.directions_car),
                                  ),
                            ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.small,
                                  ),
                                ),
                                child: Text(
                                  vehicle.vehicleClass,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${vehicle.year}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vehicle.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '₺${vehicle.dailyPrice} / gün',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gün Değiştirici
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_rentalDays > 1) {
                                setState(() => _rentalDays--);
                              }
                            },
                            child: const Icon(Icons.remove, size: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '$_rentalDays Gün',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_rentalDays < 30) {
                                setState(() => _rentalDays++);
                              }
                            },
                            child: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 2. KART BİLGİLERİ BÖLÜMÜ
              Row(
                children: [
                  const Icon(Icons.credit_card, color: AppColors.primarySeed),
                  const SizedBox(width: AppSpacing.xs),
                  const Text(
                    'Kredi / Banka Kartı Bilgileri',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Kart Görünümü Simülasyonu
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.nfc, color: Colors.white70, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'RotaRent Card',
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/200px-Mastercard-logo.svg.png',
                          height: 28,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.credit_card,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      _cardNumberController.text.isEmpty
                          ? '•••• •••• •••• ••••'
                          : _cardNumberController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'KART SAHİBİ',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 9,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              _cardHolderController.text.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'SON KULLANMA',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 9,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              _expiryController.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Kart Sahibi Adı
              TextFormField(
                controller: _cardHolderController,
                decoration: const InputDecoration(
                  labelText: 'Kart Üzerindeki İsim',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen kart sahibinin adını giriniz';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Kart Numarası
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Kart Numarası',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.replaceAll(' ', '').length < 16) {
                    return 'Geçerli bir 16 haneli kart numarası giriniz';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Expiry & CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Son Kullanma (AA/YY)',
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (val) {
                        if (val == null || val.length < 4) {
                          return 'Geçersiz tarih';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV / CVC',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                      validator: (val) {
                        if (val == null || val.length < 3) {
                          return '3 haneli CVV giriniz';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // 3D Secure Seçeneği
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _use3DSecure,
                onChanged: (val) => setState(() => _use3DSecure = val ?? true),
                title: const Text(
                  '3D Secure ile güvenli ödeme yap',
                  style: TextStyle(fontSize: 13),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: AppSpacing.md),

              // 3. KİRALAMA YÜKÜMLÜLÜKLERİ BÖLÜMÜ
              Row(
                children: [
                  const Icon(Icons.gavel, color: Colors.orange),
                  const SizedBox(width: AppSpacing.xs),
                  const Text(
                    'Kiralama Yükümlülükleri ve Şartlar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : const Color(0xFFFDE68A),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildObligationItem(
                      Icons.badge,
                      'Yaş ve Ehliyet Kriteri',
                      'Kiracının en az 21 yaşında ve minimum 2 yıllık geçerli B sınıfı ehliyete sahip olması zorunludur.',
                    ),
                    const SizedBox(height: 8),
                    _buildObligationItem(
                      Icons.speed,
                      'Kilometre Sınırı',
                      'Günlük kullanım hakkı 350 km ile sınırlıdır. Aşım durumunda km başına 3.50 ₺ ek ücret tahsil edilir.',
                    ),
                    const SizedBox(height: 8),
                    _buildObligationItem(
                      Icons.local_gas_station,
                      'Yakıt Politikası',
                      'Araç teslim alındığı yakıt/şarj seviyesinde iade edilmelidir. Eksik yakıt servis ücretiyle yansıtılır.',
                    ),
                    const SizedBox(height: 8),
                    _buildObligationItem(
                      Icons.security,
                      'Hasar & Kasko Prosedürü',
                      'Kaza veya hasar durumunda polis tutanağı ve alkol raporu 24 saat içinde şirketimize ulaştırılmalıdır.',
                    ),
                    const SizedBox(height: 8),
                    _buildObligationItem(
                      Icons.event_busy,
                      'Ücretsiz İptal Garantisi',
                      'Kiralama başlangıç saatinden 24 saat öncesine kadar yapılan iptallerde %100 kesintisiz para iadesi sağlanır.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Yükümlülükleri Kabul Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _agreedToObligations,
                onChanged: (val) =>
                    setState(() => _agreedToObligations = val ?? false),
                title: const Text(
                  'Yukarıdaki kiralama yükümlülüklerini, sözleşmeyi ve KVKK metnini okudum, kabul ediyorum.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: AppSpacing.md),

              // 4. ŞEFFAF ÜCRET DÖKÜMÜ
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkCardBorder
                        : AppColors.lightCardBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Şeffaf Ücret Dökümü',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildPriceRow(
                      'Araç Kiralama Bedeli ($_rentalDays Gün)',
                      '₺$subtotal',
                    ),
                    _buildPriceRow(
                      'Tam Kapsamlı Muafiyetsiz Kasko',
                      '₺$insuranceFee',
                    ),
                    _buildPriceRow(
                      'Hizmet & Hijyenik Hazırlık',
                      '₺$serviceFee',
                    ),
                    _buildPriceRow(
                      'Kampanya İndirimi (ROTA25)',
                      '-₺300',
                      isDiscount: true,
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOPLAM TUTAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '₺$total',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 5. GÜVENLİ ÖDEME BUTONU
              AppButton(
                text: '₺$total Güvenli Ödeme Yap ve Kirala',
                icon: Icons.lock,
                isLoading: _isSubmitting,
                onPressed: _processPayment,
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObligationItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.orange.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String title,
    String amount, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
