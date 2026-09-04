import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/repositories/mobile_service_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileServiceController extends GetxController implements GetxService {
  final MobileServiceRepo mobileServiceRepo;
  final SharedPreferences? sharedPreferences;

  MobileServiceController({
    required this.mobileServiceRepo,
    required this.sharedPreferences,
  });

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController confirmAccountNoController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController accountHolderNameCodeController =
      TextEditingController();

  TextEditingController transactionPinCodeController = TextEditingController();
  FocusNode confirmPinFocusNode = FocusNode();

  TextEditingController confirmTransactionPinCodeController =
      TextEditingController();
  FocusNode pinFocusNode = FocusNode();

  TextEditingController enterTransactionPinCodeController =
      TextEditingController();
  FocusNode enterPinFocusNode = FocusNode();



 TextEditingController amountController = TextEditingController();

}
