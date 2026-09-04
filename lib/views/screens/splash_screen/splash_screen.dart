
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/firebase/block_screen.dart';
import 'package:lekra/one_time_function/set_notification_setting.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/demo/screen/demo_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/constants.dart';
import '../../base/custom_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      Get.find<BasicController>().checkDevice();
      bool hasInternet = await _isInternetAvailable();

      /// Only check Firestore if internet exists
      if (hasInternet) {
        await _checkBlockStatus().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            log("Block check skipped (slow network)");
          },
        );
      } else {
        log("No internet - skipping block check");
      }

      await Future.delayed(const Duration(seconds: 1));

      if (prefs.getString(AppConstants.soundNotificationLanguage) == null ||
          prefs.getBool(AppConstants.soundNotificationIsOn) == null) {
        await NotificationSettingsService.setNotificationSettings();
      }

      await _handleNavigation();
    } catch (e) {
      log("Splash Error: $e");

      /// Continue app even if error happens
      await _handleNavigation();
    }
  }

  /// -------------------------------
  /// CHECK BLOCK STATUS
  /// -------------------------------
  Future<void> _checkBlockStatus() async {
    final basicController = Get.find<BasicController>();

    try {
      await basicController.isCheckApp();
    } catch (e) {
      log("Firestore Error: $e");

      // If Firestore fails, allow app to continue
      return;
    }

    bool isBlock = basicController.blockModel?.isBlock ?? false;
    bool isTimeBlock = basicController.blockModel?.timeBlock ?? false;

    log("isBlock: $isBlock | isTimeBlock: $isTimeBlock");

    if (isBlock) {
      _navigateToBlockScreen();
      return;
    }

    if (isTimeBlock) {
      basicController.startRandomCloseTimer();
    }
  }

  /// -------------------------------
  /// NAVIGATION LOGIC
  /// -------------------------------
  Future<void> _handleNavigation() async {
    final authController = Get.find<AuthController>();
    final prefs = await SharedPreferences.getInstance();

    String token = authController.getUserToken();
    bool isDemoShow = prefs.getBool(AppConstants.isDemoShowKey) ?? false;

    if (!mounted) return;

    if (token.isNotEmpty) {
      navigate(
          context: context, page: const DashboardScreen(), isRemoveUntil: true);
      return;
    }

    if (isDemoShow) {
      navigate(
          context: context, page: const LoginScreen(), isRemoveUntil: true);
    } else {
      navigate(
          context: context,
          page: const DemoDashboardScreen(),
          isRemoveUntil: true);
    }
  }

  Future<bool> _isInternetAvailable() async {
    try {
      final result = await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// -------------------------------
  /// BLOCK SCREEN NAVIGATION
  /// -------------------------------
  void _navigateToBlockScreen() {
    navigate(
        context: context,
        page: const FlashMessageScreen(),
        isRemoveUntil: true);
  }

  /// -------------------------------
  /// UI
  /// -------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            CustomImage(
              path: Assets.imagesLogo,
              height: size.height * .3,
              width: size.height * .3,
            ),
            const Spacer(flex: 3),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 26,
                  ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
