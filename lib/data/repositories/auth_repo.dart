import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> postUserRegister({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postUserRegister, "postUserRegister", data);

  Future<Response> postUserLogin({required FormData data}) async =>
      await apiClient.postData(AppConstants.loginUri, "postUserLogin", data);

  Future<Response> postChangePassword({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postChangePassword, "postChangePassword", data);

  Future<Response> postUpdateProfile({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postUpdateProfile, "postUpdateProfile", data);

  Future<Response> postUpdateProfilePhoto({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postUpdateProfilePhoto, "postUpdateProfilePhoto", data);

  Future<Response> getOTP({required FormData data}) async =>
      await apiClient.postData(AppConstants.postGetOPT, "getOTP", data);

  Future<Response> verifyOTP({required FormData data}) async =>
      await apiClient.postData(AppConstants.postVerifyOTP, "verifyOTP", data);

  Future<Response> postCheckBalance({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postCheckBalance, "postCheckBalance", data);

  Future<bool> saveUserLogin(
    String number,
    String password,
    String deviceID,
    String latitude,
    String longitude,
  ) async {
    try {
      log("saveUserLogin----------");
      final savedNumber =
          await sharedPreferences.setString(AppConstants.number, number);
      final savedPassword =
          await sharedPreferences.setString(AppConstants.password, password);
      final savedDevice =
          await sharedPreferences.setString(AppConstants.deviceId, deviceID);
      final savedLat =
          await sharedPreferences.setString(AppConstants.latitude, latitude);
      final savedLon =
          await sharedPreferences.setString(AppConstants.longitude, longitude);

      return savedNumber &&
          savedPassword &&
          savedDevice &&
          savedLat &&
          savedLon;
    } catch (e, st) {
      log('saveUserToken error: $e\n$st');
      return false;
    }
  }

  Future<bool> saveUserToken(
    String token,
  ) async {
    try {
      apiClient.token = token;
      apiClient.updateHeader(token);

      return await sharedPreferences.setString(AppConstants.token, token);
    } catch (e, st) {
      log('saveUserToken error: $e\n$st');
      return false;
    }
  }

  Future<bool> saveAPIToken({
    required String apiToken,
  }) async {
    try {
      return await sharedPreferences.setString(AppConstants.apiToken, apiToken);
    } catch (e, st) {
      log('saveAPIToken error: $e\n$st');
      return false;
    }
  }

  Future<bool> saveFCMToken({
    required String fcmToken,
  }) async {
    try {
      return await sharedPreferences.setString(AppConstants.fcmToken, fcmToken);
    } catch (e, st) {
      log('saveFCMToken error: $e\n$st');
      return false;
    }
  }

  String getFCMToken() {
    return sharedPreferences.getString(AppConstants.fcmToken) ?? "";
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  String getApiToken() {
    return sharedPreferences.getString(AppConstants.apiToken) ?? "";
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.userId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userId);
    sharedPreferences.remove(AppConstants.userId);
    sharedPreferences.remove(AppConstants.apiToken);
    sharedPreferences.remove(AppConstants.fcmToken);
    apiClient.token = '';
    apiClient.updateHeader('');

    return true;
  }

  Future<String> getDeviceId() async {
  const String _deviceIdKey = 'device_id';
  try {
    // 1) Check storage first
    final stored = sharedPreferences.getString(_deviceIdKey);
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    // 2) Get platform-specific string
    String rawId = '';
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      rawId = androidInfo.id; // Usually returns the alphanumeric Build ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      rawId = iosInfo.identifierForVendor ?? '';
    }

    // 3) Convert alphanumeric to 6-digit numeric format
    String numericId;
    if (rawId.isEmpty) {
      // If we can't get an ID, generate a random 6-digit number
      numericId = (100000 + Random().nextInt(900000)).toString();
    } else {
      // Use hashCode to turn any string into a stable number
      // .abs() ensures it's positive, .toString() converts it
      String hashed = rawId.hashCode.abs().toString();
      
      // Ensure we take exactly 6 digits (e.g., 546489)
      if (hashed.length >= 6) {
        numericId = hashed.substring(0, 6);
      } else {
        numericId = hashed.padLeft(6, '0');
      }
    }

    // 4) Persist and return
    await sharedPreferences.setString(_deviceIdKey, numericId);
    log('Generated Numeric Device ID: $numericId', name: 'getDeviceId');
    return numericId;

  } catch (e, st) {
    log('Error: $e', name: 'getDeviceId');
    // Fallback on error: generate a random 6-digit number
    final fallback = (100000 + Random().nextInt(900000)).toString();
    await sharedPreferences.setString(_deviceIdKey, fallback);
    return fallback;
  }
}

  // Future<String> getDeviceId() async {
  //   const String _deviceIdKey = 'device_id';
  //   try {
  //     // 1) check if we already generated/stored one
  //     final stored = sharedPreferences.getString(_deviceIdKey);
  //     if (stored != null && stored.isNotEmpty) {
  //       log('Returning stored device id: $stored', name: 'getDeviceId');
  //       return stored;
  //     }

  //     // 2) try platform-specific id
  //     String deviceId = '';
  //     final deviceInfo = DeviceInfoPlugin();

  //     if (Platform.isAndroid) {
  //       final androidInfo = await deviceInfo.androidInfo;
  //       deviceId = androidInfo.id;
  //       // androidInfo.id is a stable device-specific ID for Android
  //     } else if (Platform.isIOS) {
  //       final iosInfo = await deviceInfo.iosInfo;
  //       deviceId = iosInfo.identifierForVendor ?? '';
  //     } else {
  //       // Other platforms (web, windows, macos) - leave empty to fallback
  //       deviceId = '';
  //     }

  //     // 3) fallback to generated UUID if platform id not available
  //     if (deviceId.isEmpty) {
  //       deviceId = const Uuid().v4();
  //       log('Generated fallback UUID device id: $deviceId',
  //           name: 'getDeviceId');
  //     } else {
  //       log('Using platform device id: $deviceId', name: 'getDeviceId');
  //     }

  //     // persist for later calls
  //     await sharedPreferences.setString(_deviceIdKey, deviceId);
  //     return deviceId;
  //   } catch (e, st) {
  //     log('Error getting device id: $e\n$st', name: 'getDeviceId');
  //     // On error, ensure we still produce a stored fallback UUID
  //     final fallback = const Uuid().v4();
  //     await sharedPreferences.setString(_deviceIdKey, fallback);
  //     return fallback;
  //   }
  // }
}
