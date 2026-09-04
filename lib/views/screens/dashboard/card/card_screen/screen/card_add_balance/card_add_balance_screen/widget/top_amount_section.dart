import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class TopAmountSection extends StatelessWidget {
  const TopAmountSection({
    super.key,
  });

  String maskedCardNumber({required String? number}) {
    // 1. Remove any spaces or hyphens if the API sends them
    String clean = number?.replaceAll(RegExp(r'[^0-9]'), '') ?? "";

    if (clean.length < 16) return clean; // Return raw if invalid

    // 2. Extract and format
    return "${clean.substring(0, 4)}-XXXX-XXXX-${clean.substring(12)}";
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController cardNoController = TextEditingController();
    return GetBuilder<CardController>(builder: (cardController) {
      cardNoController.text = maskedCardNumber(
          number: cardController.selectPrepaidCardModel?.cardNumber ?? "");

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          AppTextFieldWithHeading(
            headingWidget: Text(
              "Top-up Amount",
              style: Helper(context).textTheme.displayLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: cardController.cardTapAmountController,
            hindText: "0.0",
            preFixWidget: Icon(
              Icons.currency_rupee,
              color: grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Minimum amount is ₹1.00",
            style: Helper(context).textTheme.displayLarge?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: purpleLight,
                ),
          ),
          SizedBox(height: 20),
          AppTextFieldWithHeading(
            headingWidget: Text(
              "Card Reference Number",
              style: Helper(context).textTheme.displayLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            readOnly: true,
            controller: cardNoController,
            hindText: "0.0",
            suffix: Icon(
              Icons.lock,
              color: grey,
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            height: 46,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final money = moneyModelList[index];
                  return CustomButton(
                    onTap: money.onTap,
                    borderColor: greyLight,
                    color: Colors.transparent,
                    child: Text(
                      "+ ${money.amount}",
                      style: Helper(context).textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return SizedBox(width: 12);
                },
                itemCount: moneyModelList.length),
          ),
        ],
      );
    });
  }
}

class MoneyModel {
  final String amount;
  final Function() onTap;

  MoneyModel({required this.amount, required this.onTap});
}

List<MoneyModel> moneyModelList = [
  MoneyModel(
    amount: "₹10",
    onTap: () {
      Get.find<CardController>().updateMoney("10");
    },
  ),
  MoneyModel(
    amount: "₹50",
    onTap: () {
      Get.find<CardController>().updateMoney("50");
    },
  ),
  MoneyModel(
    amount: "₹100",
    onTap: () {
      Get.find<CardController>().updateMoney("100");
    },
  ),
];
