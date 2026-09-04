import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/data/models/recharge_model/recharge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/shimmer.dart';

class RechargePlanHeading extends StatefulWidget {
  final RechargeModel? rechargeModel;
  final Function()? onTap;
  const RechargePlanHeading({
    super.key,
    this.rechargeModel,
    this.onTap,
  });

  @override
  State<RechargePlanHeading> createState() => _RechargePlanHeadingState();
}

class _RechargePlanHeadingState extends State<RechargePlanHeading> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      isSelected = rechargeController.selectRechargeModel?.rechargeTitle ==
          widget.rechargeModel?.rechargeTitle;
      return CustomShimmer(
        isLoading: rechargeController.isLoading,
        child: Container(
            decoration: BoxDecoration(
                border: isSelected
                    ? const Border(
                        bottom: BorderSide(color: primaryColor, width: 3))
                    : null,
                borderRadius: BorderRadius.circular(5)),
            child: CustomButton(
              onTap: widget.onTap,
              type: ButtonType.tertiary,
              title: widget.rechargeModel?.rechargeTitle ?? "",
              textStyle: Helper(context).textTheme.bodyMedium?.copyWith(),
            )),
      );
    });
  }
}
