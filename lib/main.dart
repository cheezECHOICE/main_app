import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:food/app.dart';
import 'package:food/data/repositories/authentication_repo.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'firebase_options.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // GetX Local Storage
  await GetStorage.init();
  
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions (iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Get FCM Token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Initialize background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Configure local notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // On message received in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showNotification(message);
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const App());
  });
}

// Show notification function
Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'cheezECHOICE',
    'Order Status',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0, // notification id
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:food/app.dart';
// import 'package:food/data/repositories/authentication_repo.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import 'firebase_options.dart';

// Future<void> main() async {
//   // Widgets Binding
//   final WidgetsBinding widgetsBinding =
//       WidgetsFlutterBinding.ensureInitialized();

//   // GetX Local Storage
//   await GetStorage.init();

//   // Splash wait until items Load
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//   // Initialize Firebased
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
//       .then(
//     (FirebaseApp value) => Get.put(AuthenticationRepository()),
//   );
//   runApp(const App());
// }