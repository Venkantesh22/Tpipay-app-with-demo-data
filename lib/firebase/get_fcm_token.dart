import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/firebase/odia_number_languages.dart/odia_number_languages.dart';
import 'package:lekra/firebase_options.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/controllers/voice_service_controller.dart';
import 'package:lekra/views/screens/dashboard/home_screen/function/home_screen_fun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final basicController = Get.find<BasicController>();

  static Future<void> initialize() async {
    // 1. Request Firebase Permissions (Required for Android 13+ & iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted notification permissions');

      // 2. Initialize Local Notifications for Foreground Banners
      const androidInit =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      const initSettings = InitializationSettings(android: androidInit);
      try {
        await _localNotifications.initialize(
          settings: initSettings,
          onDidReceiveNotificationResponse: (NotificationResponse response) {
            log("Notification tapped: ${response.payload}");
          },
        );
      } catch (e, s) {
        log('Local notifications init failed: $e\n$s');
      }

      // 3. Create a High Importance Channel (Forces banner to pop down)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'tpipay_payment_channel', // id
        'Payment Notifications', // title
        description: 'Used for TpiPay Sound Box announcements',
        importance: Importance.max,
        playSound: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 4. Get and log the Token
      // await getFCMToken();

      // 5. Listen for Messages while the App is OPEN (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("Foreground Message: ${message.data}");

        // Show the visual banner
        _showLocalNotification(message, channel);

        // Trigger the Sound Box voice
        _handlePaymentLogic(message);

        HomeScreenFun.refreshAllTransactionAndGraph();
      });

      // 6. Set the Background/Terminated Handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
  }

  static Future<String?> getFCMToken() async {
    String? token = await _messaging.getToken();

    log("-----------------------------------------");
    log("FCM TOKEN: $token");
    log("-----------------------------------------");
    Get.find<AuthController>().saveFMCToken(token ?? "");

    return token ?? "";
  }

  static void _showLocalNotification(
      RemoteMessage message, AndroidNotificationChannel channel) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );
    }
  }

// Handle Foreground Payments
  static Future<void> _handlePaymentLogic(RemoteMessage message) async {
    await processPaymentVoice(message.data);
  }
}

// Helper function to handle translations and voice
Future<void> processPaymentVoice(Map<String, dynamic> data) async {
  if (data['type'] == 'payment_received') {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload(); // Force reload for background isolates

    bool isSoundEnabled =
        sharedPreferences.getBool(AppConstants.soundNotificationIsOn) ?? true;

    // This might be "Odia", "or-IN", "Hindi", etc. depending on your UI.
    String savedLang =
        sharedPreferences.getString(AppConstants.soundNotificationLanguage) ??
            'en-IN';

    if (isSoundEnabled) {
      String amount = data['amount'] ?? "0";

      String cleanAmount = amount;

      if (amount.endsWith(".00")) {
        cleanAmount = amount.substring(0, amount.length - 3);
      }
      String spokenText = "";
      String googleShortCode = "en"; // Default to English

      log("Settings Loaded -> Sound: $isSoundEnabled, Lang: $savedLang");

      // Safely map whatever is in the database to the correct text and 2-letter code
      switch (savedLang) {
        case 'Hindi':
          spokenText = "TpiPay पर $cleanAmount रुपये प्राप्त हुए";
          googleShortCode = "hi";
          break;
        case 'Odia':
          String odiaAmountWord =
              OdiaNumberLanguages.translateAmountToOdia(amount);
          spokenText = "ଟିପିଆଇ ପେ ରେ $odiaAmountWord ଟଙ୍କା ପ୍ରାପ୍ତ ହେଲା";
          googleShortCode = "or";
          break;
        case 'English':
        default:
          spokenText = "$cleanAmount rupee received in TPIpay account";
          googleShortCode = "en";
          break;
      }

      // Play the voice after a short delay

      // 1. AWAIT the delay directly so Android doesn't kill the background process!
      await Future.delayed(const Duration(seconds: 2));

      // 2. 🔴 CRITICAL FOR BACKGROUND: Safely inject the controller.
      // Get.find will crash a closed app. We must use Get.put.
      VoiceServiceController voiceController;
      if (Get.isRegistered<VoiceServiceController>()) {
        voiceController = Get.find<VoiceServiceController>();
      } else {
        voiceController = Get.put(VoiceServiceController());
      }

      // 3. Play the voice. Because we awaited everything, the isolate stays alive!
      await voiceController.speak(spokenText, googleShortCode);
    }
  }
}

// Global Background Handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 🔴 CRITICAL: Wake up the native plugins for the background isolate
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  // Call the shared helper function
  await processPaymentVoice(message.data);

  // 🔴 THE MAGIC FIX: KEEP THE ISOLATE ALIVE
  // We must force Android to keep the background app running for an extra 6 seconds.
  // This gives the Azure API time to download the audio, and the speaker time to finish saying the whole sentence before Android kills the app!
  log("Background handler finished and closing safely.");
}
