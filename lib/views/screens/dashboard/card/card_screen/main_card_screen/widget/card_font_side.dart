import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/card_deactivated.dart';

class CardFontSide extends StatelessWidget {
  const CardFontSide({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Stack(
        children: [
          CustomImage(
            path: Assets.imagesCardFrondSide,
            fit: BoxFit.contain,
            width: double.infinity,
          ),
          Positioned(
            bottom: 30.h,
            left: 40.w,
            right: 24.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        cardController.showPrepaidCardFullNumber
                            ? cardController
                                    .selectPrepaidCardModel?.formatCardNumber ??
                                ""
                            : cardController.selectPrepaidCardModel
                                    ?.formatCardNumberLastFourDigit ??
                                "",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        style:
                            Helper(context).textTheme.displayMedium?.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: white,
                                ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          cardController.updateShowPrepaidCardFullNumber(
                              value: !cardController.showPrepaidCardFullNumber);
                        },
                        icon: Icon(
                            cardController.showPrepaidCardFullNumber
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: white.withValues(alpha: 0.70)))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "VALID\nTHRU",
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontSize: 6.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                            color: white.withValues(alpha: 1),
                          ),
                    ),
                    CustomText(
                      " ${cardController.selectPrepaidCardModel?.expiryDate ?? ""}",
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.displayMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "CARD HOLDER",
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.3,
                                      color: white.withValues(alpha: 0.70),
                                    ),
                          ),
                          CustomText(
                            cardController.selectPrepaidCardModel?.nameOnCard ??
                                "",
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: Helper(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          CardDeactivated()
        ],
      );
    });
  }
}
