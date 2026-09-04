import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';

class CardMiniStatementsTopSection extends StatelessWidget {
  const CardMiniStatementsTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return CustomShimmer(
        isLoading: cardController.isLoading,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Available Balance",
                    style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                  ),
                  Text(
                    "**** ${cardController.selectPrepaidCardModel?.lastFourDigit ?? ""}",
                    style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                PriceConverter.convertToNumberFormat(cardController.selectPrepaidCardBalance ?? 0.0),
                style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: white,
                    ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
