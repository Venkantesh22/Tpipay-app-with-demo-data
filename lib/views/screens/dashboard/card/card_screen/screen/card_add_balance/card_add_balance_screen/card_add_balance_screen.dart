// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/add_balance_fails/add_balance_fails_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/add_balance_success/add_balance_success_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/card_add_balance_screen/widget/card_balance_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/card_add_balance_screen/widget/top_amount_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/custom_appbar_card/custom_appbar_card_widget.dart';

class CardAddBalanceScreen extends StatefulWidget {
  const CardAddBalanceScreen({super.key});

  @override
  State<CardAddBalanceScreen> createState() => _CardAddBalanceScreenState();
}

class _CardAddBalanceScreenState extends State<CardAddBalanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardController = Get.find<CardController>();
      cardController.cardTapAmountController.clear();

      cardController
          .fetchPrepaidCardBalanceInquiry(context: context)
          .then((value) {
        if (!value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
          cardController.update();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppForCard(title: "Add Balance"),
      bottomNavigationBar:
          GetBuilder<CardController>(builder: (cardController) {
        return Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                isLoading: cardController.isLoading,
                height: 56,
                radius: 12,
                onTap: () {
                  cardController
                      .prepaidCardAddBalance(context: context)
                      .then((value) {
                    if (value.isSuccess) {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                      navigate(
                          context: context, page: AddBalanceSuccessScreen());
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                      navigate(context: context, page: AddBalanceFailsScreen(reason: value.message ,));
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.svgsPlusCircle),
                    SizedBox(width: 8),
                    Text(
                      "Add Balance Now",
                      style: Helper(context).textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                "SECURED BY INDUSTRY-STANDARD ENCRYPTION",
                style: Helper(context).textTheme.displayLarge?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: purpleLight,
                    ),
              ),
            ],
          ),
        );
      }),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            SizedBox(height: 12),
            CardBalanceSection(),
            TopAmountSection(),
          ],
        ),
      ),
    );
  }
}
