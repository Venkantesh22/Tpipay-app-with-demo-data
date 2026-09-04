import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/data/models/dth/dth_custom_info_model.dart';
import 'package:lekra/data/models/dth/dth_plan_model.dart';
import 'package:lekra/data/models/provider_model.dart';
import 'package:lekra/data/models/recharge_model/recharge_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/status_model.dart';
import 'package:lekra/data/models/upi_model.dart';
import 'package:lekra/data/repositories/recharge_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RechargeController extends GetxController implements GetxService {
  final RechargeRepo rechargeRepo;
  final SharedPreferences? sharedPreferences;

  RechargeController({
    required this.rechargeRepo,
    required this.sharedPreferences,
  });

  bool isLoading = false;

  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void cleanAmount() {
    Get.find<RechargeController>().amountController.clear();
    update();
  }

  ProviderModel? selectProviderModel;

  Future<ResponseModel> postFetchProvider() async {
    log('----------- postFetchProvider Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        'api_token': sharedPreferences?.getString(AppConstants.apiToken),
        'mobile_number': mobileNumberController.text.trim(),
      };
      Response response = await rechargeRepo.postFetchProvider(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        selectProviderModel = ProviderModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? "postFetchProvider fetch");
        providerController.text = selectProviderModel?.providerName ?? "";
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while postFetchProvider ");
      }
    } catch (e) {
      log('ERROR AT postFetchProvider(): $e');
      responseModel = ResponseModel(false, "Error while postFetchProvider  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String? providerId;
  StateModel? selectState;
  List<RechargeModel> rechargeList = [];

  Future<ResponseModel> fetchPrepaidPlans() async {
    log('----------- fetchPrepaidPlans Called ----------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        'api_token': sharedPreferences?.getString(AppConstants.apiToken),
        'provider_id': selectProviderModel?.providerId ?? "",
        'state_id': selectProviderModel?.stateId,
      };

      final response =
          await rechargeRepo.fetchPrepaidPlans(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        final payload = response.body as Map<String, dynamic>;
        final dataMap = payload['data'] as Map<String, dynamic>?;

        rechargeList = RechargeModel.listFromApiMap(dataMap ?? {});
        selectRechargeModel =
            rechargeList.isNotEmpty ? rechargeList.first : null;

        allRechargePackageDataModelList.clear();
        for (var plan in rechargeList) {
          allRechargePackageDataModelList
              .addAll(plan.rechargePackageDataModelList ?? []);
        }

        searchRechargePackageDataModelList.clear();
        if (selectRechargeModel?.rechargePackageDataModelList != null) {
          searchRechargePackageDataModelList
              .addAll(selectRechargeModel!.rechargePackageDataModelList!);
        }

        responseModel =
            ResponseModel(true, payload['message'] ?? 'Plans fetched');
        log("rechargeList list : - ${rechargeList.length}");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while fetching plans");
      }
    } catch (e, st) {
      log('ERROR AT fetchPrepaidPlans(): $e\n$st');
      responseModel = ResponseModel(false, "Error while fetching plans: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  RechargeModel? selectRechargeModel;

  void setRechargeModel({required RechargeModel? value}) {
    selectRechargeModel = value;

    // Keep search list in sync with selected provider
    searchRechargePackageDataModelList.clear();
    if (selectRechargeModel?.rechargePackageDataModelList != null) {
      searchRechargePackageDataModelList
          .addAll(selectRechargeModel!.rechargePackageDataModelList!);
    }

    update();
  }

  final List<RechargePackageDataModel> allRechargePackageDataModelList = [];

  final List<RechargePackageDataModel> searchRechargePackageDataModelList = [];

  void onSearchTextChanged(String rawValue) {
    final value = rawValue.trim();

    if (value.isEmpty) {
      searchRechargePackageDataModelList.clear();
      if (selectRechargeModel?.rechargePackageDataModelList != null) {
        searchRechargePackageDataModelList
            .addAll(selectRechargeModel!.rechargePackageDataModelList!);
      } else {
        searchRechargePackageDataModelList
            .addAll(allRechargePackageDataModelList);
      }
      update();
      return;
    }

    // Try numeric match first
    final int? amount = int.tryParse(value);

    try {
      searchRechargePackageDataModelList.clear();

      if (amount != null) {
        // exact numeric match on rs (assuming rs is int or parseable)
        searchRechargePackageDataModelList
            .addAll(allRechargePackageDataModelList.where((pkg) {
          final pkgRs = pkg.rs;
          if (pkgRs == null) return false;
          // pkg.rs might be int or string; normalize
          if (pkgRs is int) return pkgRs == amount;
          final parsed = int.tryParse(pkgRs.toString());
          return parsed != null && parsed == amount;
        }).toList());
      }
    } catch (e) {
      log('ERROR IN _performSearch: $e');
      searchRechargePackageDataModelList.clear();
    }

    update();
  }

  RechargePackageDataModel? selectRechargePackageDataModel;

  void setRechargePackageDataModel(
      {required RechargePackageDataModel? rechargePackageDataModel}) {
    selectRechargePackageDataModel = rechargePackageDataModel;
    update();
  }

  Future<ResponseModel> fetchPrepaidROffer() async {
    log('----------- fetchPrepaidROffer Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        'api_token': sharedPreferences?.getString(AppConstants.apiToken),
        'provider_id': selectProviderModel?.providerId,
        'mobile_number': mobileNumberController.text.trim(),
      };
      Response response = await rechargeRepo.fetchPrepaidROffer(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        selectProviderModel = ProviderModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchPrepaidROffer fetch");
        providerController.text = selectProviderModel?.providerName ?? "";
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchPrepaidROffer ");
      }
    } catch (e) {
      log('ERROR AT fetchPrepaidROffer(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchPrepaidROffer  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  UpiModel? upiModel;
  Future<ResponseModel> payRechargeViaUpi(BuildContext context) async {
    log('-----------    payRechargeViaUpi Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();
    final permissionController = Get.find<PermissionController>();
    if (permissionController.latitude == null ||
        permissionController.longitude == null) {
      await permissionController.requestLocationPermissionAndFetch(context);
    }

    try {
      final Map<String, dynamic> data = {
        'api_token': sharedPreferences?.getString(AppConstants.apiToken),
        'provider_id': selectProviderModel?.providerId,
        'number': mobileNumberController.text.trim(),
        'amount': amountController.text.trim(),
        'latitude': permissionController.latitude,
        'longitude': permissionController.longitude,
      };
      Response response = await rechargeRepo.payRechargeViaUpi(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        upiModel = UpiModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? "payRechargeViaUpi pay");
        providerController.text = selectProviderModel?.providerName ?? "";
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while payRechargeViaUpi ");
      }
    } catch (e) {
      log('ERROR AT payRechargeViaUpi(): $e');
      responseModel = ResponseModel(false, "Error while payRechargeViaUpi  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  DhtCustomerInfoModel? dhtCustomerInfoModel;
  Future<ResponseModel> fetchDTHCustomerInfo() async {
    log('-----------    fetchDTHCustomerInfo Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        'api_token': sharedPreferences?.getString(AppConstants.apiToken),
        'provider_id': 11,
        'number': mobileNumberController.text.trim(),
      };
      Response response = await rechargeRepo.fetchDTHCustomerInfo(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        dhtCustomerInfoModel =
            DhtCustomerInfoModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchDTHCustomerInfo fetch");
        providerController.text = selectProviderModel?.providerName ?? "";
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchDTHCustomerInfo ");
      }
    } catch (e) {
      log('ERROR AT fetchDTHCustomerInfo(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchDTHCustomerInfo  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  DhtPlanModel? dhtPlanModel;
  Future<ResponseModel> fetchDTHPlan() async {
    log('-----------    fetchDTHPlan Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final Map<String, dynamic> data = {
        'api_token': sharedPreferences?.getString(AppConstants.apiToken),
        'provider_id': 10,
      };
      Response response = await rechargeRepo.fetchDTHPlan(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        dhtPlanModel = DhtPlanModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchDTHPlan fetch");
        providerController.text = selectProviderModel?.providerName ?? "";
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while fetchDTHPlan ");
      }
    } catch (e) {
      log('ERROR AT fetchDTHPlan(): $e');
      responseModel = ResponseModel(false, "Error while fetchDTHPlan  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void reSet() {
    mobileNumberController.clear();
    providerController.clear();
    amountController.clear();
    selectProviderModel = null;
    providerId = null;
    selectState = null;
    rechargeList = [];
    selectRechargeModel = null;
  }
}
