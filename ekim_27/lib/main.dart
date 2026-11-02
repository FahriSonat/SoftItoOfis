import 'package:flutter/material.dart';
import 'screens/urun_listesi_ekrani.dart';

void main(){
  runApp(const MiniMagazaUygulamasi());
}

class MiniMagazaUygulamasi extends StatelessWidget{
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug moddan çık
      title: "Mini Mağaza",
      theme: ThemeData( 
        useMaterial3: true, // material 3 uyumlu 
        colorScheme: ColorScheme.fromSeed( // renk paleti oluştur 
          seedColor: Colors.indigo, // temel renk 
          brightness: Brightness.light, // açık tema 
        ),
      ),
      /*home: const Scaffold( // tuval
        body: Center( // merkezde 
          child: Text(
            "Anasayfa",
            style: TextStyle( // inline css gibi stil ekler. 
              fontSize: 24, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),  
      ),*/
      
      home: UrunListesiEkrani(),
    );
  }
}