import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RechargeRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  RechargeRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> postFetchProvider({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postFetchProvider, "postFetchProvider", data);
  }

  Future<Response> fetchPrepaidROffer({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postFetchPrepaidROffer, "fetchPrepaidROffer", data);
  }

  Future<Response> fetchPrepaidPlans({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postPrepaidPlan, "fetchPrepaidPlans", data);
  }

  Future<Response> payRechargeViaUpi({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postRechargeViaUpi, "payRechargeViaUpi", data);
  }

  Future<Response> fetchDTHCustomerInfo({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postDTHCustomerInfo, "fetchDTHCustomerInfo", data);
  }

  Future<Response> fetchDTHPlan({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postDTHPlan, "fetchDTHPlan", data);
  }
}
