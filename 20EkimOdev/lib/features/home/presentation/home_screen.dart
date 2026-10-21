import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/fake_data.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vehicle_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _pickupLocation = FakeData.locations.first;
  String _dropoffLocation = FakeData.locations.first;
  bool _sameLocation = true;
  DateTime _pickupDate = DateTime.now().add(const Duration(days: 1));
  DateTime _dropoffDate = DateTime.now().add(const Duration(days: 4));

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.$y, $h:$min';
  }

  Future<void> _selectDateTime(bool isPickup) async {
    final initialDate = isPickup ? _pickupDate : _dropoffDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isPickup) {
            _pickupDate = newDateTime;
            if (_dropoffDate.isBefore(_pickupDate)) {
              _dropoffDate = _pickupDate.add(const Duration(days: 3));
            }
          } else {
            _dropoffDate = newDateTime;
          }
        });
      }
    }
  }

  void _showLocationDialog(bool isPickup) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.extraLarge),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPickup ? 'Alış Noktası Seçin' : 'İade Noktası Seçin',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...FakeData.locations.map((loc) {
                  return ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primarySeed,
                    ),
                    title: Text(loc),
                    onTap: () {
                      setState(() {
                        if (isPickup) {
                          _pickupLocation = loc;
                        } else {
                          _dropoffLocation = loc;
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final popularVehicles = FakeData.vehicles.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: const Icon(
                Icons.directions_car_filled,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'RotaRent',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hoş Geldiniz, Ahmet Yılmaz 👋',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.profile);
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Ana Menü Ayarları & Profil',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // 1. ÜSTTE: Kiralama Konumu ve Takvim Kartı
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: isDark
                    ? AppColors.darkCardBorder
                    : AppColors.lightCardBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tune,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'HIZLI KİRALAMA PLANLA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Kiralama Konumu Seçici
                InkWell(
                  onTap: () => _showLocationDialog(true),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkCardBorder
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primarySeed,
                          size: 22,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kiralama / Alış Konumu',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              Text(
                                _pickupLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                // İade yeri opsiyonu
                if (!_sameLocation) ...[
                  const SizedBox(height: AppSpacing.xs),
                  InkWell(
                    onTap: () => _showLocationDialog(false),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkCardBorder
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.orange,
                            size: 22,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'İade Konumu',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                                Text(
                                  _dropoffLocation,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Takvim (Alış ve İade Tarihleri)
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    // Alış Tarihi
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDateTime(true),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkCardBorder
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: AppColors.primarySeed,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Alış Tarihi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(_pickupDate),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    // İade Tarihi
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDateTime(false),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkCardBorder
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_available,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'İade Tarihi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(_dropoffDate),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Switch: Aynı konuma bırak
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Aracı aynı konuma teslim edeceğim',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    Switch(
                      value: _sameLocation,
                      onChanged: (val) {
                        setState(() {
                          _sameLocation = val;
                          if (val) _dropoffLocation = _pickupLocation;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xs),
                // Araçları Listele Butonu
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.rental);
                  },
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text('Uygun Araçları Bul'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 2. ORTADA: ARAÇ FİLOSU RESMİ & HERO GÖRSELİ
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.large),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primarySeed.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Arka plan araç filosu resmi - Yan yana duran araçlar
                Image.asset(
                  'assets/images/cars_side_by_side.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // Gradient karartma
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
                // Hero Yazıları & Filo Rozeti
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Text(
                          '⚡ 2024 - 2025 GENİŞ ARAÇ FİLOSU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Son Model & Hijyenik\nGeniş Araç Filomuz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '150+ SUV, Sedan, Elektrikli ve Lüks Araç',
                        style: TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 3. ALTINDA: İNDİRİM & KAMPANYALAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.large),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEA580C).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'YAZ SEZONUNA ÖZEL %25 İNDİRİM!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppRadius.small,
                              ),
                            ),
                            child: const Text(
                              'ROTA25',
                              style: TextStyle(
                                color: Color(0xFFEA580C),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Tüm 3 gün ve üzeri kiralamalarda anında geçerli indirim kodu!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Popüler Araçlar Bölümü Başlığı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popüler Araçlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {
                  ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.rental);
                },
                child: const Text('Tümünü Gör'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // Araç Kartları
          ...popularVehicles.map((vehicle) {
            return VehicleCard(
              vehicle: vehicle,
              onSelect: () {
                ref
                    .read(selectedVehicleForPaymentProvider.notifier)
                    .selectVehicle(vehicle);
                ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.payment);
              },
            );
          }),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
