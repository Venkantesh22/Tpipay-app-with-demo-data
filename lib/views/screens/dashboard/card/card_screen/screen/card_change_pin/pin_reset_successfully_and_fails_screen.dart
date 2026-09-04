import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/main_card_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_change_pin/card_change_pin_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/custom_appbar_card/custom_appbar_card_widget.dart';

class PinResetSuccessfullyAndFailsScreen extends StatelessWidget {
  final bool isSuccess;
  const PinResetSuccessfullyAndFailsScreen({
    super.key,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppForCard(title: isSuccess ? "Reset PIN" : "Update Failed"),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SvgPicture.asset(
              isSuccess
                  ? Assets.svgsCheckMarkInCirlce
                  : Assets.svgsErrorInCircle,
              width: 128,
              height: 128,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 32),
            Text(
              overflow: TextOverflow.clip,
              isSuccess ? "PIN Reset Successfully" : "Failed to update PIN",
              style: Helper(context).textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              isSuccess
                  ? "Your card PIN has been updated and is ready to use."
                  : "Invalid card reference or PIN. Please check your details and try again.",
              style: Helper(context).textTheme.displayLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: purpleLight,
                  ),
            ),
            SizedBox(
              height: 48,
            ),
            isSuccess
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.svgsSecurity2,
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcOut,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "End-to-End Encrypted Session",
                        style: Helper(context).textTheme.displayLarge?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: grey,
                              letterSpacing: 1,
                            ),
                      ),
                    ],
                  )
                : SizedBox(),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: isSuccess
                  ? [
                      CustomButton(
                        height: 56,
                        radius: 12,
                        onTap: () {
                          navigate(context: context, page: MainCardScreen());
                        },
                        child: Text(
                          "Done",
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                        ),
                      )
                    ]
                  : [
                      CustomButton(
                        height: 56,
                        radius: 12,
                        onTap: () {
                          navigate(
                              context: context, page: CardChangePinScreen());
                        },
                        child: Text(
                          "Try Again",
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: white,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomButton(
                        height: 56,
                        radius: 12,
                        type: ButtonType.secondary,
                        onTap: () {
                          navigate(context: context, page: MainCardScreen());
                        },
                        color: Colors.transparent,
                        child: Text(
                          "Back to Card Screen",
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      )
                    ],
            )
          ],
        ),
      ),
    );
  }
}
