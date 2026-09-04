import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/data/models/prepaid_card/prapaid_card_user_check_status_model.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_details_model.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_mini_statement_model.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/status_model.dart';
import 'package:lekra/data/repositories/auth_repo.dart';
import 'package:lekra/data/repositories/card_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/widget/card_mini_statements_filter_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardController extends GetxController implements GetxService {
  final CardRepo cardRepo;
  final AuthRepo authRepo;
  final SharedPreferences sharedPreferences;

  CardController(
      {required this.cardRepo,
      required this.authRepo,
      required this.sharedPreferences});

  bool isLoading = false;

  String? title;
  final List<String> titleList = ["Mr.", "Mrs.", "Ms.", "Miss"];

  void updateTitle(String? value) {
    title = value;
    update();
  }

  String? gender;
  final List<String> genderList = ["Male", "Female"];

  void updateGender(String? value) {
    gender = value;
    update();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? ovd;
  final List<String> ovdList = [
    "AADHAAR",
    "PAN",
  ];
  final List<String> ovdListText = [
    "Aadhaar card",
    "Pan card",
  ];
  void updateOVD(String? value) {
    ovd = value;
    update();
  }

  final TextEditingController ovdIDController = TextEditingController();

  StateModel? state;
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();

  DistrictModel? selectCity;

  // String? selectProductCategory;

  // List<String> productCategoryList = ["GPR"];

  // String? cardNature;

  // List<String> cardNatureList = ['V', "P"];
  // List<String> cardNatureListText = ['Virtual Card', "Physical Card"];

  // void updateCardNature(String? value) {
  //   cardNature = value;
  //   update();
  // }

  // String? personalizationType = "Personalized";

  // final TextEditingController productNameController =
  //     TextEditingController(text: "TA TPIPAY GPR Card");

  String? cardRefNo;
  Future<ResponseModel> cardCustomOnBoarding() async {
    log('----------- cardCustomOnBoarding Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();
    final String dateFormated = DateFormatters()
        .yMD
        .format(convertStringToDate(dobController.text.trim()));

    final _title = title?.replaceAll(".", "");
    try {
      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'title': _title,
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'mobile_number': numberController.text.trim(),
        'dob': dateFormated,
        'ovd_type': ovd,
        'ovd_id': ovdIDController.text.trim(),
        'email': emailController.text.trim(),
        'gender': gender,
        'pincode': pinCodeController.text.trim(),
        'state': state?.stateName,
        'city': selectCity?.districtName,
        'address': fullAddressController.text.trim(),
        'channel': "WEB",
        'latitude': Get.find<PermissionController>().latitude,
        'longitude': Get.find<PermissionController>().longitude,
      };
      Response response =
          await cardRepo.cardCustomOnBoarding(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        cardRefNo = response.body['cardRefNo'];
        responseModel = ResponseModel(
            true, response.body['message'] ?? " cardCustomOnBoarding success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while cardCustomOnBoarding");
      }
    } catch (e) {
      log('ERROR AT cardCustomOnBoarding(): $e');
      responseModel =
          ResponseModel(false, "Error while cardCustomOnBoarding user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  bool isLoadingForGenerateOTPForPrepaidCard = false;
  String? otpRefId;
  Future<ResponseModel> generateOTPForPrepaidCard({
    required String? number,
  }) async {
    log('----------- generateOTPForPrepaidCard Called ----------');

    ResponseModel responseModel;
    isLoadingForGenerateOTPForPrepaidCard = true;
    otpRefId = "";
    update();

    try {
      String? latLong = Get.find<PermissionController>().latLongString;
      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'mobileNumber': number,
        'latLong': latLong,
        'channel': "WEB",
      };
      Response response =
          await cardRepo.generateOTPForPrepaidCard(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        otpRefId = response.body['otpRefId'];
        responseModel = ResponseModel(true,
            response.body['message'] ?? " generateOTPForPrepaidCard success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Error while generateOTPForPrepaidCard");
      }
    } catch (e) {
      log('ERROR AT generateOTPForPrepaidCard(): $e');
      responseModel =
          ResponseModel(false, "Error while generateOTPForPrepaidCard user $e");
    }

    isLoadingForGenerateOTPForPrepaidCard = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verificationOTPForPrepaidCard({
    required String otp,
    required String mobileNumber,
    required BuildContext context,
  }) async {
    log('----------- verificationOTPForPrepaidCard Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);
      String? latLong = Get.find<PermissionController>().latLongString;
      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'otp': otp,
        'otpRefId': otpRefId,
        'mobileNumber': mobileNumber,
        'channel': "WEB",
        'latLong': latLong,
      };
      Response response =
          await cardRepo.verificationOTPForPrepaidCard(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        responseModel = ResponseModel(true,
            response.body['message'] ?? " generateOTPForPrepaidCard success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Error while generateOTPForPrepaidCard");
      }
    } catch (e) {
      log('ERROR AT generateOTPForPrepaidCard(): $e');
      responseModel =
          ResponseModel(false, "Error while generateOTPForPrepaidCard user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  PrepaidCardModel? selectPrepaidCardModel;
  Future<ResponseModel> fetchCardDetailsByCardReference(
      {required BuildContext context}) async {
    log('----------- fetchCardDetailsByCardReference Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      String deviceId = await authRepo.getDeviceId();

      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);
      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'cardRefNo':
            prepaidCardUserStatusModel?.cardDetails?.card?.first.cardRefNo,
        'type': prepaidCardUserStatusModel?.cardDetails?.card?.first.cardType,
        'channel': Get.find<BasicController>().runDeviceIs,
        'latLong': latLong,
        'deviceId': deviceId,
      };

      if (AppConstants.isDemo) {
        selectPrepaidCardModel = PrepaidCardModel.demo();

        return ResponseModel(
          true,
          "Card details fetched successfully",
        );
      } else {
        Response response = await cardRepo.fetchCardDetailsByCardReference(
            data: FormData(data));

        if (response.statusCode == 200 && response.body['status_id'] == 1) {
          selectPrepaidCardModel =
              PrepaidCardModel.fromJson(response.body['cardData']);

          responseModel = ResponseModel(
              true,
              response.body['message'] ??
                  " fetchCardDetailsByCardReference success");
        } else {
          responseModel = ResponseModel(
              false,
              response.body['message'] ??
                  "Error while fetchCardDetailsByCardReference");
        }
      }
    } catch (e) {
      log('ERROR AT fetchCardDetailsByCardReference(): $e');
      responseModel = ResponseModel(
          false, "Error while fetchCardDetailsByCardReference user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  final TextEditingController cardTapAmountController = TextEditingController();

  void updateMoney(String value) {
    cardTapAmountController.text = value;
    update();
  }

  Future<ResponseModel> prepaidCardAddBalance(
      {required BuildContext context}) async {
    log('----------- prepaidCardAddBalance Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);
      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'amount': cardTapAmountController.text.trim(),
        'cardRefNo': "cardRefNo",
        'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
        'channel': "WEB",
        'latLong': latLong,
      };
      Response response =
          await cardRepo.prepaidCardAddBalance(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "SUCCESS") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? " prepaidCardAddBalance success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while prepaidCardAddBalance");
      }
    } catch (e) {
      log('ERROR AT prepaidCardAddBalance(): $e');
      responseModel =
          ResponseModel(false, "Error while prepaidCardAddBalance user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  // num? selectPrepaidCardBalance;
  // Future<ResponseModel> fetchPrepaidCardBalanceInquiry(
  //     {required BuildContext context}) async {
  //   log('----------- fetchPrepaidCardBalanceInquiry Called ----------');

  //   ResponseModel responseModel;
  //   isLoading = true;
  //   update();

  //   try {
  //     await Get.find<PermissionController>()
  //         .requestLocationPermissionAndFetch(context);
  //     String? latLong = Get.find<PermissionController>().latLongString;

  //     Map<String, dynamic> data = {
  //       'api_token': prepaidDetailsModel?.apiToken ?? "",
  //       'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
  //       'cardRefNo': selectPrepaidCardModel?.cardRefId,
  //       'channel': "WEB",
  //       'latLong': latLong,
  //     };
  //     Response response =
  //         await cardRepo.fetchPrepaidCardBalanceInquiry(data: FormData(data));

  //     if (response.statusCode == 200 && response.body['status_id'] == 1) {
  //       selectPrepaidCardBalance = response.body['balance'];
  //       responseModel = ResponseModel(
  //           true,
  //           response.body['message'] ??
  //               " fetchPrepaidCardBalanceInquiry success");
  //     } else {
  //       responseModel = ResponseModel(
  //           false,
  //           response.body['message'] ??
  //               "Error while fetchPrepaidCardBalanceInquiry");
  //     }
  //   } catch (e) {
  //     log('ERROR AT fetchPrepaidCardBalanceInquiry(): $e');
  //     responseModel = ResponseModel(
  //         false, "Error while fetchPrepaidCardBalanceInquiry user $e");
  //   }

  //   isLoading = false;
  //   update();
  //   return responseModel;
  // }


  Future<ResponseModel> fetchPrepaidCardBalanceInquiry({
    required BuildContext context,
  }) async {
    log('----------- fetchPrepaidCardBalanceInquiry Called ----------');

    isLoading = true;
    update();

    try {
      // =========================================================
      // DEMO MODE
      // =========================================================
      if (AppConstants.isDemo) {
        selectPrepaidCardBalance = 18750.75;

        return ResponseModel(
          true,
          "Balance fetched successfully",
        );
      }

      // =========================================================
      // REAL API
      // =========================================================

      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);

      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
        'cardRefNo': selectPrepaidCardModel?.cardRefId,
        'channel': "WEB",
        'latLong': latLong,
      };

      Response response = await cardRepo.fetchPrepaidCardBalanceInquiry(
        data: FormData(data),
      );

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['status_id'] == 1) {
        selectPrepaidCardBalance = response.body['balance'];

        return ResponseModel(
          true,
          response.body['message'] ?? "fetchPrepaidCardBalanceInquiry success",
        );
      }

      return ResponseModel(
        false,
        response.body?['message'] ??
            "Error while fetchPrepaidCardBalanceInquiry",
      );
    } catch (e) {
      log('ERROR AT fetchPrepaidCardBalanceInquiry(): $e');

      return ResponseModel(
        false,
        "Error while fetchPrepaidCardBalanceInquiry user $e",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> prepaidCardResetPIN(
      {required BuildContext context, required String pin}) async {
    log('----------- prepaidCardResetPIN Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      String deviceId = await authRepo.getDeviceId();
      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);
      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'pin': pin,
        'cardRefNo': selectPrepaidCardModel?.cardRefId ?? "",
        "deviceId": deviceId,
        'channel': "WEB",
        'latLong': latLong,
      };
      Response response =
          await cardRepo.prepaidCardResetPIN(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "SUCCESS") {
        responseModel = ResponseModel(
            true, response.body['message'] ?? " prepaidCardResetPIN success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while prepaidCardResetPIN");
      }
    } catch (e) {
      log('ERROR AT prepaidCardResetPIN(): $e');
      responseModel =
          ResponseModel(false, "Error while prepaidCardResetPIN user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  bool isApplyForPrepaidCard = false;
  PrepaidCardUserStatusModel? prepaidCardUserStatusModel;

  // Future<ResponseModel> prepaidCheckUserStatus({
  //   required BuildContext context,
  // }) async {
  //   log('----------- prepaidCheckUserStatus Called ----------');

  //   ResponseModel responseModel;
  //   isLoading = true;
  //   update();

  //   try {
  //     String deviceId = await authRepo.getDeviceId();
  //     await Get.find<PermissionController>()
  //         .requestLocationPermissionAndFetch(context);
  //     String? latLong = Get.find<PermissionController>().latLongString;

  //     Map<String, dynamic> data = {
  //       'api_token': prepaidDetailsModel?.apiToken ?? "",
  //       'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
  //       'latLong': latLong,
  //       "deviceId": deviceId,
  //       'channel': "WEB",
  //     };
  //     Response response =
  //         await cardRepo.prepaidCheckUserStatus(data: FormData(data));

  //     if (response.statusCode == 200 && response.body['status'] == "success") {
  //       prepaidCardUserStatusModel =
  //           PrepaidCardUserStatusModel.fromJson(response.body['data']);

  //       responseModel = ResponseModel(true,
  //           response.body['message'] ?? " prepaidCheckUserStatus success");
  //     } else {
  //       responseModel = ResponseModel(false,
  //           response.body['message'] ?? "Error while prepaidCheckUserStatus");
  //     }
  //   } catch (e) {
  //     log('ERROR AT prepaidCheckUserStatus(): $e');
  //     responseModel =
  //         ResponseModel(false, "Error while prepaidCheckUserStatus user $e");
  //   }

  //   isLoading = false;
  //   update();
  //   return responseModel;
  // }

  Future<ResponseModel> prepaidCheckUserStatus({
    required BuildContext context,
  }) async {
    log('----------- prepaidCheckUserStatus Called ----------');

    isLoading = true;
    update();

    try {
      // =========================================================
      // DEMO MODE
      // =========================================================
      if (AppConstants.isDemo) {
        log('----------- prepaidCheckUserStatus DEMO MODE ----------');

        // We don't need the real user-status API for demo.
        // MainCardScreen will continue to fetch the demo card.
        return ResponseModel(
          true,
          "Card user status fetched successfully",
        );
      }

      // =========================================================
      // REAL API
      // =========================================================
      String deviceId = await authRepo.getDeviceId();

      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);

      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
        'latLong': latLong,
        "deviceId": deviceId,
        'channel': "WEB",
      };

      Response response = await cardRepo.prepaidCheckUserStatus(
        data: FormData(data),
      );

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['status'] == "success") {
        prepaidCardUserStatusModel =
            PrepaidCardUserStatusModel.fromJson(response.body['data']);

        return ResponseModel(
          true,
          response.body['message'] ?? "prepaidCheckUserStatus success",
        );
      }

      return ResponseModel(
        false,
        response.body?['message'] ?? "Error while prepaidCheckUserStatus",
      );
    } catch (e) {
      log('ERROR AT prepaidCheckUserStatus(): $e');

      return ResponseModel(
        false,
        "Error while prepaidCheckUserStatus user $e",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // List<PrepaidCardMiniStatementModel> prepaidCardMiniStatementModelList = [];
  // Future<ResponseModel> fetchPrepaidCardMiniStatement({
  //   required BuildContext context,
  // }) async {
  //   log('----------- fetchPrepaidCardMiniStatement Called ----------');

  //   ResponseModel responseModel;
  //   isLoading = true;
  //   update();

  //   try {
  //     String deviceId = await authRepo.getDeviceId();
  //     await Get.find<PermissionController>()
  //         .requestLocationPermissionAndFetch(context);
  //     String? latLong = Get.find<PermissionController>().latLongString;

  //     Map<String, dynamic> data = {
  //       'api_token': prepaidDetailsModel?.apiToken ?? "",
  //       'cardRefNumber': selectPrepaidCardModel?.cardRefId,
  //       'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
  //       'channel': "WEB",
  //       'latLong': latLong,
  //       "deviceId": deviceId,
  //     };
  //     Response response =
  //         await cardRepo.fetchPrepaidCardMiniStatement(data: FormData(data));

  //     if (response.statusCode == 200 && response.body['status'] == "success") {
  //       prepaidCardMiniStatementModelList =
  //           (response.body['transactions'] as List)
  //               .map<PrepaidCardMiniStatementModel>(
  //                   (e) => PrepaidCardMiniStatementModel.fromJson(e))
  //               .toList();

  //       // prepaidCardMiniStatementModelList = prepaidCardMiniStatementModelListForModel;

  //       responseModel = ResponseModel(
  //           true,
  //           response.body['message'] ??
  //               " fetchPrepaidCardMiniStatement success");
  //     } else {
  //       responseModel = ResponseModel(
  //           false,
  //           response.body['message'] ??
  //               "Error while fetchPrepaidCardMiniStatement");
  //     }
  //   } catch (e) {
  //     log('ERROR AT fetchPrepaidCardMiniStatement(): $e');
  //     responseModel = ResponseModel(
  //         false, "Error while fetchPrepaidCardMiniStatement user $e");
  //   }

  //   isLoading = false;
  //   update();
  //   return responseModel;
  // }

  List<PrepaidCardMiniStatementModel> prepaidCardMiniStatementModelList = [];

  Future<ResponseModel> fetchPrepaidCardMiniStatement({
    required BuildContext context,
  }) async {
    log('----------- fetchPrepaidCardMiniStatement Called ----------');

    isLoading = true;
    update();

    try {
      // =========================================================
      // DEMO MODE
      // =========================================================
      if (AppConstants.isDemo) {
        log('----------- Loading Demo Mini Statements ----------');

        prepaidCardMiniStatementModelList =
            List<PrepaidCardMiniStatementModel>.from(
          prepaidCardMiniStatementModelListForModel,
        );

        return ResponseModel(
          true,
          "Mini statements fetched successfully",
        );
      }

      // =========================================================
      // REAL API
      // =========================================================

      String deviceId = await authRepo.getDeviceId();

      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);

      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        'api_token': prepaidDetailsModel?.apiToken ?? "",
        'cardRefNumber': selectPrepaidCardModel?.cardRefId,
        'mobileNumber': prepaidDetailsModel?.mobileNumber ?? "",
        'channel': "WEB",
        'latLong': latLong,
        "deviceId": deviceId,
      };

      Response response = await cardRepo.fetchPrepaidCardMiniStatement(
        data: FormData(data),
      );

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['status'] == "success") {
        prepaidCardMiniStatementModelList =
            (response.body['transactions'] as List)
                .map<PrepaidCardMiniStatementModel>(
                  (e) => PrepaidCardMiniStatementModel.fromJson(e),
                )
                .toList();

        return ResponseModel(
          true,
          response.body['message'] ?? "fetchPrepaidCardMiniStatement success",
        );
      }

      return ResponseModel(
        false,
        response.body?['message'] ??
            "Error while fetchPrepaidCardMiniStatement",
      );
    } catch (e) {
      log('ERROR AT fetchPrepaidCardMiniStatement(): $e');

      return ResponseModel(
        false,
        "Error while fetchPrepaidCardMiniStatement user $e",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  PrepaidDetailsModel? prepaidDetailsModel;
  Future<ResponseModel> fetchPrepaidCardDetails({
    required BuildContext context,
  }) async {
    log('----------- fetchPrepaidCardDetails Called ----------');

    isLoading = true;
    update();

    try {
      // =========================================================
      // DEMO MODE
      // =========================================================
      if (AppConstants.isDemo) {
        prepaidDetailsModel = PrepaidDetailsModel.demo();

        isApplyForPrepaidCard = true;

        return ResponseModel(
          true,
          "Prepaid card details fetched successfully",
        );
      }

      // =========================================================
      // REAL API
      // =========================================================
      final userMobileNumber =
          Get.find<AuthController>().userModel?.mobile ?? "";

      Map<String, dynamic> data = {
        "mobile_number": userMobileNumber,
      };

      Response response = await cardRepo.fetchPrepaidCardDetails(
        data: FormData(data),
      );

      // =========================================================
      // SUCCESS
      // =========================================================
      if (response.statusCode == 200 && response.body['status'] == true) {
        prepaidDetailsModel =
            PrepaidDetailsModel.fromJson(response.body['data']);

        if (prepaidDetailsModel?.mobileNumber != null &&
            prepaidDetailsModel?.mobileNumber != "null" &&
            (prepaidDetailsModel?.mobileNumber?.isNotEmpty ?? false)) {
          isApplyForPrepaidCard = true;

          return ResponseModel(
            true,
            response.body['message'] ?? "fetchPrepaidCardDetails success",
          );
        }

        // =======================================================
        // USER HAS NOT APPLIED / NO CARD DETAILS
        // =======================================================
        isApplyForPrepaidCard = false;

        return ResponseModel(
          false,
          response.body['message'] ?? "Prepaid card details not found",
        );
      }

      // ===========================================================
      // API ERROR
      // ===========================================================
      isApplyForPrepaidCard = false;

      return ResponseModel(
        false,
        response.body['message'] ?? "Error while fetchPrepaidCardDetails",
      );
    } catch (e) {
      log('ERROR AT fetchPrepaidCardDetails(): $e');

      isApplyForPrepaidCard = false;

      return ResponseModel(
        false,
        "Error while fetchPrepaidCardDetails user $e",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel> fetchPrepaidCardCVVNo({
    required BuildContext context,
  }) async {
    log('----------- fetchPrepaidCardCVVNo Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      await Get.find<PermissionController>()
          .requestLocationPermissionAndFetch(context);
      String? latLong = Get.find<PermissionController>().latLongString;

      Map<String, dynamic> data = {
        "api_token": prepaidDetailsModel?.apiToken ?? "",
        "cardRefNo": prepaidDetailsModel?.cardRefId ?? "",
        "channel": "WEB",
        "latLong": latLong,
      };

      Response response =
          await cardRepo.fetchPrepaidCardCVVNo(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        String? _cvv = response.body['cvv'];
        _cvv = _cvv?.replaceAll('"', '');
        selectPrepaidCardModel = selectPrepaidCardModel?.copyWith(cvv: _cvv);

        responseModel = ResponseModel(
            true, response.body['message'] ?? " fetchPrepaidCardCVVNo success");
      } else {
        isApplyForPrepaidCard = false;
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchPrepaidCardCVVNo");
      }
    } catch (e) {
      log('ERROR AT fetchPrepaidCardCVVNo(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchPrepaidCardCVVNo user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  CardTransFilterModel? selectCardTransFilterModel;

  void updateCardTransFilter({required CardTransFilterModel value}) {
    selectCardTransFilterModel = value;
  }

  bool showPrepaidCardFullNumber = false;
  void updateShowPrepaidCardFullNumber({required bool value}) {
    showPrepaidCardFullNumber = value;
    update();
  }

  //!---------------------------------------------
  num? selectPrepaidCardBalance = 18750.75;

void updatePrepaidCardBalance(num amount) {
  selectPrepaidCardBalance = amount;
  update();
}

void addPrepaidCardBalance(num amount) {
  selectPrepaidCardBalance =
      (selectPrepaidCardBalance ?? 0) + amount;
  update();
}

void deductPrepaidCardBalance(num amount) {
  final currentBalance = selectPrepaidCardBalance ?? 0;

  if (amount > currentBalance) {
    return;
  }

  selectPrepaidCardBalance = currentBalance - amount;
  update();
}
}
