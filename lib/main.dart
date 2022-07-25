import 'package:flutter/material.dart';
import 'package:notificationsapk/services/push_notifications_service.dart';

import 'screens/screens.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationesService.initialzeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey =   GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messagerKey =   GlobalKey<ScaffoldMessengerState>(); 


  @override
  void initState(){
    super.initState();
    
    //acceso al conetecxt
    PushNotificationesService.messageStream.listen((message) {
      
      //no puedo navegar con el navigator a otra nueva pantalla desde este listen
      //debido que el context no tiene la creaciion
      //Navigator.pushNamed(context, 'message/');
      final SnackBar snackBar = SnackBar(content: Text(message));
      messagerKey.currentState?.showSnackBar(snackBar);

      navigatorKey.currentState?.pushNamed( 'message/', arguments: message);
    }); 

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home/',
      navigatorKey: navigatorKey,//navegar

      scaffoldMessengerKey: messagerKey,//snacks
      routes: {
        'home/': (_) => const HomeScreen(),
        'message/': (_) => const MessageScreen(),
      },
    );
  }
}