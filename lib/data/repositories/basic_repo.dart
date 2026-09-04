import 'dart:developer';

import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  const BasicRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> postFetchStatus() async {
    return await apiClient.postData(
        AppConstants.postStatus,
        "postFetchStatus",
        FormData({
          "api_token": sharedPreferences.getString(AppConstants.apiToken),
        } as Map<String, dynamic>));
  }

  Future<Response> fetchDistrictByState({required int? statusId}) async {
    return await apiClient.postData(
        AppConstants.postDistrictByState,
        "postFetchStatus",
        FormData({
          'state_id': statusId,
          "api_token": sharedPreferences.getString(AppConstants.apiToken),
        } as Map<String, dynamic>));
  }

  Future<bool> saveIsDemoShow(
    bool value,
  ) async {
    try {
      return await sharedPreferences.setBool(AppConstants.isDemoShowKey, value);
    } catch (e, st) {
      log('saveUserToken error: $e\n$st');
      return false;
    }
  }

  Future<Response> postGenerateQR({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postGenerateQR, "postGenerateQR", data);
  }
}
