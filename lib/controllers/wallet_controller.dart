import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/repositories/wallet_repo.dart';

class WalletController extends GetxController implements GetxService {
  final WalletRepo walletRepo;
  WalletController({required this.walletRepo});

  bool isLoading = false;

  TextEditingController addMoneyController = TextEditingController();

  void setPrice(String value) {
    addMoneyController.text = value;
  }
}
