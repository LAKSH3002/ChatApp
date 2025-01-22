import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:telechat/Screens/HomeScreen.dart';
import 'package:telechat/Screens/SplashScreen.dart';
import 'package:telechat/Screens/auth/loginScreen.dart';
import 'package:telechat/firebase_options.dart';

// flutter run -d emulator name

late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeleChat',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                color: const Color.fromARGB(255, 24, 24, 24),
                fontWeight: FontWeight.w700,
                fontSize: 20),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: const Color.fromARGB(255, 239, 239, 206),
            centerTitle: true,
            elevation: 1,
          )),
      home: Splashscreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For showing message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'chats',
);
print(result);
}
