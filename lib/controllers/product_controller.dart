import 'dart:developer';

import 'package:get/get.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/product_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;
  final SharedPreferences sharedPreferences;

  ProductController(
      {required this.productRepo, required this.sharedPreferences});

  bool isLoading = false;

  List<ProductModel> productList = [];
  Future<ResponseModel> fetchProductList() async {
    log('----------- fetchProductList Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await productRepo.fetchProductList();

      if (response.statusCode == 200 &&
          response.body['status'] == "success" &&
          response.body['products'] is List) {
        productList = (response.body['products'] as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();

        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetch fetchProductList success");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while fetchProductList");
      }
    } catch (e) {
      log('ERROR AT fetchProductList(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchProductList user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  ProductModel? selectProduct;

  void setSelectProduct(ProductModel value) {
    selectProduct = value;
    update();
  }

  Future<ResponseModel> fetchProductDetails() async {
    log('----------- fetchProductDetails Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
        'product_id': selectProduct?.productId,
      };
      Response response =
          await productRepo.fetchProductDetails(data: FormData(data));

      if (response.statusCode == 200 &&
          response.body['status'] == "success" &&
          response.body['product_details'] is Map) {
        selectProduct = ProductModel.fromJson(response.body['product_details']);

        responseModel = ResponseModel(true,
            response.body['message'] ?? "fetch fetchProductDetails success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchProductDetails");
      }
    } catch (e) {
      log('ERROR AT fetchProductDetails(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchProductDetails user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> buyProduct() async {
    log('----------- buyProduct Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
        'product_id': selectProduct?.productId,
        'quantity': "1",
      };
      Response response = await productRepo.buyProduct(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Successfully buyProduct ");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while buyProduct");
      }
    } catch (e) {
      log('ERROR AT buyProduct(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchProductDetails user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> fetchOrder() async {
    log('----------- fetchOrder Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
      };
      Response response = await productRepo.fetchOrder(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Successfully fetchOrder ");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while fetchOrder");
      }
    } catch (e) {
      log('ERROR AT fetchOrder(): $e');
      responseModel = ResponseModel(false, "Error while fetchOrder user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
