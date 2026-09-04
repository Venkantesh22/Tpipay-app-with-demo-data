import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/add_balance_success/widget/top_up_bill_info_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/add_balance_success/widget/top_up_button.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/custom_appbar_card/custom_appbar_card_widget.dart';

class AddBalanceSuccessScreen extends StatelessWidget {
  const AddBalanceSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppForCard(title: "Top-up Success"),
      body: GetBuilder<CardController>(builder: (cardController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(
                  Assets.svgsCheckMarkInCirlce2,
                  height: 96,
                  width: 96,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Text(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        "Balance Added Successfully!",
                        style: Helper(context).textTheme.displayLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        "Your prepaid card has been successfully topped up and is ready for use.",
                        style: Helper(context).textTheme.displayLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: purpleLight,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 56),
                Text(
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  "ADD AMOUNT",
                  style: Helper(context).textTheme.displayLarge?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: purpleLight,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  PriceConverter.convertToNumberFormat(double.tryParse(
                          cardController.cardTapAmountController.text.trim()) ??
                      0.00),
                  style: Helper(context).textTheme.displayLarge?.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: blueDark,
                      ),
                ),
                TopUpSuccessBillInfoSection(),
                TopTupSuccessAndFailsButton(
                  firstButtonName: "Done",
                  firstOnTap: () {
                    pop(context);
                  },
                  secondButtonName: "Share Receipt",
                  secondOnTap: () {
                    pop(context);
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
