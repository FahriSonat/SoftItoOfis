import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/fake_data.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/vehicle_card.dart';

class RentalScreen extends ConsumerStatefulWidget {
  const RentalScreen({super.key});

  @override
  ConsumerState<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends ConsumerState<RentalScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.extraLarge),
        ),
      ),
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, child) {
            final filterState = ref.watch(vehicleFilterProvider);
            final filterNotifier = ref.read(vehicleFilterProvider.notifier);
            final filteredVehicles = ref.watch(filteredVehiclesProvider);
            final theme = Theme.of(context);

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Handle Bar
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Sheet Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tune,
                                color: theme.colorScheme.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Detaylı Araç Filtreleri',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              filterNotifier.reset();
                            },
                            child: const Text('Tümünü Temizle'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Scrollable Filter Options
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        children: [
                          // 1. Marka Filtresi
                          _buildFilterHeader('Marka'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: FakeData.brands.map((brand) {
                                final isSelected = filterState.brand == brand;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: Text(brand),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      filterNotifier.setBrand(
                                        selected ? brand : 'Hepsi',
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 2. Sınıf Filtresi (Ekonomik, Konfor, Prestij, Lüks, SUV, Spor)
                          _buildFilterHeader('Sınıf'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: FakeData.classes.map((cls) {
                                final isSelected =
                                    filterState.vehicleClass == cls;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: Text(cls),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      filterNotifier.setVehicleClass(
                                        selected ? cls : 'Hepsi',
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 3. Cinsi / Kasa Tipi (Sedan, Hatchback, SUV, Coupe)
                          _buildFilterHeader('Cinsi (Kasa Tipi)'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: FakeData.bodyTypes.map((type) {
                                final isSelected = filterState.bodyType == type;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: FilterChip(
                                    label: Text(type),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      filterNotifier.setBodyType(
                                        selected ? type : 'Hepsi',
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 4 & 5. Şanzıman ve Yakıt (2 Kolon)
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFilterHeader('Şanzıman'),
                                    DropdownButtonFormField<String>(
                                      initialValue: filterState.transmission,
                                      isDense: true,
                                      items: FakeData.transmissions.map((t) {
                                        return DropdownMenuItem(
                                          value: t,
                                          child: Text(t),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          filterNotifier.setTransmission(val);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFilterHeader('Yakıt Türü'),
                                    DropdownButtonFormField<String>(
                                      initialValue: filterState.fuelType,
                                      isDense: true,
                                      items: FakeData.fuelTypes.map((f) {
                                        return DropdownMenuItem(
                                          value: f,
                                          child: Text(f),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          filterNotifier.setFuelType(val);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 6 & 7. Motor ve Üretim Yılı (2 Kolon)
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFilterHeader('Motor'),
                                    DropdownButtonFormField<String>(
                                      initialValue: filterState.engine,
                                      isDense: true,
                                      items: FakeData.engines.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          filterNotifier.setEngine(val);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFilterHeader('Üretim Yılı (En Az)'),
                                    DropdownButtonFormField<int>(
                                      initialValue: filterState.minYear,
                                      isDense: true,
                                      items: FakeData.years.map((y) {
                                        return DropdownMenuItem(
                                          value: y,
                                          child: Text(
                                            y == 0 ? 'Hepsi' : '$y ve Üzeri',
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          filterNotifier.setMinYear(val);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 8. Fiyat Aralığı Slider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFilterHeader('Maksimum Günlük Fiyat'),
                              Text(
                                '₺${filterState.maxPrice.toInt()} / gün',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: filterState.maxPrice,
                            min: 800,
                            max: 10000,
                            divisions: 46,
                            label: '₺${filterState.maxPrice.toInt()}',
                            onChanged: (val) => filterNotifier.setMaxPrice(val),
                          ),
                        ],
                      ),
                    ),

                    // Sheet Bottom Action Button
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: FilledButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.medium,
                              ),
                            ),
                          ),
                          child: Text(
                            'Sonuçları Göster (${filteredVehicles.length} Araç)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filterState = ref.watch(vehicleFilterProvider);
    final filterNotifier = ref.read(vehicleFilterProvider.notifier);
    final filteredVehicles = ref.watch(filteredVehiclesProvider);
    final activeCount = filterState.activeFilterCount;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Ana Sayfaya Dön',
          onPressed: () {
            ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.home);
          },
        ),
        title: const Text('Araç Kiralama'),
        actions: [
          if (activeCount > 0)
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                filterNotifier.reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tüm filtreler sıfırlandı'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Sıfırla'),
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. ÜST ARAMA VE FİLTRELEME ÇUBUĞU
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.lightCardBorder,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arama Kutusu ve "Filtrele" Butonu
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => filterNotifier.setModelQuery(val),
                        decoration: InputDecoration(
                          hintText: 'Araç markası veya modeli ara...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    filterNotifier.setModelQuery('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Filtrele Butonu (Aktif Sayaç Rozetli)
                    FilledButton.tonalIcon(
                      onPressed: () => _openFilterSheet(context),
                      icon: Icon(
                        activeCount > 0
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                        size: 18,
                      ),
                      label: Text(
                        activeCount > 0 ? 'Filtre ($activeCount)' : 'Filtrele',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Hızlı Kasa Tipi & Özellik Çipleri (Tümü, SUV, Sedan, Coupe, Otomatik, vb.)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // "Tümü" Hızlı Çipi
                      ChoiceChip(
                        label: const Text('Tümü'),
                        selected:
                            filterState.bodyType == 'Hepsi' &&
                            filterState.vehicleClass == 'Hepsi',
                        onSelected: (_) {
                          filterNotifier.setBodyType('Hepsi');
                          filterNotifier.setVehicleClass('Hepsi');
                        },
                      ),
                      const SizedBox(width: 6),
                      // SUV Çipi
                      ChoiceChip(
                        label: const Text('🚙 SUV'),
                        selected: filterState.bodyType == 'SUV',
                        onSelected: (selected) {
                          filterNotifier.setBodyType(
                            selected ? 'SUV' : 'Hepsi',
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      // Sedan Çipi
                      ChoiceChip(
                        label: const Text('🚗 Sedan'),
                        selected: filterState.bodyType == 'Sedan',
                        onSelected: (selected) {
                          filterNotifier.setBodyType(
                            selected ? 'Sedan' : 'Hepsi',
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      // Coupe / Spor Çipi
                      ChoiceChip(
                        label: const Text('🏎️ Spor / Coupe'),
                        selected:
                            filterState.bodyType == 'Coupe' ||
                            filterState.vehicleClass == 'Spor',
                        onSelected: (selected) {
                          filterNotifier.setVehicleClass(
                            selected ? 'Spor' : 'Hepsi',
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      // Otomatik Vites Çipi
                      FilterChip(
                        label: const Text('⚙️ Otomatik'),
                        selected: filterState.transmission == 'Otomatik',
                        onSelected: (selected) {
                          filterNotifier.setTransmission(
                            selected ? 'Otomatik' : 'Hepsi',
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      // Elektrikli Çipi
                      FilterChip(
                        label: const Text('⚡ Elektrikli'),
                        selected: filterState.fuelType == 'Elektrik',
                        onSelected: (selected) {
                          filterNotifier.setFuelType(
                            selected ? 'Elektrik' : 'Hepsi',
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Aktif Filtre Rozetleri (Varsa göster: "BMW ✕", "Dizel ✕" vb.)
                if (activeCount > 0) ...[
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'Aktif: ',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        if (filterState.brand != 'Hepsi')
                          _buildRemovableChip(
                            filterState.brand,
                            () => filterNotifier.setBrand('Hepsi'),
                          ),
                        if (filterState.vehicleClass != 'Hepsi')
                          _buildRemovableChip(
                            filterState.vehicleClass,
                            () => filterNotifier.setVehicleClass('Hepsi'),
                          ),
                        if (filterState.bodyType != 'Hepsi')
                          _buildRemovableChip(
                            filterState.bodyType,
                            () => filterNotifier.setBodyType('Hepsi'),
                          ),
                        if (filterState.transmission != 'Hepsi')
                          _buildRemovableChip(
                            filterState.transmission,
                            () => filterNotifier.setTransmission('Hepsi'),
                          ),
                        if (filterState.fuelType != 'Hepsi')
                          _buildRemovableChip(
                            filterState.fuelType,
                            () => filterNotifier.setFuelType('Hepsi'),
                          ),
                        if (filterState.engine != 'Hepsi')
                          _buildRemovableChip(
                            filterState.engine,
                            () => filterNotifier.setEngine('Hepsi'),
                          ),
                        if (filterState.minYear > 0)
                          _buildRemovableChip(
                            '${filterState.minYear}+',
                            () => filterNotifier.setMinYear(0),
                          ),
                        if (filterState.maxPrice < 10000)
                          _buildRemovableChip(
                            '≤ ₺${filterState.maxPrice.toInt()}',
                            () => filterNotifier.setMaxPrice(10000),
                          ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 6),

                // Sonuç Sayısı ve Bilgi Satırı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredVehicles.length} Araç Listeleniyor',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => _openFilterSheet(context),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tüm Filtreler',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. DOĞRUDAN VE HEMEN GÖRÜNÜR ARAÇ LİSTESİ (EXPANDED LISTVIEW)
          Expanded(
            child: filteredVehicles.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const Text(
                            'Filtreye Uygun Araç Bulunamadı',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Seçtiğiniz filtre kombinasyonuna uygun araç bulunmuyor. Filtreleri sıfırlayarak tüm araçları görebilirsiniz.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          FilledButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              filterNotifier.reset();
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Filtreleri Sıfırla'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = filteredVehicles[index];
                      return VehicleCard(
                        vehicle: vehicle,
                        onSelect: () {
                          ref
                              .read(selectedVehicleForPaymentProvider.notifier)
                              .selectVehicle(vehicle);
                          ref
                              .read(bottomNavIndexProvider.notifier)
                              .setIndex(NavIndex.payment);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${vehicle.fullName} seçildi. Ödeme ekranına yönlendiriliyorsunuz.',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemovableChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 10)),
        deleteIcon: const Icon(Icons.close, size: 12),
        onDeleted: onDeleted,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
