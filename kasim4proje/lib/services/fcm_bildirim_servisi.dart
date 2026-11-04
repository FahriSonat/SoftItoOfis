import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async{}

class FcmBildirimServisi {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localPlugin = 
      FlutterLocalNotificationsPlugin();

      Future<void> baslat({
        required Function(RemoteMessage message) onMesajGeldi,
      }) async {
        await _fcm.requestPermission(alert: true, badge: true, sound: true);

        const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher',);
        const iosSettings = InitializationSettings();
        const 

        await _localPlugin.initialize(initSettings);
        FirebaseMessaging.onMessage.listen((message) {
          _yerelBildirim
        })
      
      Future<void> _yerelBildirimGoster(RemoteMessage message) async{
        const androidDetails = android
      }
      
      }




}