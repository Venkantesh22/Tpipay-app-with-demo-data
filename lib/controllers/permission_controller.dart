import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/base/dialogs/request_permission_dialog.dart';

class PermissionController extends GetxController implements GetxService {
  Future<bool> getPermission(
      Permission permission, BuildContext context) async {
    PermissionStatus? status;
    await (Future.value(
            await permission.isGranted || await permission.isLimited))
        .then((value) async {
      if (!value) {
        bool result = await showDialog(
              context: context,
              builder: (context) => RequestPermissionDialog(
                permission: permission.toString().split('.').last.toString(),
              ),
            ) ??
            false;
        if (result) {
          status = await permission.request();
        }
        log("-----$status-----", name: permission.toString());
      } else {
        log("-----Granted-----", name: permission.toString());
      }
    });

    bool isGranted = permission == Permission.photos
        ? (await permission.isLimited || await permission.isGranted)
        : await permission.isGranted;
    return Future.value(isGranted);
  }

//--------------------- NOTIFICATIONS --------------------
  Future<bool> requestNotificationPermission() async {
    // 1. Check the current status
    var status = await Permission.notification.status;

    // 2. If it is denied or hasn't been asked yet, show the system popup
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }

    // 3. Return true if they allowed it, or false if they denied it
    return status.isGranted;
  }

  // -------------------- LOCATION --------------------

  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
// 1. Pass BuildContext into the function
  Future<bool> requestLocationPermissionAndFetch(BuildContext context) async {
    try {
      log("[perm] --- requestLocationPermissionAndFetch START ---");

      // Check if Location/GPS is ON
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      log("[perm] Location serviceEnabled = $serviceEnabled");

      if (!serviceEnabled) {
        // 2. Use context.mounted before showing UI after an await
        if (context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false, // Forces user to make a choice
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Location is OFF"),
                content: const Text(
                    "Your mobile location is turned OFF.\nThe app needs your location for connection services. Please turn it ON in your settings."),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(), // Close dialog
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close dialog
                      await Geolocator.openLocationSettings();
                    },
                    child: const Text("Turn ON Location"),
                  ),
                ],
              );
            },
          );
        }
        return false; // Stop API call
      }

      // Request permission via permission_handler
      PermissionStatus status = await Permission.location.status;

      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Permission Required"),
                content: const Text(
                    "Location permission is permanently denied.\nEnable it manually in settings."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await openAppSettings();
                    },
                    child: const Text("Open Settings"),
                  ),
                ],
              );
            },
          );
        }
        return false; // Stop API call
      }

      if (!status.isGranted) {
        if (context.mounted) {
          // Native Flutter Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission is required.")),
          );
        }
        return false; // Stop API call
      }

      // Get location safely
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      log("[perm] Location fetched: $_latitude, $_longitude");

      update();
      return true; // Success! Proceed with API call.
    } catch (e, st) {
      log("Error fetching location: $e\n$st");
      return false; // Stop API call on error
    }
  }

  String? latlong;

  String? get latLongString {
    if (_latitude != null && _longitude != null) {
      return '$_latitude,$_longitude';
    }
    return null;
  }

// Future<void> requestLocationPermissionAndFetch() async {
//   try {
//     log("[perm] --- requestLocationPermissionAndFetch START ---");

//     // 1️⃣ Check if Location/GPS is ON
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     log("[perm] Location serviceEnabled = $serviceEnabled");

//     if (!serviceEnabled) {
//       // Show popup manually because Android will NOT show automatically
//       if (Get.context != null) {
//         await Get.defaultDialog(
//           title: "Location Required",
//           middleText:
//               "Your device location is turned OFF.\nPlease turn it ON to continue.",
//           textCancel: "Cancel",
//           textConfirm: "Open Settings",
//           onConfirm: () async {
//             await Geolocator.openLocationSettings();
//             Get.back();
//           },
//         );
//       }
//       return;
//     }

//     // 2️⃣ Request permission
//     PermissionStatus status = await Permission.location.status;

//     if (status.isDenied) {
//       status = await Permission.location.request();
//     }

//     if (status.isPermanentlyDenied) {
//       if (Get.context != null) {
//         await Get.defaultDialog(
//           title: "Permission Required",
//           middleText:
//               "Location permission is permanently denied.\nPlease enable it manually.",
//           textConfirm: "Open Settings",
//           textCancel: "Cancel",
//           onConfirm: () {
//             openAppSettings();
//             Get.back();
//           },
//         );
//       }
//       return;
//     }

//     if (!status.isGranted) {
//       if (Get.context != null) {
//         Get.snackbar("Permission Denied", "Location permission is required.");
//       }
//       return;
//     }

//     // 3️⃣ Get location (now safe)
//     final position = await Geolocator.getCurrentPosition(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//       ),
//     );

//     _latitude = position.latitude;
//     _longitude = position.longitude;

//     log("[perm] Location fetched: $_latitude, $_longitude");

//     update();
//   } catch (e, st) {
//     log("Error fetching location: $e\n$st");

//     // fallback
//     final last = await Geolocator.getLastKnownPosition();
//     if (last != null) {
//       _latitude = last.latitude;
//       _longitude = last.longitude;
//       update();
//     }
//   }
// }

  // import needed: import 'package:permission_handler/permission_handler.dart';
  Future<bool> requestStoragePermission({
    bool showDialogIfDenied = true,
    BuildContext? context,
  }) async {
    try {
      if (Platform.isIOS) {
        // Prefer adding-only permission if you're only saving to gallery (iOS 14+)
        // final result = await Permission.photosAddOnly.request(); // optional
        final status = await Permission.photos.status;
        if (status.isGranted || status.isLimited) return true;
        final result = await Permission.photos.request();
        if (result.isGranted || result.isLimited) return true;

        if (result.isPermanentlyDenied &&
            showDialogIfDenied &&
            context != null) {
          final openSettings = await _showPermissionSettingsDialog(
            context: context,
            title: 'Photos permission required',
            message:
                'Photos permission is required to save images to your gallery. Open settings to grant permission.',
          );
          if (openSettings == true) await openAppSettings();
        }
        return false;
      }

      // ANDROID
      final photosStatus =
          await Permission.photos.status; // may be useful on some OEMs
      final storageStatus = await Permission.storage.status;
      final manageStatus = await Permission.manageExternalStorage.status;

      if (photosStatus.isGranted ||
          storageStatus.isGranted ||
          manageStatus.isGranted) {
        return true;
      }

      // Try request in order (photos -> storage -> manage)
      final resultPhotos = await Permission.photos.request();
      if (resultPhotos.isGranted || resultPhotos.isLimited) return true;

      final resultStorage = await Permission.storage.request();
      if (resultStorage.isGranted) return true;

      final resultManage = await Permission.manageExternalStorage.request();
      if (resultManage.isGranted) return true;

      final permanentlyDenied = resultPhotos.isPermanentlyDenied ||
          resultStorage.isPermanentlyDenied ||
          resultManage.isPermanentlyDenied;

      if (permanentlyDenied && showDialogIfDenied && context != null) {
        final openSettings = await _showPermissionSettingsDialog(
          context: context,
          title: 'Permission required',
          message:
              'Storage/Photos permission is required to save images. Open app settings to grant permission.',
        );
        if (openSettings == true) await openAppSettings();
      }

      return false;
    } catch (e, st) {
      log('requestStoragePermission error: $e\n$st');
      return false;
    }
  }

  Future<bool?> _showPermissionSettingsDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    // Ensure context is still valid
    // If the widget owning this context might be disposed, check mounted via a State object,
    // or pass a context that you know is stable (like the root Scaffold's context).

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // optional: user must choose
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // use rootNavigator to be more reliable:
              Navigator.of(dialogContext, rootNavigator: true).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Pop first, then caller will handle openAppSettings()
              Navigator.of(dialogContext, rootNavigator: true).pop(true);
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }

  /// Request contacts permission and handle various states.
  /// Returns true when permission is granted.
  Future<bool> checkAndRequestContactsPermission() async {
    try {
      final status = await Permission.contacts.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        final result = await Permission.contacts.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        // Open app settings so user can enable permission manually.
        // You can show a dialog before opening settings.
        final opened = await openAppSettings();
        log('Opened app settings: $opened');
        return false;
      }

      // handle restricted / limited (iOS) case
      if (status.isRestricted || status.isLimited) {
        // attempt request anyway
        final result = await Permission.contacts.request();
        return result.isGranted;
      }

      // default: ask
      final result = await Permission.contacts.request();
      return result.isGranted;
    } catch (e) {
      log('Error requesting contacts permission: $e');
      return false;
    }
  }

  Future<bool> askWithDialogIfPermanentlyDenied() async {
    final granted = await checkAndRequestContactsPermission();
    if (granted) return true;

    final status = await Permission.contacts.status;
    if (status.isPermanentlyDenied) {
      await Get.defaultDialog(
        title: 'Permission required',
        middleText:
            'Please enable Contacts permission from app settings to pick a number.',
        textConfirm: 'Open Settings',
        textCancel: 'Cancel',
        onConfirm: () {
          openAppSettings();
          Get.back(); // close dialog
        },
      );
    }
    return false;
  }

  Future<bool> checkAndRequestStoragePermission() async {
    try {
      if (Platform.isIOS) {
        // iOS does NOT allow apps to access arbitrary file storage.
        // Saving inside app documents folder needs NO permission.
        return true;
      }

      /// ANDROID SECTION
      const Permission storagePermission = Permission.storage;
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      // ANDROID 11+   (SDK >= 30)
      if (androidInfo.version.sdkInt >= 30) {
        final managePermission = Permission.manageExternalStorage;

        // already granted?
        if (await managePermission.isGranted) {
          return true;
        }

        // ask for permission
        final result = await managePermission.request();

        if (result.isGranted) {
          return true;
        } else {
          // permission denied
          return false;
        }
      }

      // ANDROID < 30
      if (await storagePermission.isGranted) {
        return true;
      }

      final requestResult = await storagePermission.request();
      return requestResult.isGranted;
    } catch (e) {
      log("Permission error: $e", name: "checkAndRequestStoragePermission");
      return false;
    }
  }
}
