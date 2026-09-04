import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/dynamic_qr/dynamic_qr_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class CollectPaymentServiceScreen extends StatefulWidget {
  const CollectPaymentServiceScreen({super.key});

  @override
  State<CollectPaymentServiceScreen> createState() =>
      _CollectPaymentServiceScreenState();
}

class _CollectPaymentServiceScreenState
    extends State<CollectPaymentServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rechargeController = Get.find<RechargeController>();
      Get.find<BasicController>().setSelectTypeQR(null);
      rechargeController.amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(
        title: "Yes Bank Merchant",
      ),
      body: GetBuilder<RechargeController>(builder: (rechargeController) {
        return GetBuilder<BasicController>(builder: (basicController) {
          return SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomDropDownList(
                    heading: "QR Code Type",
                    hintText: "Select Type of QR",
                    borderRadius: 5,
                    bgColor: white,
                    borderColor: greyDark,
                    items: basicController.typeQRList,
                    value: basicController.selectTypeQR,
                    onChanged: (value) {
                      basicController.setSelectTypeQR(value);
                      if (basicController.selectTypeQR == "static QR") {
                        rechargeController.cleanAmount();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "select type of QR";
                      }
                      return null;
                    },
                  ),
                  sizedBoxHeight(height: 30),
                  AppTextFieldWithHeading(
                    controller: rechargeController.amountController,
                    hindText: "Amount",
                    heading: 'Amount',
                    borderRadius: 5,
                    textInputAction: TextInputAction.done,
                    bgColor: basicController.selectTypeQR == "static QR"
                        ? greyLight
                        : white,
                    borderColor: greyDark,
                    readOnly: basicController.selectTypeQR == "static QR",
                    preFixWidget: const Icon(
                      Icons.currency_rupee,
                      color: primaryColor,
                    ),
                    validator: basicController.selectTypeQR == "Dynamic QR"
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a amount";
                            }
                            return null;
                          }
                        : null,
                  ),
                  sizedBoxHeight(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 49),
                    child: CustomButton(
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await Get.find<BasicController>()
                              .postGenerateQR(
                            amount:
                                rechargeController.amountController.text.trim(),
                            isDynamic:
                                basicController.selectTypeQR == "Dynamic QR",
                          )
                              .then((value) {
                            if (value.isSuccess) {
                              DynamicQrSheet.show(context,
                                  rechargeController: rechargeController,
                                  basicController: Get.find<BasicController>(),
                                  isStaticQR: Get.find<BasicController>()
                                          .selectTypeQR ==
                                      'static QR');
                            } else {
                              showToast(
                                  message: value.message,
                                  typeCheck: value.isSuccess);
                            }
                          });
                        }
                      },
                      color: white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.qr_code,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "FETCH QR",
                            style:
                                Helper(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
