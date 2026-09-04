import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/base/custom_switch.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_heading_text.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_title_row.dart';

import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ApplicantIdentitySection extends StatelessWidget {
  const ApplicantIdentitySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Column(
        children: [
          SizedBox(height: 8),
          CardFormTitleRow(
            icon: Assets.svgsPerson,
            title: "Applicant Identity",
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomDropDownList(
                  value: cardController.title,
                  items: cardController.titleList,
                  hintText: "Select title",
                  onChanged: (value) {
                    cardController.updateTitle(value);
                  },
                  headingWidget: CardFormHeadingText(
                    heading: "TITLE",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select title";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CustomSwitch(
                  radius: 12,
                  headingWidget: CardFormHeadingText(
                    heading: "GENDER",
                  ),
                  items: cardController.genderList,
                  onChanged: (String value) {
                    cardController.updateGender(value);
                  },
                  value: cardController.genderList.first,
                  height: 46,
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          AppTextFieldWithHeading(
            headingWidget: CardFormHeadingText(heading: "FIRST NAME"),
            controller: cardController.firstNameController,
            hindText: "Enter your first name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }

              return null;
            },
          ),
          SizedBox(height: 16),
          AppTextFieldWithHeading(
            headingWidget: CardFormHeadingText(heading: "LAST NAME"),
            controller: cardController.lastNameController,
            hindText: "Enter your last name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }

              return null;
            },
          ),
          SizedBox(height: 16),
          AppTextFieldWithHeading(
            headingWidget: CardFormHeadingText(heading: "DATE OF BIRTH"),
            controller: cardController.dobController,
            hindText: "dd/mm/yyy",
            hintStyle: Helper(context).textTheme.displayLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
            readOnly: true,
            onTap: () async {
              FocusScope.of(context).unfocus(); // Close keyboard

              final DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: primaryColor,
                        onPrimary: Colors.white,
                        onSurface: black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                final formatted =
                    "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";

                cardController.dobController.text = formatted;
                cardController.update();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select data of birth';
              }

              return null;
            },
          ),
        ],
      );
    });
  }
}
