import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:tutor/provider/home_provider.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/view/auth/login_page.dart';
import 'package:tutor/view/tutor/main_tutor.dart';


import 'view/student/main_student.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'tutor_haus_channel', // id
  'Tutor Haus Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  Intl.defaultLocale = "th";
  initializeDateFormatting();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _getToken() async {
    String? token = await _firebaseMessaging.getToken();

    // assert(token != null);
    Globals.deviceToken = token ?? "";
  }

  @override
  Widget build(BuildContext context) {
    _getToken();
    _initFirebaseMessaging(context);

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: HomeProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TutorHaus',
        theme: ThemeData(
          // brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.promptTextTheme(
            Theme.of(context).textTheme,
          ),
          fontFamily: 'Prompt',
        ),
        // darkTheme: ThemeData(
        //   brightness: Brightness.dark,
        //   fontFamily: GoogleFonts.mulish().fontFamily,
        // ),
        // themeMode: ThemeMode.dark,
        home: LoginPage(),
        // home: MainTutor(),
      ),
    );
  }

  void _initFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.instance.requestPermission();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid);

    var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Theme.of(context).platform != TargetPlatform.android) return;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ),
        );
      }
    });
  }
}
