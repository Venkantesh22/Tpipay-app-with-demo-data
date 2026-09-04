import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dynamic_qr/dynamic_qr_screen.dart';

class RowOfDynamicQRAndROffer extends StatefulWidget {
  const RowOfDynamicQRAndROffer({super.key});

  @override
  State<RowOfDynamicQRAndROffer> createState() =>
      _RowOfDynamicQRAndROfferState();
}

class _RowOfDynamicQRAndROfferState extends State<RowOfDynamicQRAndROffer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.5, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GetBuilder<BasicController>(builder: (basicController) {
                  return GetBuilder<RechargeController>(
                      builder: (rechargeController) {
                    return CustomButton(
                      onTap: () {
                        if (rechargeController.isLoading) {
                          return;
                        }
                        // startCountdown();

                        basicController
                            .postGenerateQR(
                          amount: rechargeController
                              .selectRechargePackageDataModel?.rs
                              .toString(),
                          isDynamic: true,
                        )
                            .then((value) {
                          if (value.isSuccess) {
                            DynamicQrSheet.show(context,
                                rechargeController: rechargeController,
                                basicController: basicController,
                                isStaticQR: false);
                          } else {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          }
                        });
                      },
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svgsQr),
                          const SizedBox(width: 8),
                          Text(
                            "Pay via QR",
                            style: Helper(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                          )
                        ],
                      ),
                    );
                  });
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    // openDynamicQR();
                  },
                  height: 48,
                  color: origin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.svgsOffer),
                      const SizedBox(width: 8),
                      Text(
                        "R Offer",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
