name:flutter-feature-scaffold 
description: flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.

# Flutter feature scaffold (modüler ekran iskeleti) 
bu yetenek, projede yeni bir ekranda yada işlev modülü açarken Clean UI ve reaktif State kurallarına tam uyulmasını garanti altına alır.

##temel Kurallar 
1.**Asla tek dosyada toplama:**
UI (`_vier.dart`) State Controller (`_controller.dart`) ve model (`_model.dart`) katmanları her zaman ayrı dosyalarda üretilmelidir.

2.**State Yönetimi:**
Basit ve reaktif durumlar için `ValueNotifier` kullanılacaktır.
Doğrudan devasa StatefulWidgets yazarak işi karmaşıklaştırma.

3. **Const zorunluluğu:**
Mümkün olan tüm widgetlarda `const` olmalıdır.

## Adım adım uygulama akışı
## Adım 1 : Klasör yapısını oluşturma 

Hedeflenen modül adlarını (örn:`water_tracker`), `lib/features/<feature_name>` altına yapıyı kur

```text
lib/features/<feature_name>
    ├─ controllers/        # State yönetimi (ValueNotifier)
        ├─ <feature_name>_controller.dart
    ├─ models/             # Veri modelleri
        ├─ <feature_name>_model.dart
    ├─ views/             # UI katmanı (StatelessWidgets)
        ├─ <feature_name>_view.dart
    widgets/
        ├─ <feature_name>_card.dart    
        
```

### Adım 2 : Controller Dosysını Yaz
`controllers/<feature_name>_controller.dart` içinde mantığı `ValueNotifier` tanımları oluştur:

```dart 
import 'package:flutter/foundation.dart';

class WaterTrackerController  {
  
final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
final int dailyGoalWater = 2000;

void addWater() => currentWater.value += 250;
}
void addWater() {
    currentWater.value +=250;
}

void dispose() {
    currentWater.dispose();
}   

```

### Adım 3: Model Dosyasını Oluşturma 
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla:

```dart

class UserProfile{
    final String name;
    final String email;
    final String profileimage;
    final int level;
    final int coins;

    const UserProfile({
        required this.name,
        required this.email,
        required this.profileimage,
        required this.level,
        required this.coins,
    });

    UserProfile copyWith({
        String? name,
        String? email,
        String? profileimage,
        int? level,
        int? coins,
    }) {
        return UserProfile(
            name: name ?? this.name,
            email: email ?? this.email,
            profileimage: profileimage ?? this.profileimage,
            level: level ?? this.level,
            coins: coins ?? this.coins,
        );
    }

    factory UserProfile.fromJson(Map<String, dynamic> json) {
        return UserProfile(
            name: json['name'] ?? '',
            email: json['email'] ?? '',
            profileimage: json['profileimage'] ?? '',
            level: json['level'] ?? 0,
            coins: json['coins'] ?? 0,
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'name': name,
            'email': email,
            'profileimage': profileimage,
            'level': level,
            'coins': coins,
        };
    }
}

```

### Adım 4: UI View Dosyasını Yaz
`view/<feature_name>_view.dart` dosyasında `StatelessWidget` kullan UI katmanı oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/<feature_name>_controller.dart';

class <FeatureName>View extends StatelessWidget {
    final <FeatureName>Controller _controller = <FeatureName>Controller();

    <Feature_name>View({Key? key}): super(key: key);
    

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Flutter Feature Scaffold'),
                body: ValueListenableBuilder<int>(
                    valueListenable: _controller.currentWater,
                    builder: (context, currentWater, _) {
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text('Current water: $currentWater ml', 
                                    style: const TextStyle(fontSize: 24)),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                        onPressed: _controller.addWater,
                                        child: const Text('Add 250 ml'),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                        onPressed: _controller.resetWater,
                                        child: const Text('Reset water'),
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
```
  
### adım 5: Widget Dosyasını oluşturma

`widgets/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanılarak UI katmanı oluştur:

```dart
import 'package:flutter/material.dart';

class <FeatureName>Card extends StatelessWidget {

    final String title;
    final String subtitle;
    final String image;
    final int level;
    final int coins;

    const <FeatureName>Card({Key? key,
        required this.title,
        required this.subtitle,
        required this.image,
        required this.level,
        required this.coins
    }): super(key: key);

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Column(
               children: [
                Image.network(image),
                Text(title),
                Text(subtitle),
                Text('Level $level'),
                Text('Coins $coins'),
               ],
            ),
        );
    }
}
```
### Adım 6: Clean Architecture Kuralları

- **Separation of Concerns** Her dosyasının belirli bir sorumluluğu olduğundan emin ol.
- **Reusability** Widgetları ve Controller'ı diğer ekranlarda da kullanabilecek şekilde tasarla.
- **Testability** Her katman için ayrı testler yazabileceğinden emin ol.

## Kullanım Örnekleri
### Örnek1: Basit bir ekran oluşturma
```dart
import 'package:flutter/material.dart';
import '../view/water_tracker_view.dart';

class HomePage extends StatelessWidget{
    const HomePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: WaterTrackerView(),
        );
    }
}


### Örnek 2: Modüler widget kullanımı
```dart

import 'package:flutter/material.dart';
import '../widgets/water_tracking_card.dart';

class HomePage extends StatelessWidget {
    const HomePage({Key? key}): super(key: key);

    @override
    Widget build(BuildContext context) {
        return WaterTrackingCard(
            title: 'Water Tracking',
            subtitle: 'Track your water intake',
            image: 'https://example.com/water_tracking.png',
            level: 1,
            coins: 0,
        );
    }
}
```

## ekstra ipuçları

- **Dependency Injection** Controller'ları widgetlara inject etmek için GetIt ve Provider kullanılacaktır.
- **Navigation:** Naviasyonu sağlamak için Navigator 2.0 veya go_router kullanılacaktır.
- **Testing** Her katman için testler yazarak uygulamanın stabilitesini sağlayabilirsin.

### SSS 

### Soru: hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap** Yeni bir ekran veya işlev modülü oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yetenek hangi durumlarda kullanmaalıyım?
**Cevap:** Mevcut bir ekranı güncellerken veya küçük bir hata düzeltmesi yaparken bu yeteneği kullanmamalısın.