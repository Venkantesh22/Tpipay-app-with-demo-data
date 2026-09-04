import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';

class CardBalanceSection extends StatelessWidget {
  const CardBalanceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (cardController) {
        return CustomShimmer(
          isLoading: cardController.isLoading,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: BoxBorder.all(
                    width: 1, color: primaryColor.withValues(alpha: 0.20))),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 40,
                  width: 44,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    Assets.svgsCard,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(white, BlendMode.srcIn),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Balance",
                      style: Helper(context).textTheme.displayLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: purpleLight,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      PriceConverter.convertToNumberFormat(cardController.selectPrepaidCardBalance ?? 0.0),
                      style: Helper(context).textTheme.displayLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
