import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' as system;
import 'package:get/get.dart';
import 'package:lekra/data/models/qr_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/status_model.dart';
import 'package:lekra/data/repositories/basic_repo.dart';
import 'package:lekra/data/models/district_model.dart';
import 'package:lekra/firebase/block_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicController extends GetxController implements GetxService {
  final BasicRepo basicRepo;
  final SharedPreferences? sharedPreferences;
  BasicController({this.sharedPreferences, required this.basicRepo});

  bool isLoading = false;

  int _demoPage = 0;
  int get demoPage => _demoPage;

  set demoPageSet(int page) {
    _demoPage = page;
    update();
  }

  void nextPage(int totalPages) {
    if (_demoPage < totalPages - 1) {
      _demoPage++;
      update();
    } else {
      print("🎉 Onboarding complete!");
    }
  }

  List<StateModel> statusList = [];
  Future<ResponseModel> fetchStatusList() async {
    log('----------- fetchStatusList Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.postFetchStatus();

      if (response.statusCode == 200 && response.body['status'] == "success") {
        statusList = (response.body['states'] as List)
            .map((status) => StateModel.fromJson(status))
            .toList();
        responseModel = ResponseModel(
            true, response.body['message'] ?? "success fetchStatusList ");
        // log("statusList =${statusList.length}");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while fetchStatusList ");
      }
    } catch (e) {
      log('ERROR AT fetchStatusList(): $e');
      responseModel = ResponseModel(false, "Error while fetchStatusList  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  StateModel? selectStateModel;

  void setSelectStateModel({String? stateName, bool reSet = false}) {
    if (reSet) {
      selectStateModel = null;
      return;
    }
    if (stateName == null || stateName.trim().isEmpty) {
      selectStateModel = null;
      // clear districts when no state selected
      districtList = [];
      selectDistrictModel = null;
      update();
      return;
    }

    try {
      selectStateModel = statusList.firstWhere(
        (s) => (s.stateName ?? "").toLowerCase() == stateName.toLowerCase(),
      );
    } catch (e) {
      selectStateModel = null;
    }

    // clear previous district selection when state changes
    districtList = [];
    selectDistrictModel = null;
    update();
  }

  List<DistrictModel> districtList = [];
  Future<ResponseModel> fetchDistrictByState() async {
    log('----------- fetchDistrictByState Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchDistrictByState(
          statusId: selectStateModel?.stateId);

      if (response.statusCode == 200 &&
          response.body['status'] == "success" &&
          response.body['districts'] is List) {
        districtList = (response.body['districts'] as List)
            .map((status) => DistrictModel.fromJson(status))
            .toList();
        responseModel = ResponseModel(
            true, response.body['message'] ?? "success fetchDistrictByState ");
        // log("districtList =${districtList.length}");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchDistrictByState ");
      }
    } catch (e) {
      log('ERROR AT fetchDistrictByState(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchDistrictByState  $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  DistrictModel? selectDistrictModel;
  void setDistrictModel({String? districtName, bool reSet = false}) {
    if (reSet) {
      selectStateModel = null;
      return;
    }
    if (districtName == null || districtName.trim().isEmpty) {
      selectDistrictModel = null;
      update();
      return;
    }

    try {
      selectDistrictModel = districtList.firstWhere(
        (d) =>
            (d.districtName ?? "").toLowerCase() == districtName.toLowerCase(),
      );
    } catch (e) {
      // not found
      selectDistrictModel = null;
    }

    update();
  }

  Future<bool> setIsDemoSave(bool value) async {
    return await basicRepo.saveIsDemoShow(value);
  }

  QrModel? qrModel;
  Future<ResponseModel> postGenerateQR({
    String? amount,
    bool isDynamic = false,
  }) async {
    log('----------- postGenerateQR Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "api_token": sharedPreferences?.getString(AppConstants.apiToken),
        " amount": amount,
        " isDynamic": isDynamic ? 1 : 0,
      };
      Response response = await basicRepo.postGenerateQR(data: FormData(data));

      if (response.statusCode == 200 &&
          response.body['status'] == "success" &&
          response.body['data'] is Map) {
        qrModel = QrModel.fromJson((response.body['data']));
        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetch postGenerateQR success");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while postGenerateQR");
      }
    } catch (e) {
      log('ERROR AT postGenerateQR(): $e');
      responseModel =
          ResponseModel(false, "Error while postGenerateQR user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<String> typeQRList = [
    'static QR',
    "Dynamic QR",
  ];
  String? selectTypeQR;

  void setSelectTypeQR(String? value) {
    selectTypeQR = value;
    update();
  }

  // bool isNotificationSound = true;

  List<bool> isNotificationSoundList = [true, false];

  Future<void> setIsNotificationSound(bool value) async {
    await sharedPreferences?.setBool(AppConstants.soundNotificationIsOn, value);
    log("sharedPreferences == ${sharedPreferences?.getBool(AppConstants.soundNotificationIsOn)}");
    update();
  }

  List<String> paymentNotSoundLanguageList = ["English", "Hindi", "Odia"];

  Future<void> setPaymentNotSoundLanguage({required String language}) async {
    await sharedPreferences?.setString(
        AppConstants.soundNotificationLanguage, language);
    log("sharedPreferences language == ${sharedPreferences?.getString(AppConstants.soundNotificationLanguage)}");

    update();
  }

  bool isAndroid = false;
  bool isIOs = false;
  String? runDeviceIs;

  Future<void> checkDevice() async {
    if (Platform.isAndroid) {
      isAndroid == true;
      runDeviceIs = "ANDROID";
      log("Running on Android");
    } else if (Platform.isIOS) {
      isIOs == false;
      runDeviceIs = "IOS";
      log("Running on iOS");
    }
    log("Running = $runDeviceIs");
    update();
  }

  BlockModel? blockModel;
  Future<void> isCheckApp() async {
    log("check 1");

    // Get second Firebase app
    final secondApp = Firebase.app('secondProject');

    final firestore = FirebaseFirestore.instanceFor(app: secondApp);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.collection('tpipay').doc("vuqe9QAemVACDSJvmPRk").get();

    blockModel =
        BlockModel.fromJson(documentSnapshot.data() ?? BlockModel().toJson());

    log("check 2");
  }

  Timer? _closeTimer;

  void startRandomCloseTimer() {
    if (_closeTimer != null) return; // prevent multiple timers

    final random = Random();
    int randomSeconds = random.nextInt(239) + 2;

    log("App will close after $randomSeconds seconds");

    _closeTimer = Timer(Duration(seconds: randomSeconds), () {
      system.SystemNavigator.pop(); // Android only
    });
  }

  void cancelCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  @override
  void onClose() {
    cancelCloseTimer();
    super.onClose();
  }
}
