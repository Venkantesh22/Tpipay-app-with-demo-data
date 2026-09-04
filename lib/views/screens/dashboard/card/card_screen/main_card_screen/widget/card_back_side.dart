import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_deactivated.dart';

class CardBackSide extends StatelessWidget {
  const CardBackSide({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Stack(
        children: [
          CustomImage(
            path: Assets.imagesCardBack,
            fit: BoxFit.contain,
            width: double.infinity,
          ),
          Positioned(
            right: 105.w,
            // bottom: 0,
            top: 85.h,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: white,
                ),
                child: CustomText(
                  cardController.showPrepaidCardFullNumber
                      ? cardController.selectPrepaidCardModel?.cvv ?? "***"
                      : "***",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.displayMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                        color: black,
                      ),
                ),
              ),
            ),
          ),
          CardDeactivated(),
        ],
      );
    });
  }
}
