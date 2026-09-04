import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
// 🔴 NEW: Import Firebase Messaging so main.dart can use it
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/firebase/get_Fcm_token.dart'; // Ensure this contains firebaseMessagingBackgroundHandler
import 'package:lekra/firebase_options.dart';
import 'package:lekra/firebase_options_second.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:toastification/toastification.dart';
import 'services/init.dart';
import 'views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DEBUG: list apps before attempting init
  try {
    log('Firebase.apps before main init: ${Firebase.apps.map((a) => a.name).toList()}');
  } catch (_) {/* ignore if Firebase not ready */}

  // Safe initialize main Firebase with guard + catch
  try {
    if (Firebase.apps.isEmpty) {
      log('Initializing DEFAULT Firebase app (main) ...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log('DEFAULT Firebase initialized.');
    } else {
      log('DEFAULT Firebase already initialized: ${Firebase.apps.map((a) => a.name).toList()}');
    }
  } on FirebaseException catch (e) {
    // ignore duplicate-app error, rethrow others
    if (e.code == 'duplicate-app' ||
        e.message?.contains('already exists') == true) {
      log('Ignored duplicate-app FirebaseException: ${e.message}');
    } else {
      rethrow;
    }
  } catch (e, s) {
    log('Unexpected error during Firebase init: $e\n$s');
    rethrow;
  }

  // 🔴 NEW: REGISTER THE BACKGROUND HANDLER RIGHT HERE
  // Firebase is now awake, so we instantly tell Android what to do when a payment arrives in the background.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // services that depend on main firebase
  await Init().initialize();
  await FCMService.initialize();
  await initializeSecondFirebase();

  runApp(const MyApp());
}

Future<void> initializeSecondFirebase() async {
  try {
    if (!Firebase.apps.any((app) => app.name == 'secondProject')) {
      await Firebase.initializeApp(
        name: 'secondProject',
        options: DefaultFirebaseOptionsSecond.currentPlatform,
      );
      log("Second Firebase project initialized successfully");
    } else {
      log('Second Firebase already exists: ${Firebase.apps.map((a) => a.name).toList()}');
    }
  } catch (e, s) {
    log("Second Firebase init error: $e\n$s");
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('Current state = $state');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
          designSize: Size(432.0, 960.0),
          minTextAdapt: true,
          builder: (_, child) {
            return MaterialApp(
              title: AppConstants.appName,
              navigatorKey: navigatorKey,
              themeMode: ThemeMode.light,
              theme: CustomTheme.light,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              // home: const PinResetSuccessfullyAndFailsScreen(),
            );
          }),
    );
  }
}
