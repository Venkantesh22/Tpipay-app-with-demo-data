import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ReportRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> fetchYesBankMerchantCollection({
    required String fromdate,
    required String todate,
    int page = 1,
  }) async =>
      await apiClient.getData(
          "${AppConstants.yesBankMerchantCollectionGet}?api_token=${sharedPreferences.getString(AppConstants.apiToken)}&fromdate=$fromdate&todate=$todate&page=$page",
          "fetchYesBankMerchantCollection");

  Future<Response> fetchTransactionReport({
    required String fromdate,
    required String todate,
    int page = 1,
  }) async =>
      await apiClient.getData(
          "${AppConstants.getTransactionReport}?api_token=${sharedPreferences.getString(AppConstants.apiToken)}&fromdate=$fromdate&todate=$todate&page=$page",
          "fetchTransactionReport");
}
