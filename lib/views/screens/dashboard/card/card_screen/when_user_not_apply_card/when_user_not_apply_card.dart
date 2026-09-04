import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/form_for_apply_card_screen.dart';

class WhenNoApplyForCard extends StatelessWidget {
  const WhenNoApplyForCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (cardController) {
        return CustomShimmer(
          isLoading: cardController.isLoading,
          child: SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(54, 180, 54, 40),
                  child: CustomImage(
                    path: Assets.imagesNoCard,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Text(
                        "You do not have a prepaid card yet",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Helper(context).textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Apply for a card to start managing your spending, earning rewards, and enjoying seamless payments everywhere.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: Helper(context).textTheme.titleLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: greyText3),
                        ),
                      ),
                      SizedBox(height: 40),
                      CustomButton(
                        height: 56,
                        onTap: () {
                          navigate(context: context, page: FormForApplyCardScreen());
                        },
                        radius: 12,
                        child: Text(
                          "Apply for Prepaid Card",
                          style: Helper(context).textTheme.titleLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: white),
                        ),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.svgsSecurity2,
                            width: 10,
                            height: 12,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Fast approval and secure usage",
                            style: Helper(context).textTheme.titleLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: purpleLight),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
