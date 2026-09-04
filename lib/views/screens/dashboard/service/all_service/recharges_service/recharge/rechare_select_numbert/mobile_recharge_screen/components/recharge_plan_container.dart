import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/data/models/recharge_model/recharge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_pay/recharge_pay_screen.dart';

class RechargePlanContainer extends StatelessWidget {
  final RechargePackageDataModel? rechargePackageDataModel;
  const RechargePlanContainer({
    super.key,
    required this.rechargePackageDataModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: primaryColorLight,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  spreadRadius: -4,
                  blurRadius: 6,
                  color: black.withValues(
                    alpha: 0.10,
                  ),
                ),
                BoxShadow(
                  offset: const Offset(0, 10),
                  spreadRadius: -3,
                  blurRadius: 15,
                  color: black.withValues(
                    alpha: 0.10,
                  ),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rechargePackageDataModel?.rsFormat ?? "",
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: black),
                        ),
                        Text(
                          "${rechargePackageDataModel?.validity ?? ""} validity",
                          style: Helper(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: black),
                        )
                      ],
                    ),
                    GetBuilder<RechargeController>(
                        builder: (rechargeController) {
                      return SizedBox(
                        width: 120,
                        child: CustomButton(
                          onTap: () {
                            rechargeController.setRechargePackageDataModel(
                                rechargePackageDataModel:
                                    rechargePackageDataModel);
                            rechargeController.amountController.text =
                                rechargeController
                                        .selectRechargePackageDataModel?.rs
                                        .toString() ??
                                    "";
                            if (rechargeController
                                    .selectRechargePackageDataModel !=
                                null) {
                              navigate(
                                  context: context,
                                  page: const RechargePayScreen());
                            }
                          },
                          radius: 12,
                          color: primaryColor,
                          child: Text(
                            "Pay",
                            style: Helper(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: grey,
                  ),
                ),
                Text(
                  rechargePackageDataModel?.desc ?? "",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
