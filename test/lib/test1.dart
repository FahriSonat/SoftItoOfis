// setState() bulunduğu State nesnesinin build() metodunu baştan aşağı tekrar tetikler.
// Scaffold appbar tabbar ve eğer varsa 20 tane container baştan hesaplanır.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SepetKontrolu{
    static final SepetKontrolu ornek = SepetKontrolu._dahili();
    SepetKontrolu._dahili();

    // default ürün sayısı = 0
    final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

    //ürün arttırma metodu
    void sepeteEkle(){
        urunSayisi.value++;
    }

    //ürün sıfırlama metodu
    void sepetSifirla(){
        urunSayisi.value = 0;
    }
}

final GoRouter uygulamaRotalari = GoRouter(
    initialLocation:'/anasayfa',
    routes:[
        ShellRouter(
            builder(BuildContext context, GoRouterState state, Widget child){
                return AnaKasaEkrani(ekranGovdesi: child);
            },
            routes: [
                GoRoute(
                    path: '/vitrin',
                    builder:(context, state) => const VitrinEkrani(), 
                ),
                GoRoute(
                    path: '/profil',
                    builder: (context, state) => const ProfilEkrani(),
                ),
            ],
        ),
    ],
);

class AnaKasaEkrani extends StatelessWidget{
    //BLoC ile stateless içinde veri güncellenebilir.
    // komple ekrranı boymaadan güncelleme uyapılabilir.
    // sadece 1 veri değişiyor, yazı değişiyor, widgetın tamamı değişmez, tamamı yenilenmiyor -> statless kullanılabilir.
    // stateless da komple widget yenilenmez, statefulda komple widget yenilernir.
    
    final Widget ekranGovdesi;
    const AnaKasaEkrani({super.key, required this.ekranGovdesi});

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: ekranGovdesi,
            bottomNavigation:.navigationBar(
                selectedIndex: _aktifIndexiBul(context),
                onDestinationSelected:(yeniIndex){
                    if (yeniIndex == 0) {
                        context.go('/vitrin');
                    }
                    else if (yeniIndex == 1){
                        context.go('/profil');
                    }
                },
                destinations: [
                    const NavigationDestination(icon: Icon(Icons.store), label:'Vitrin'),
                    NavigationDestination(
                        icon: ValueListenableBuilder<int>(
                            valueListenable:SepetKontrolu.ornek.urunSayisi,
                            builder:(context, sayi, child){
                                return Badge(
                                    label: Text('${sayi}'),
                                    isLabelVisible: sayi > 0,
                                    child: const Icon(Icons.person),
                                );
                            },
                        ),
                        label: 'Profil',
                    ),
                ],
            ),
        );
    }

    int _aktifIndexiBul(BuildContext context){
        final String konum = GoRouterState.of(context).uri.toString();
        if(konum.startWith('/profil')) return 1;
        return 0;
    }

    class VitrinEkrani extends StatelessWidget{
        const VitrinEkrani({super.key});

        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar: AppBar(
                    title: const Text('Canlı Vitrin (ValueNotifier)'),
                ),
                body: Center(
                    child: ElevatedButton.icon(
                        onPressed: (){
                            SepetKontrolu.ornek.sepeteEkle();
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Sepete ürün ekle (+1)'),
                    ),
                ),
            );
        }
    }
    class ProfilEkrani extends StatelessWidget{
        const ProfilEkrani({super.key});
        @override
        Widget build(BuildContext context){
            return Scaffold(
                appBar: AppBar(
                    title: const Text('Kullanıcı profili'),
                ),
                body: Center(
                    child: TextButton(
                        onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
                        child: const Text('Sepeti Sıfırla (Stateless İçinden)'),
                    )
                )
            ) 
        
        }  
    }
}