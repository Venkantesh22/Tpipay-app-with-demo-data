import 'package:get/get.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  ProductRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> fetchProductList() async => await apiClient.getData(
      "${AppConstants.getProductList}?api_token=${sharedPreferences.getString(AppConstants.apiToken)}",
      "fetchProductList");

  Future<Response> fetchProductDetails({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postProductDetails, "fetchProductDetails", data);

  Future<Response> buyProduct({required FormData data}) async =>
      await apiClient.postData(AppConstants.postBuyProduct, "buyProduct", data);

  Future<Response> fetchOrder({required FormData data}) async =>
      await apiClient.postData(AppConstants.fetchOrder, "fetchOrder", data);
}
