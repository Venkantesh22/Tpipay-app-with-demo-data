import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_heading_text.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/widget/card_form_title_row.dart';

import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ResidentialAddressSection extends StatelessWidget {
  const ResidentialAddressSection({super.key});
  List<String> uniqueNames(List<String> items) {
    final seen = <String>{};
    final out = <String>[];
    for (final s in items) {
      if (s.isEmpty) continue;
      if (!seen.contains(s)) {
        seen.add(s);
        out.add(s);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      return GetBuilder<CardController>(builder: (cardController) {
        final districtNames = uniqueNames(
          basicController.districtList
              .map((d) => d.districtName ?? '')
              .toList(),
        );
        final safeDistrictValue = districtNames
                .contains(cardController.selectCity?.districtName ?? '')
            ? cardController.selectCity?.districtName
            : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardFormTitleRow(
                icon: Assets.svgsHome2, title: "Residential Address"),
            SizedBox(height: 20),
            CustomDropDownList(
              items: basicController.statusList
                  .map((s) => s.stateName ?? "")
                  .toList(),
              value: cardController.state?.stateName,
              headingWidget: CardFormHeadingText(
                heading: "STATE",
              ),
              hintText: "Select State",
              onChanged: (value) async {
                basicController.setSelectStateModel(stateName: value);
                cardController.state = basicController.selectStateModel;
                cardController.update();
                await basicController.fetchDistrictByState();
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select State';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            CustomShimmer(
              isLoading: basicController.isLoading,
              child: CustomDropDownList(
                value: safeDistrictValue,
                items: districtNames,
                headingWidget: CardFormHeadingText(
                  heading: "CITY",
                ),
                hintText: "Select city",
                validator: (value) {
                  if (value == null) {
                    return 'Please select District';
                  }
                  return null;
                },
                onChanged: (v) async {
                  basicController.setDistrictModel(districtName: v);
                  cardController.selectCity =
                      basicController.selectDistrictModel;
                  cardController.update();
                },
              ),
            ),
            SizedBox(height: 16),
            AppTextFieldWithHeading(
              headingWidget: CardFormHeadingText(heading: "PINCODE"),
              controller: cardController.pinCodeController,
              hindText: "Enter your pin-code",
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pin-code';
                }
                if (value.length != 6) {
                  return 'Pincode have 6 digit';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            AppTextFieldWithHeading(
              headingWidget: CardFormHeadingText(heading: "FULL ADDRESS"),
              controller: cardController.fullAddressController,
              hindText: "Enter your full address",
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter full address';
                }

                return null;
              },
            ),
          ],
        );
      });
    });
  }
}
