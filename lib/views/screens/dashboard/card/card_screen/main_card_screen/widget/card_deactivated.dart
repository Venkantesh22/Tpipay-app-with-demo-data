import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';

class CardDeactivated extends StatelessWidget {
  const CardDeactivated({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      if (cardController.selectPrepaidCardModel?.isActive == false) {
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: greyDark.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: CustomButton(
                      height: 56,
                      onTap: () {},
                      borderColor: white.withValues(alpha: 0.50),
                      color: white.withValues(alpha: 0.30),
                      radius: 100,
                      child: Text(
                        "Deactivated",
                        style: Helper(context).textTheme.displayLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
