import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_controller.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeVehicle = ref.watch(activeRentalVehicleProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Ana Sayfaya Dön',
          onPressed: () {
            ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.home);
          },
        ),
        title: const Text('Hesabım ve Ayarlar'),
        actions: [
          IconButton(
            onPressed: () {
              _tabController.animateTo(3); // 3: Hesap Ayarları & Tema sekmesi
            },
            icon: const Icon(Icons.tune),
            tooltip: 'Ayarlar Sekmesine Git',
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    // Kullanıcı Kartı
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF1E293B),
                                  const Color(0xFF0F172A),
                                ]
                              : [
                                  AppColors.primarySeed,
                                  const Color(0xFF1E3BB0),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.large),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primarySeed.withValues(
                              alpha: 0.25,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.white24,
                                child: CircleAvatar(
                                  radius: 31,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                                      width: 62,
                                      height: 62,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.person,
                                                size: 36,
                                                color: AppColors.primarySeed,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Ahmet Yılmaz',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.small,
                                        ),
                                      ),
                                      child: const Text(
                                        'Gold Üye',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'demo@rotarent.com',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '+90 (532) 555 01 23',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 6 Ana Kategori Segmentli Tab Bar:
                    // aktif kiralamalar, önceki kiralamalar, ödeme bilgileri, hesap ayarları, indirimler, sss
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: theme.colorScheme.primary,
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      tabs: const [
                        Tab(icon: Icon(Icons.car_rental), text: 'Aktif'),
                        Tab(icon: Icon(Icons.history), text: 'Önceki'),
                        Tab(icon: Icon(Icons.payment), text: 'Ödeme Bilgileri'),
                        Tab(
                          icon: Icon(Icons.manage_accounts),
                          text: 'Hesap Ayarları',
                        ),
                        Tab(icon: Icon(Icons.discount), text: 'İndirimler'),
                        Tab(icon: Icon(Icons.help_outline), text: 'SSS'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // 1. AKTİF KİRALAMALAR
            _buildActiveRentalsTab(activeVehicle, theme, isDark),

            // 2. ÖNCEKİ KİRALAMALAR
            _buildPastRentalsTab(isDark),

            // 3. ÖDEME BİLGİLERİ
            _buildPaymentMethodsTab(isDark),

            // 4. HESAP AYARLARI & TEMA
            _buildAccountSettingsTab(currentThemeMode, theme, isDark),

            // 5. İNDİRİMLER & KUPONLAR
            _buildDiscountsTab(isDark),

            // 6. SSS (SIKÇA SORULAN SORULAR)
            _buildFaqTab(isDark),
          ],
        ),
      ),
    );
  }

  // 1. AKTİF KİRALAMALAR SEKMESİ
  Widget _buildActiveRentalsTab(
    dynamic activeVehicle,
    ThemeData theme,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: AppColors.primarySeed.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primarySeed.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 8),
                        SizedBox(width: 4),
                        Text(
                          'AKTİF KİRALAMA',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Kod: #RTR-98214',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: activeVehicle.imageUrl.startsWith('assets/')
                        ? Image.asset(
                            activeVehicle.imageUrl,
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
                            activeVehicle.imageUrl,
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
                        Text(
                          activeVehicle.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Plaka: ${activeVehicle.plateNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Kalan Süre: 2 Gün 6 Saat',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primarySeed,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      activeVehicle.currentAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // BUTON: CANLI GPS EKRANINA GİT
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.gps);
                },
                icon: const Icon(Icons.radar, size: 18),
                label: const Text('Aracımı Haritada Canlı Takip Et 📍'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. ÖNCEKİ KİRALAMALAR SEKMESİ
  Widget _buildPastRentalsTab(bool isDark) {
    final pastRentals = [
      {
        'car': 'Renault Megane Sedan',
        'plate': '34 RTR 1923',
        'dates': '12 - 15 Eylül 2026 (3 Gün)',
        'price': '₺4.350',
        'status': 'Başarıyla Tamamlandı',
      },
      {
        'car': 'Fiat Egea Cross',
        'plate': '34 EGE 2022',
        'dates': '02 - 06 Ağustos 2026 (4 Gün)',
        'price': '₺3.800',
        'status': 'Başarıyla Tamamlandı',
      },
      {
        'car': 'Volkswagen Passat',
        'plate': '34 VWP 2022',
        'dates': '18 - 20 Temmuz 2026 (2 Gün)',
        'price': '₺4.200',
        'status': 'Başarıyla Tamamlandı',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: pastRentals.length,
      itemBuilder: (context, index) {
        final item = pastRentals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['car']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      item['price']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primarySeed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['dates']} • ${item['plate']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['status']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item['car']} faturası indiriliyor...',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, size: 14),
                      label: const Text(
                        'Fatura',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. ÖDEME BİLGİLERİ SEKMESİ
  Widget _buildPaymentMethodsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Text(
          'Kayıtlı Kredi & Banka Kartları',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildCardItem(
          'Garanti BBVA Bonus Platinum',
          '•••• •••• •••• 4821',
          '08/28',
          true,
          isDark,
        ),
        _buildCardItem(
          'İş Bankası Maximum',
          '•••• •••• •••• 1092',
          '11/27',
          false,
          isDark,
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kart ekleme modülü açılıyor')),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Yeni Kart Ekle'),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Kayıtlı Fatura Adresi',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.home_work_outlined,
                      size: 18,
                      color: AppColors.primarySeed,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ev & Şahıs Adresi',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Fenerbahçe Mah. Lale Sk. No: 18 D: 4, Kadıköy / İstanbul\nTCKN: 10982348192',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardItem(
    String name,
    String number,
    String expiry,
    bool isDefault,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: const Icon(Icons.credit_card, color: AppColors.primarySeed),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '$number • Son Kul: $expiry',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: isDefault
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Text(
                  'Varsayılan',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  // 4. HESAP AYARLARI & TEMA
  Widget _buildAccountSettingsTab(
    ThemeMode currentThemeMode,
    ThemeData theme,
    bool isDark,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Tema Seçimi Kartı (design.md & project.md zorunlu şartı)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.palette_outlined, color: AppColors.primarySeed),
                    SizedBox(width: 8),
                    Text(
                      'Görünüm ve Tema',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Material 3 Açık, Koyu veya Sistem temasını anında seçin.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Sistem'),
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Açık'),
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Koyu'),
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {currentThemeMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setMode(newSelection.first);
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Profil & Güvenlik Ayarları
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Kişisel Bilgileri Düzenle'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Şifre ve Güvenlik'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Bildirim Tercihleri'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Çıkış Yap',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 5. İNDİRİMLER & KUPONLAR SEKMESİ
  Widget _buildDiscountsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Kupon Kodu Ekle
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                decoration: const InputDecoration(
                  hintText: 'İndirim Kupon Kodu Girin...',
                  prefixIcon: Icon(Icons.discount_outlined),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            ElevatedButton(
              onPressed: () {
                if (_couponController.text.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kupon uygulandı: ${_couponController.text.toUpperCase()}',
                      ),
                    ),
                  );
                  _couponController.clear();
                }
              },
              child: const Text('Uygula'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'Kullanılabilir İndirimleriniz',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.xs),
        _buildCouponCard(
          'ROTA25',
          'Tüm Araçlarda %25 İndirim',
          '3 gün ve üzeri kiralamalarda geçerlidir.',
          'Son Kullanma: 31.12.2026',
          Colors.orange,
        ),
        _buildCouponCard(
          'HOSGELDIN250',
          'İlk Kiralamaya Özel 250 ₺ Hediye',
          'Tüm araç modellerinde anında 250 TL indirim sağlar.',
          'Son Kullanma: 15.11.2026',
          AppColors.primarySeed,
        ),
        _buildCouponCard(
          'HAFTASONU15',
          'Hafta Sonu Kaçamağı %15 İndirim',
          'Cuma-Pazar arası tüm SUV kiralamalarında geçerlidir.',
          'Son Kullanma: Süresiz',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildCouponCard(
    String code,
    String title,
    String subtitle,
    String expiry,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expiry,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. SSS (SIKÇA SORULAN SORULAR) SEKMESİ
  Widget _buildFaqTab(bool isDark) {
    final faqs = [
      {
        'q': 'Araç kiralamak için hangi belgeler gereklidir?',
        'a': 'En az 2 yıllık geçerli T.C. veya uluslararası B sınıfı sürücü belgesi, kimlik kartı / pasaport ve adınıza düzenlenmiş bir kredi kartı gereklidir.',
      },
      {
        'q': 'Depozito / provizyon tutarı ne zaman iade edilir?',
        'a': 'Kiralama bitiminde aracın eksiksiz ve hasarsız teslim edilmesini takiben, trafik cezası ve HGS/OGS geçiş kontrolleri yapıldıktan sonra provizyon tutarı 3-7 iş günü içerisinde bankanıza iade edilir.',
      },
      {
        'q': 'Kilometre sınırı var mıdır?',
        'a': 'Tüm araçlarımızda günlük 350 km kullanım hakkı bulunmaktadır. Aşım yapılması durumunda kilometre başına 3,50 ₺ ek ücretlendirme uygulanır.',
      },
      {
        'q': 'Aracı farklı bir ofise veya şehre iade edebilir miyim?',
        'a': 'Evet, rezervasyon sırasında iade noktasını farklı bir havalimanı veya şehir ofisimiz olarak seçebilirsiniz. Mesafeye göre tek yön bırakma ücreti sisteme otomatik yansıtılır.',
      },
      {
        'q': 'Kaza veya arıza anında ne yapmalıyım?',
        'a': 'Aracı hareket ettirmeden 7/24 Acil Yol Yardım hattımızı (0850 555 7682) arayınız. Kaza halinde mutlaka polis/jandarma tutanağı ve alkol raporu tutulmalıdır.',
      },
      {
        'q': 'Aracın canlı GPS takibini nasıl izleyebilirim?',
        'a': 'Uygulamamızın en sağındaki Harita / GPS sekmesine tıklayarak veya Aktif Kiralamalar sekmesindeki "Aracımı Canlı Takip Et" butonuna basarak aracınızın anlık konumunu, hızını ve telemetrisini 7/24 takip edebilirsiniz.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: ExpansionTile(
            leading: const Icon(
              Icons.help_outline,
              color: AppColors.primarySeed,
              size: 20,
            ),
            title: Text(
              faq['q']!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  faq['a']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
