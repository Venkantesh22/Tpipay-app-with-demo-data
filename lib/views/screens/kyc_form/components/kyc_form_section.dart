import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/kyc_form/components/Personal_details_form.dart';
import 'package:lekra/views/screens/kyc_form/components/bank_details_form.dart';
import 'package:lekra/views/screens/kyc_form/components/business_form_section.dart';

class HeadingsBar extends StatelessWidget {
  const HeadingsBar({super.key});

  static const List<String> headings = [
    "Business details",
    "Bank details",
    "Personal details",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(builder: (formController) {
      return SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(headings.length, (index) {
              final bool isSelected = formController.selectedIndex == index;
              final bool isComplete = formController.completed[index];

              return Expanded(
                // Using Expanded so headings occupy equal width and do NOT scroll
                child: InkWell(
                  onTap: () => formController.selectIndex(index),
                  borderRadius: BorderRadius.circular(4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        headings[index],
                        textAlign: TextAlign.center,
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? primaryColor
                                  : grey.withValues(alpha: 0.8),
                            ),
                      ),
                      sizedBoxHeight(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 110,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isComplete
                              ? primaryColor
                              : grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

class FormsContent extends StatelessWidget {
  const FormsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(builder: (formController) {
      return IndexedStack(
        index: formController.selectedIndex,
        children: [
          BusinessForm(
            isComplete: formController.completed[0],
            onCompleteChanged: (v) {
              formController.setComplete(0, v);
              if (v && formController.selectedIndex < 2) {
                formController.selectIndex(formController.selectedIndex + 1);
              }
            },
          ),
          BankDetailsForm(
            isComplete: formController.completed[1],
            onCompleteChanged: (v) {
              formController.setComplete(1, v);
              if (v && formController.selectedIndex < 2) {
                formController.selectIndex(formController.selectedIndex + 1);
              }
            },
          ),
          PersonalDetailsForm(
            isComplete: formController.completed[2],
            onCompleteChanged: (v) {
              formController.setComplete(2, v);
              if (v && formController.selectedIndex < 2) {
                formController.selectIndex(formController.selectedIndex + 1);
              }
            },
          ),
        ],
      );
    });
  }
}
