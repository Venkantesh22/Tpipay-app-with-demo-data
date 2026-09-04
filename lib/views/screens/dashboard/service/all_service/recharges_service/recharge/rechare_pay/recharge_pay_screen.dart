import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/lanch_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_pay/components/row_of_dynamic_qy_roffer.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class RechargePayScreen extends StatefulWidget {
  const RechargePayScreen({super.key});

  @override
  State<RechargePayScreen> createState() => _RechargePayScreenState();
}

class _RechargePayScreenState extends State<RechargePayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rechargeController = Get.find<RechargeController>();
      if (Get.find<AuthController>().selectServiceModel?.serviceImage ==
          "Mobile Postpaid") {
        rechargeController.fetchPrepaidROffer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: black,
          ),
        ),
        title: Text(
          Get.find<AuthController>().selectServiceModel?.serviceName ?? "",
          style: Helper(context).textTheme.titleSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: GetBuilder<RechargeController>(builder: (rechargeController) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          child: Column(
            children: [
              AppTextFieldWithHeading(
                controller: rechargeController.mobileNumberController,
                hindText: "1234567890",
                heading: "Mobile Number",
                bgColor: white,
                borderColor: greyDark,
                readOnly: true,
                suffix: IconButton(
                  onPressed: () => pop(context),
                  icon: const Icon(
                    Icons.edit,
                    color: primaryColor,
                  ),
                ),
                borderRadius: 5,
                preFixWidget: const Icon(Icons.call, color: primaryColor),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length != 10) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              sizedBoxHeight(height: 15),
              AppTextFieldWithHeading(
                controller: rechargeController.providerController,
                hindText: "joi, Airtel ...",
                heading: "Provider",
                bgColor: white,
                borderColor: greyDark,
                borderRadius: 5,
                preFixWidget: const Icon(Icons.call, color: primaryColor),
              ),
              sizedBoxHeight(height: 15),
              GetBuilder<BasicController>(builder: (basicController) {
                return CustomShimmer(
                  isLoading: basicController.isLoading,
                  child: CustomDropDownList(
                    items: basicController.statusList
                        .map((s) => s.stateName ?? "")
                        .toList(),
                    value: basicController.selectStateModel?.stateName,
                    heading: "State",
                    bgColor: white,
                    borderColor: greyDark,
                    preFixWidget: const Icon(Icons.location_on_outlined,
                        color: primaryColor),
                    borderRadius: 5,
                    onChanged: (value) {
                      basicController.setSelectStateModel(stateName: value);
                    },
                  ),
                );
              }),
              sizedBoxHeight(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            offset: const Offset(-4, 6),
                            blurRadius: 7,
                            spreadRadius: 0,
                            color: black.withValues(alpha: 0.25))
                      ]),
                      child: AppTextFieldWithHeading(
                        controller: rechargeController.amountController,
                        hindText: "amount",
                        bgColor: white,
                        borderColor: greyDark,
                        borderRadius: 5,
                        preFixWidget: const Icon(Icons.currency_rupee_sharp,
                            color: primaryColor),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 27,
                  ),
                  SizedBox(
                    width: 143,
                    child: CustomButton(
                      onTap: () => pop(context),
                      elevation: 5,
                      color: white,
                      borderColor: primaryColor,
                      child: Text(
                        "View Plan",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
               sizedBoxHeight(height: 15,
              ),
              CustomButton(
                onTap: () {},
                color: secondaryColor,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.svgsSecurity,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Generate Transaction PIN",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: white),
                    )
                  ],
                ),
              ),
              const RowOfDynamicQRAndROffer(),
              sizedBoxHeight(height: 15),
              CustomButton(
                onTap: () async {
                  await rechargeController
                      .payRechargeViaUpi(context)
                      .then((value) {
                    if (value.isSuccess) {
                      LaunchHelper.launchUpiViaSystemChooser(
                          rechargeController.upiModel?.qrString ?? "");
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    }
                  });
                },
                height: 48,
                radius: 8,
                color: white,
                borderColor: primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.svgsMobile),
                    const SizedBox(width: 8),
                    Text(
                      "Recharge via UPI",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
