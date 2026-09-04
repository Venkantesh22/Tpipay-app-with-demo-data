import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/extensions.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_heading_text.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_title_row.dart';

import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ContextInfoSection extends StatelessWidget {
  const ContextInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardFormTitleRow(
              icon: Assets.svgsCard2, title: "Contact Information"),
          SizedBox(height: 20),
          AppTextFieldWithHeading(
            headingWidget: CardFormHeadingText(heading: "MOBILE NUMBER"),
            controller: cardController.numberController,
            hindText: "Enter you Mobile number",
            prefixText: "+91",
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (value.length != 10) {
                return 'Please enter valid phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          AppTextFieldWithHeading(
            headingWidget: CardFormHeadingText(heading: "EMAIL ADDRESS"),
            controller: cardController.emailController,
            hindText: "tpipay@gmail.coom",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (value.isNotEmail) {
                return 'Please enter valid email';
              }
              return null;
            },
          ),
        ],
      );
    });
  }
}
