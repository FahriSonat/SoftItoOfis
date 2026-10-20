import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/fake_data.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';

class GpsScreen extends ConsumerStatefulWidget {
  const GpsScreen({super.key});

  @override
  ConsumerState<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends ConsumerState<GpsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isDoorLocked = true;
  bool _isHornBeeping = false;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 2.4,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleDoorLock() {
    setState(() {
      _isDoorLocked = !_isDoorLocked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isDoorLocked
              ? 'Araç kapıları kilitlendi 🔒'
              : 'Araç kapılarının kilidi açıldı 🔓',
        ),
        backgroundColor: _isDoorLocked ? AppColors.primarySeed : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _beepHorn() async {
    setState(() {
      _isHornBeeping = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Flaşörler yakıldı ve uyarı sinyali gönderildi 🚨'),
        duration: Duration(seconds: 2),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isHornBeeping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vehicle = ref.watch(activeRentalVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı GPS Araç Takibi'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('GPS Sinyali Güncellendi (Hassasiyet: 1.8m)'),
                ),
              );
            },
            icon: const Icon(Icons.my_location),
            tooltip: 'Konumumu Bul',
          ),
          PopupMenuButton<Vehicle>(
            icon: const Icon(Icons.alt_route),
            tooltip: 'Farklı Araç Seç',
            onSelected: (selected) {
              ref
                  .read(activeRentalVehicleProvider.notifier)
                  .setActiveVehicle(selected);
            },
            itemBuilder: (context) {
              return FakeData.vehicles.map((v) {
                return PopupMenuItem(
                  value: v,
                  child: Text('${v.fullName} (${v.plateNumber})'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. İNTERAKTİF VEKTÖR HARİTA ÇİZİMİ
          Positioned.fill(
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  _zoomLevel = (_zoomLevel * details.scale).clamp(0.7, 2.0);
                });
              },
              child: CustomPaint(
                painter: MapPainter(isDark: isDark, zoomLevel: _zoomLevel),
              ),
            ),
          ),

          // 2. MERKEZDE: ARACIN CANLI GPS PIN'İ VE RADAR NABIZ ANİMASYONU
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dış Nabız Halkası
                    Container(
                      width: 80 * _pulseAnimation.value,
                      height: 80 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primarySeed.withValues(
                          alpha: (1.0 - (_pulseController.value)).clamp(
                            0.0,
                            0.4,
                          ),
                        ),
                      ),
                    ),
                    // Orta Nabız Halkası
                    Container(
                      width: 50 * _pulseAnimation.value * 0.7,
                      height: 50 * _pulseAnimation.value * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primarySeed.withValues(
                          alpha: (1.0 - (_pulseController.value)).clamp(
                            0.0,
                            0.6,
                          ),
                        ),
                      ),
                    ),
                    // Canlı Araç Pin İkonu
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isHornBeeping
                            ? Colors.amber
                            : AppColors.primarySeed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        _isHornBeeping
                            ? Icons.warning_amber_rounded
                            : Icons.directions_car_filled,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    // Pin Alt Etiketi
                    Positioned(
                      bottom: -28,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: Text(
                          vehicle.plateNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3. ÜST BİLGİ ROZETİ (GPS Canlı Bağlantı ve Harita Kontrolleri)
          Positioned(
            top: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Canlı Sinyal Rozeti
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'CANLI GPS (10 Hz)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                // Zoom Kontrolleri
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => setState(
                          () => _zoomLevel = (_zoomLevel + 0.2).clamp(0.7, 2.0),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () => setState(
                          () => _zoomLevel = (_zoomLevel - 0.2).clamp(0.7, 2.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. ALT TELEMETRİ VE EYLEM PANELİ (Draggable / Floating Card)
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.lightCardBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Araç Bilgisi ve Adres
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        child: vehicle.imageUrl.startsWith('assets/')
                            ? Image.asset(
                                vehicle.imageUrl,
                                width: 60,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 60,
                                      height: 44,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.directions_car,
                                        size: 20,
                                      ),
                                    ),
                              )
                            : Image.network(
                                vehicle.imageUrl,
                                width: 60,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 60,
                                      height: 44,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.directions_car,
                                        size: 20,
                                      ),
                                    ),
                              ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.fullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              vehicle.currentAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySeed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Text(
                          vehicle.plateNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primarySeed,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.sm),

                  // Telemetri Göstergeleri: Hız, Yakıt, Kilit, Motor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTelemetryItem(
                        Icons.speed,
                        '${vehicle.currentSpeed} km/s',
                        'Anlık Hız',
                        isDark,
                      ),
                      _buildTelemetryItem(
                        Icons.local_gas_station,
                        '%${vehicle.fuelPercentage}',
                        'Yakıt / Şarj',
                        isDark,
                      ),
                      _buildTelemetryItem(
                        _isDoorLocked ? Icons.lock : Icons.lock_open,
                        _isDoorLocked ? 'Kilitli' : 'Açık',
                        'Kapı Kilidi',
                        isDark,
                        color: _isDoorLocked ? Colors.green : Colors.orange,
                      ),
                      _buildTelemetryItem(
                        Icons.power_settings_new,
                        'Normal',
                        'Motor Durumu',
                        isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Hızlı Eylemler Butonları
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _toggleDoorLock,
                          icon: Icon(
                            _isDoorLocked ? Icons.lock_open : Icons.lock,
                            size: 18,
                          ),
                          label: Text(_isDoorLocked ? 'Kilidi Aç' : 'Kilitle'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _beepHorn,
                          icon: const Icon(Icons.volume_up, size: 18),
                          label: const Text('Flaşör / Korna'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Navigasyon Başlat Butonu
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${vehicle.currentAddress} konumuna rota hesaplandı. Navigasyon başlatılıyor.',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigation, size: 18),
                    label: const Text('Aracımın Yanına Rota Başlat 🗺️'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryItem(
    IconData icon,
    String value,
    String label,
    bool isDark, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              color ??
              (isDark ? AppColors.textSecondaryDark : AppColors.primarySeed),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

// Vektörel Harita Çizici (Kadıköy Sahil / Marmara Denizi / Caddeler)
class MapPainter extends CustomPainter {
  final bool isDark;
  final double zoomLevel;

  MapPainter({required this.isDark, required this.zoomLevel});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Zemin (Kara Parçası)
    final landPaint = Paint()
      ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFFE5E7EB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), landPaint);

    // 2. Deniz / Su Kütlesi (Marmara Denizi / Sahil hattı)
    final waterPaint = Paint()
      ..color = isDark ? const Color(0xFF032D60) : const Color(0xFF93C5FD);

    final waterPath = Path();
    waterPath.moveTo(0, size.height * 0.45);
    waterPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.52,
      size.width * 0.55,
      size.height * 0.75,
    );
    waterPath.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.9,
      size.width,
      size.height * 0.95,
    );
    waterPath.lineTo(size.width, size.height);
    waterPath.lineTo(0, size.height);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    // 3. Park ve Yeşil Alanlar (Fenerbahçe Parkı, Yoğurtçu Parkı)
    final parkPaint = Paint()
      ..color = isDark
          ? const Color(0xFF14532D).withValues(alpha: 0.6)
          : const Color(0xFFBBF7D0);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.1,
          size.height * 0.15,
          size.width * 0.3,
          size.height * 0.18,
        ),
        const Radius.circular(20),
      ),
      parkPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.6,
          size.height * 0.3,
          size.width * 0.25,
          size.height * 0.15,
        ),
        const Radius.circular(16),
      ),
      parkPaint,
    );

    // 4. Ana Caddeler ve Otoyollar
    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : Colors.white
      ..strokeWidth = 14 * zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)
      ..strokeWidth = 16 * zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Bağdat Caddesi (Ana Arter)
    final mainRoad = Path();
    mainRoad.moveTo(0, size.height * 0.35);
    mainRoad.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.45,
      size.width,
      size.height * 0.4,
    );
    canvas.drawPath(mainRoad, roadBorderPaint);
    canvas.drawPath(mainRoad, roadPaint);

    // Sahil Yolu
    final coastRoad = Path();
    coastRoad.moveTo(0, size.height * 0.55);
    coastRoad.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.62,
      size.width * 0.85,
      size.height * 0.95,
    );
    canvas.drawPath(coastRoad, roadBorderPaint);
    canvas.drawPath(coastRoad, roadPaint);

    // Dikey Bağlantı Caddeleri
    final secondaryRoadPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)
      ..strokeWidth = 7 * zoomLevel
      ..style = PaintingStyle.stroke;

    final crossPath1 = Path()
      ..moveTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.35, size.height * 0.55);
    canvas.drawPath(crossPath1, secondaryRoadPaint);

    final crossPath2 = Path()
      ..moveTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.7, size.height * 0.75);
    canvas.drawPath(crossPath2, secondaryRoadPaint);

    // 5. Cadde ve Mekan Yazıları
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    _drawMapLabel(
      canvas,
      textPainter,
      'Marmara Denizi',
      Offset(size.width * 0.15, size.height * 0.8),
      isDark ? Colors.white38 : Colors.blue.shade900,
    );
    _drawMapLabel(
      canvas,
      textPainter,
      'Bağdat Caddesi',
      Offset(size.width * 0.38, size.height * 0.39),
      isDark ? Colors.white70 : Colors.black87,
    );
    _drawMapLabel(
      canvas,
      textPainter,
      'Kadıköy Sahil Yolu',
      Offset(size.width * 0.25, size.height * 0.58),
      isDark ? Colors.white60 : Colors.black54,
    );
    _drawMapLabel(
      canvas,
      textPainter,
      '🌳 Kalamış Parkı',
      Offset(size.width * 0.12, size.height * 0.2),
      isDark ? Colors.greenAccent.shade100 : Colors.green.shade800,
    );
  }

  void _drawMapLabel(
    Canvas canvas,
    TextPainter tp,
    String text,
    Offset offset,
    Color color,
  ) {
    tp.text = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 10 * math.max(zoomLevel, 0.85),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.zoomLevel != zoomLevel;
  }
}
