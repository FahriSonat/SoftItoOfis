#!/usr/bin/env bash

# ==============================================================================
# Flutter Feature Scaffold Generator
# SKILL.md ve project.md standartlarına uygun modüler feature iskeleti üretir.
#
# Kullanım:
#   ./generate_feature.sh <feature_name>
#   Örnek: ./generate_feature.sh water_tracking
# ==============================================================================

set -e

# Renk tanımları
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parametre kontrolü
if [ -z "$1" ]; then
    echo -e "${RED}Hata: Özellik (feature) adı belirtilmedi!${NC}"
    echo -e "Kullanım: $0 <feature_name>"
    echo -e "Örnek: $0 water_tracking"
    exit 1
fi

RAW_NAME="$1"

# snake_case standardına çevirme (küçük harf ve alt çizgi)
FEATURE_NAME=$(echo "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_' | sed 's/[^a-z0-9_]//g')

# PascalCase formatı (Örn: water_tracking -> WaterTracking)
PASCAL_NAME=$(echo "$FEATURE_NAME" | awk -F_ '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1)) substr($i,2); print ""}')

# Title Case formatı (Örn: water_tracking -> Water Tracking)
TITLE_NAME=$(echo "$FEATURE_NAME" | awk -F_ '{for(i=1;i<=NF;i++) printf (i==1?"":" ") toupper(substr($i,1,1)) substr($i,2); print ""}')

echo -e "${BLUE}🚀 '${TITLE_NAME}' (${FEATURE_NAME}) modülü oluşturuluyor...${NC}"

# Proje kök dizinini belirleme (lib klasörünün olduğu yer)
PROJECT_ROOT="."
if [ ! -d "lib" ] && [ -d "../../lib" ]; then
    PROJECT_ROOT="../.."
elif [ ! -d "lib" ] && [ -d "../../../lib" ]; then
    PROJECT_ROOT="../../.."
fi

FEATURE_DIR="${PROJECT_ROOT}/lib/features/${FEATURE_NAME}"
TEST_DIR="${PROJECT_ROOT}/test/features/${FEATURE_NAME}"

# Klasör yapısını oluşturma (SKILL.md Adım 1)
mkdir -p "${FEATURE_DIR}/controllers"
mkdir -p "${FEATURE_DIR}/models"
mkdir -p "${FEATURE_DIR}/views"
mkdir -p "${FEATURE_DIR}/widgets"
mkdir -p "${TEST_DIR}"

echo -e "${GREEN}📁 Klasör yapısı hazırlandı:${NC} ${FEATURE_DIR}"

# 1. Controller Dosyası (SKILL.md Adım 2 - ValueNotifier tabanlı reaktif state)
cat <<EOF > "${FEATURE_DIR}/controllers/${FEATURE_NAME}_controller.dart"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// [${PASCAL_NAME}Controller]
/// ${TITLE_NAME} ekranı için iş mantığı ve reaktif State (ValueNotifier) yöneticisi.
/// Clean UI kuralı gereğince sayfa üzerinde setState kullanımını engeller.
class ${PASCAL_NAME}Controller {
  /// Ana veri modeli için reaktif bildirimci
  final ValueNotifier<${PASCAL_NAME}Model> state;

  /// Yükleniyor durumu için bildirimci
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  ${PASCAL_NAME}Controller({${PASCAL_NAME}Model? initialState})
      : state = ValueNotifier<${PASCAL_NAME}Model>(
          initialState ?? const ${PASCAL_NAME}Model(),
        );

  /// Veriyi günceller
  void updateData({
    String? title,
    int? count,
  }) {
    state.value = state.value.copyWith(
      title: title,
      count: count,
    );
  }

  /// Sayaç değerini artırır
  void increment() {
    state.value = state.value.copyWith(
      count: state.value.count + 1,
    );
  }

  /// Verileri sıfırlar
  void reset() {
    state.value = const ${PASCAL_NAME}Model();
  }

  /// Bellek sızıntılarını önlemek için ValueNotifier dinleyicilerini serbest bırakır
  void dispose() {
    state.dispose();
    isLoading.dispose();
  }
}
EOF

# 2. Model Dosyası (SKILL.md Adım 3 - Immutable, copyWith, fromJson, toJson)
cat <<EOF > "${FEATURE_DIR}/models/${FEATURE_NAME}_model.dart"
import 'package:flutter/foundation.dart';

/// [${PASCAL_NAME}Model]
/// ${TITLE_NAME} modülü için veri modeli.
/// Değişmez (immutable) yapıda tasarlanmıştır.
@immutable
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final int count;

  const ${PASCAL_NAME}Model({
    this.id = '',
    this.title = '${TITLE_NAME}',
    this.count = 0,
  });

  /// Modeli kopyalayıp belirli alanları güncelleyerek yeni kopya üretir
  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    int? count,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      count: count ?? this.count,
    );
  }

  /// JSON haritasından model üretir
  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '${TITLE_NAME}',
      count: json['count'] as int? ?? 0,
    );
  }

  /// Modeli JSON formatına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'count': count,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${PASCAL_NAME}Model &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          count == other.count;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ count.hashCode;
}
EOF

# 3. View Dosyası (SKILL.md Adım 4 - StatelessWidget ve ValueListenableBuilder)
cat <<EOF > "${FEATURE_DIR}/views/${FEATURE_NAME}_view.dart"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widgets/${FEATURE_NAME}_card.dart';

/// [${PASCAL_NAME}View]
/// ${TITLE_NAME} ekranının arayüz (UI) katmanı.
/// StatelessWidget kullanır ve durumu ValueListenableBuilder ile dinler.
class ${PASCAL_NAME}View extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;

  ${PASCAL_NAME}View({
    super.key,
    ${PASCAL_NAME}Controller? controller,
  }) : controller = controller ?? ${PASCAL_NAME}Controller();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${TITLE_NAME}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<${PASCAL_NAME}Model>(
          valueListenable: controller.state,
          builder: (context, state, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ${PASCAL_NAME}Card(
                    title: state.title,
                    subtitle: 'Güncel Değer: \${state.count}',
                    onTap: controller.increment,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: controller.increment,
                    icon: const Icon(Icons.add),
                    label: const Text('Artır (+1)'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: controller.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Sıfırla'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF

# 4. Widget Dosyası (SKILL.md Adım 5 - Modüler StatelessWidget kart bileşeni)
cat <<EOF > "${FEATURE_DIR}/widgets/${FEATURE_NAME}_card.dart"
import 'package:flutter/material.dart';

/// [${PASCAL_NAME}Card]
/// ${TITLE_NAME} modülü için tekrar kullanılabilir kart bileşeni.
/// Material 3 tasarım diline ve const kurallarına uygundur.
class ${PASCAL_NAME}Card extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

# 5. Unit Test İskeleti (SKILL.md gereksinimi: Birim test iskeleti)
cat <<EOF > "${TEST_DIR}/${FEATURE_NAME}_controller_test.dart"
import 'package:flutter_test/flutter_test.dart';
import 'package:lib/features/${FEATURE_NAME}/controllers/${FEATURE_NAME}_controller.dart';
import 'package:lib/features/${FEATURE_NAME}/models/${FEATURE_NAME}_model.dart';

void main() {
  group('${PASCAL_NAME}Controller Tests', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan değerlerle başlatılmalıdır', () {
      expect(controller.state.value.count, 0);
      expect(controller.state.value.title, '${TITLE_NAME}');
    });

    test('increment çağrıldığında count değeri 1 artmalıdır', () {
      controller.increment();
      expect(controller.state.value.count, 1);
    });

    test('reset çağrıldığında varsayılan duruma dönmelidir', () {
      controller.increment();
      controller.reset();
      expect(controller.state.value.count, 0);
    });
  });
}
EOF

echo -e "${GREEN}✅ Başarıyla üretilen dosyalar:${NC}"
echo -e "  📄 ${FEATURE_DIR}/controllers/${FEATURE_NAME}_controller.dart"
echo -e "  📄 ${FEATURE_DIR}/models/${FEATURE_NAME}_model.dart"
echo -e "  📄 ${FEATURE_DIR}/views/${FEATURE_NAME}_view.dart"
echo -e "  📄 ${FEATURE_DIR}/widgets/${FEATURE_NAME}_card.dart"
echo -e "  🧪 ${TEST_DIR}/${FEATURE_NAME}_controller_test.dart"
echo -e "${YELLOW}🎉 Modül iskeleti SKILL.md kurallarına tam uyumlu olarak tamamlandı!${NC}"
