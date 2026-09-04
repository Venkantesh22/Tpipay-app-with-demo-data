import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/one_time_function/set_notification_setting.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/controllers/voice_service_controller.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSoundNotificationScreen extends StatefulWidget {
  const PaymentSoundNotificationScreen({super.key});

  @override
  State<PaymentSoundNotificationScreen> createState() =>
      _PaymentSoundNotificationScreenState();
}

class _PaymentSoundNotificationScreenState
    extends State<PaymentSoundNotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      appBar: CustomAppbarDrawer(
        title: "Payment Sound Notification",
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Off/On Payment sound notification",
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgsVolumeUp,
                          height: 24,
                          width: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Payment Sound",
                            style: Helper(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: black),
                          ),
                        ),
                      ],
                    ),
                    GetBuilder<BasicController>(builder: (basicController) {
                      return FutureBuilder<SharedPreferences>(
                        future: sharedPreferences,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 100, // Fixed width for the toggle
                              child: Switch(
                                value: snapshot.data?.getBool(
                                        AppConstants.soundNotificationIsOn) ??
                                    false,
                                onChanged: (val) async {
                                  if (val == true) {
                                    // 1. Show the "Always" vs "Not Always" Popup
                                    bool? playAlways = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Sound Preference"),
                                          content: const Text(
                                              "Do you want to hear payment announcements always (even when the app is closed), or only when the app is open?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    false); // Returns false for "Not Always"
                                              },
                                              child: const Text(
                                                  "Only when app is open",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    true); // Returns true for "Always"
                                              },
                                              child: const Text("Always",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // If they tapped outside the box and didn't choose, cancel the action.
                                    if (playAlways == null) return;

                                    // 2. Ask for Notification Permission
                                    bool isGranted =
                                        await Get.find<PermissionController>()
                                            .requestNotificationPermission();

                                    if (isGranted) {
                                      // 3. Permission Granted!
                                      // Save their preference so the background handler knows what to do
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool(
                                          'play_sound_always', playAlways);

                                      // Turn the system on
                                      await NotificationSettingsService
                                          .setNotificationSettings();
                                      basicController
                                          .setIsNotificationSound(true);
                                    } else {
                                      // 4. Permission Denied! Show the Settings Popup.
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Permission Required"),
                                              content: const Text(
                                                  "To hear payment announcements, you must allow notifications for TpiPay in your phone settings."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel",
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    openAppSettings(); // Opens Android Settings
                                                  },
                                                  child: const Text(
                                                      "Open Settings",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  } else {
                                    // 5. User wants to turn it completely OFF
                                    basicController
                                        .setIsNotificationSound(false);
                                  }
                                },
                              ),
                            );
                          }
                          return SizedBox(width: 100);
                        },
                      );
                    })
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            GetBuilder<VoiceServiceController>(
                builder: (voiceServiceController) {
              return GetBuilder<BasicController>(builder: (basicController) {
                return FutureBuilder<SharedPreferences>(
                  future: sharedPreferences,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // 1. Check if the master sound toggle is ON or OFF
                      bool isSoundOn = snapshot.data
                              ?.getBool(AppConstants.soundNotificationIsOn) ??
                          false;

                      // 2. Wrap the Dropdown in IgnorePointer and Opacity to "Disable" it
                      return IgnorePointer(
                        ignoring: !isSoundOn, // Blocks taps if sound is OFF
                        child: Opacity(
                          opacity: isSoundOn ? 1.0 : 0.4,
                          child: CustomDropDownList(
                            items: basicController.paymentNotSoundLanguageList,
                            heading: "Select Language for payment sound",
                            hintText: "Sound language",
                            preFixWidget: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: !voiceServiceController.isLoading
                                    ? SvgPicture.asset(
                                        Assets.svgsVolumeUp,
                                        fit: BoxFit.cover,
                                        height: 20,
                                        width: 20,
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                            value: snapshot.data?.getString(
                                AppConstants.soundNotificationLanguage),
                            onChanged: (value) async {
                              String selectedLang = value as String;

                              // Save the new language
                              basicController.setPaymentNotSoundLanguage(
                                  language: selectedLang);

                              // 3. Play the Test Audio immediately
                              String testMessage = "";
                              String shortCode = "en";

                              switch (selectedLang.toLowerCase()) {
                                case 'hindi':
                                case 'hind':
                                  testMessage =
                                      "TpiPay पर एक रुपये प्राप्त हुए";
                                  shortCode = "hi";
                                  break;
                                case 'odia':
                                  testMessage =
                                      "ଟିପିଆଇ ପେ ରେ ଏକ ଟଙ୍କା ପ୍ରାପ୍ତ ହେଲା";
                                  shortCode = "or";
                                  break;
                                case 'english':
                                default:
                                  testMessage = "Received 1 rupee on TpiPay";
                                  shortCode = "en";
                                  break;
                              }

                              await voiceServiceController.speak(
                                  testMessage, shortCode);
                            },
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                );
              });
            })
          ],
        ),
      ),
    );
  }
}
