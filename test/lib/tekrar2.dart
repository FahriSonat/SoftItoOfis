import 'package:flutter/material.dart';

class HataliveDogruRow extends StatelessWidget{
  const HataliveDogruRow({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar:AppBar(title:const Text("Row ve Layout")),
    body:Padding(padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hatalı Yapı: A overflowed by *** pixels(sarı siyah şerit)', 
        style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red),
        ),
        const SizedBox(height: 8),

        Container(
          color: Colors.amber.shade100,
          child:Row(
            children: [
              const Icon(Icons.warning,color:Colors.red),
              const SizedBox(width: 8),
              const Text ('Kısa Metin (Hata vermez ama uzarsa Render Patlar)'),
            ],
          ),
        ),

        const SizedBox(height: 32),
        const Text('Doğru Yapı:Flexible ve expanded ile sınırlandırılmıştır.',
        style:TextStyle(fontWeight:FontWeight.bold,color: Colors.green),
        ),
      ],
    ),
  
        child:Row(
          children:[
            const CircleAvatar(
              backgroundColor:Colors.green,
              child:Icon(Icons.check,color:Colors.white),
            ),
            const SizedBox(width:12),

            Expanded(
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:const[
                  Text('Softito 4.Dönem Mobil Standartı',
                  style:TextStyle(fontWeight:FontWeight.bold),

                  ),
                  SizedBox(height:4),
                  Text('Bu metin ne kadar uzun olursa olsun telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez', 
                  style:TextStyle(color:Colors.black87),
                  )
                ]
              )
            )
          ]
        )
    )
   );
  }
}