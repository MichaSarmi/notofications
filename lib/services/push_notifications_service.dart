import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// id para firebase
//9E:5E:C8:9F:89:7D:20:0A:7F:C6:D1:0B:E3:D9:64:84:8B:95:29:CE
// Clase con propiedades estaticas para no instanciar un objeto al ser llamado

class PushNotificationesService{
  //tener la instance de la libreria de FirebaseMessaging
  static FirebaseMessaging messagin =  FirebaseMessaging.instance;
  static String? token;
  // suscripcion en mas de un punto
  static final StreamController<String> _messageStream =  StreamController.broadcast();
  //exporner el stream para suscribirme en el main
  static Stream<String> get messageStream => _messageStream.stream;

  static Future initialzeApp() async{
    //push notifications
    //initi app
    await Firebase .initializeApp();
    //espero el token
    token = await FirebaseMessaging.instance.getToken();
    print('mi token: $token');

    //handles
    FirebaseMessaging.onBackgroundMessage((_backgroudHanlder));
    //abierta la app
    FirebaseMessaging.onMessage.listen((_onMessageHanlder));
    FirebaseMessaging.onMessageOpenedApp.listen((_onMessageOpenApp));

    //local notification

  }
  //app esta en segundo plamnp
  static Future _backgroudHanlder(RemoteMessage message) async{
    print('on message handler ${message.data}');
    _messageStream.add(message.data['product'] ?? 'no data');

  }
  //
  static Future _onMessageHanlder(RemoteMessage message) async{
    print('on message handler ${message.data}');
    _messageStream.add(message.data['product'] ?? 'no data');
  }
  static Future _onMessageOpenApp(RemoteMessage message) async{
    print('on message handler ${message.data}');
    _messageStream.add(message.data['product'] ?? 'no data');

  }

  static closeStreams(){
    _messageStream.close();
  }

}