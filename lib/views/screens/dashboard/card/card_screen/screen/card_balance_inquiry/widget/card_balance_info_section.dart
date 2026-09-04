import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/card_mini_statements_screen.dart';

class CardBalanceInfoSection extends StatelessWidget {
  const CardBalanceInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return CustomShimmer(
        isLoading: cardController.isLoading,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: primaryColor.withValues(alpha: 0.10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: -4,
                  color: black.withValues(alpha: 0.10),
                ),
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: -3,
                  color: black.withValues(alpha: 0.10),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prepaid Card",
                style: Helper(context).textTheme.displayLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
              ),
              SizedBox(height: 12),
              Text(
                PriceConverter.convertToNumberFormat(
                    cardController.selectPrepaidCardBalance ?? 0),
                style: Helper(context).textTheme.displayLarge?.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: blueDark,
                    ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Available Balance",
                      style: Helper(context).textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: blueDark,
                          ),
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        navigate(
                            context: context, page: CardMimiStatementsScreen());
                      },
                      radius: 12,
                      height: 36,
                      child: Text(
                        "View Statement",
                        style: Helper(context).textTheme.displayLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: white,
                            ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
