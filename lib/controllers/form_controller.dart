import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/status_model.dart';
import 'package:lekra/data/repositories/form_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormController extends GetxController implements GetxService {
  final FormRepo formRepo;

  FormController({required this.formRepo});

  bool isLoading = false;

  /// selected heading index (0..2)
  int selectedIndex = 0;

  /// completion state for each section
  final List<bool> completed = [false, false, false];

  /// select a heading
  void selectIndex(int i) {
    if (i < 0 || i >= completed.length) return;
    selectedIndex = i;
    update(); // notify GetBuilder / GetBuilder listeners
  }

  /// explicitly set completion for a section
  void setComplete(int idx, bool value, {bool advanceIfTrue = false}) {
    if (idx < 0 || idx >= completed.length) return;
    completed[idx] = value;
    update();
    if (advanceIfTrue && value) {
      if (selectedIndex < completed.length - 1) {
        selectedIndex++;
        update();
      }
    }
  }

  /// toggle completion (handy for testing buttons)
  void toggleComplete(int idx) {
    if (idx < 0 || idx >= completed.length) return;
    completed[idx] = !completed[idx];
    update();
  }

  /// optional: mark all complete
  void markAllComplete() {
    for (var i = 0; i < completed.length; i++) {
      completed[i] = true;
    }
    update();
  }

  TextEditingController sellerIdentifierController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessNumberController = TextEditingController();
  TextEditingController businessEmailController = TextEditingController();
  TextEditingController businessMCCController = TextEditingController();
  String? turnoverType;
  String? acceptanceType;
  String? ownershipType;
  TextEditingController dateOfIncorporationController = TextEditingController();
  List<String> turnoverTypeList = [
    "SMALL",
    'LARGE',
  ];
  List<String> acceptanceTypeList = [
    "ONLINE",
    'OFFLINE',
  ];
  List<String> ownershipTypeList = [
    "PROPRIETARY",
    'PARTNERSHIP',
    'PRIVATE',
    'LLP',
    'SOCIETY',
    'TRUST',
    'GOVT',
    'HUF',
    'BOI',
    'AOP',
    'AJP',
  ];

  TextEditingController panNumberController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();
  TextEditingController settlementAccountNameController =
      TextEditingController();
  TextEditingController settlementAccountNumberController =
      TextEditingController();
  TextEditingController settlementAccountIFSCController =
      TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  StateModel? selectState;
  DistrictModel? selectDistrict;
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();

  Future<ResponseModel> postUploadKYC(BuildContext context) async {
    log('----------- postUploadKYC Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      // location
      final permissionController = Get.find<PermissionController>();
      if (permissionController.latitude == null ||
          permissionController.longitude == null) {
        await permissionController.requestLocationPermissionAndFetch(context);
      }
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
        'seller_identifier': sellerIdentifierController.text.trim(),
        'business_name': businessNameController.text.trim(),
        'mobile_number': businessNumberController.text.trim(),
        'email': businessEmailController.text.trim(),
        'mcc': businessMCCController.text.trim(),
        'turnover_type': turnoverType,
        'acceptance_type': acceptanceType,
        'ownership_type': ownershipType,
        'state_id': selectState?.stateId,
        'district_id': selectDistrict?.districtId,
        'city': cityController.text.trim(),
        'pincode': pincodeController.text.trim(),
        'pan_number': panNumberController.text.trim(),
        'gst_number': gstNumberController.text.trim(),
        'settlement_account_name': settlementAccountNameController.text.trim(),
        'settlement_account_number':
            settlementAccountNumberController.text.trim(),
        'settlement_account_ifsc': settlementAccountIFSCController.text.trim(),
        'dob': dateOfBirthController.text.trim(),
        'doi': dateOfIncorporationController.text.trim(),
        'address_line1': addressLine1Controller.text.trim(),
        'address_line2': addressLine2Controller.text.trim(),
        'latitude': permissionController.latitude,
        'longitude': permissionController.longitude,
      };
      Response response = await formRepo.postUploadKYC(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "success postUploadKYC ");
        panNumberController.clear();
        gstNumberController.clear();
        settlementAccountNameController.clear();
        settlementAccountNumberController.clear();
        settlementAccountIFSCController.clear();
        dateOfBirthController.clear();
        businessNameController.clear();
        sellerIdentifierController.clear();
        businessNumberController.clear();
        businessEmailController.clear();
        businessMCCController.clear();
        turnoverType = "";
        acceptanceType = "";
        ownershipType = "";
        dateOfIncorporationController.clear();
        cityController.clear();
        pincodeController.clear();
        addressLine1Controller.clear();
        addressLine2Controller.clear();
        selectState = null;
        selectDistrict = null;
      } else {
        String errorMessage = "seller_identifier";
        if (response.body['errors'] is Map) {
          var errors = response.body['errors'] as Map;
          if (errors.isNotEmpty) {
            var firstKey = errors.keys.first;
            errorMessage = errors[firstKey][0].toString();
          }
        } else {
          errorMessage = response.body['message'] ?? "Unknown Error";
        }
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e) {
      log('ERROR AT postUploadKYC(): $e');
      responseModel = ResponseModel(false, "Error while postUploadKYC  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void setTurnoverType(String? v) {
    turnoverType = v;
    update();
  }

  void setAcceptanceType(String? v) {
    acceptanceType = v;
    update();
  }

  void setOwnershipType(String? v) {
    ownershipType = v;
    update();
  }
}
