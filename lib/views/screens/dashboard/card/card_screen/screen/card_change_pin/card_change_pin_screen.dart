// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_change_pin/pin_reset_successfully_and_fails_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/custom_appbar_card/custom_appbar_card_widget.dart';
import 'package:pinput/pinput.dart';

class CardChangePinScreen extends StatefulWidget {
  const CardChangePinScreen({super.key});

  @override
  State<CardChangePinScreen> createState() => _CardChangePinScreenState();
}

class _CardChangePinScreenState extends State<CardChangePinScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pinController = TextEditingController();
  TextEditingController _pinControllerConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppForCard(
        title: "Reset PIN",
      ),
      bottomNavigationBar:
          GetBuilder<CardController>(builder: (cardController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: CustomButton(
                height: 56,
                radius: 12,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    cardController
                        .prepaidCardResetPIN(
                            context: context,
                            pin: _pinControllerConfirm.text.trim())
                        .then((value) {
                      if (value.isSuccess) {
                        showToast(
                            message: value.message, typeCheck: value.isSuccess);
                        navigate(
                            context: context,
                            page: PinResetSuccessfullyAndFailsScreen(
                              isSuccess: true,
                            ));
                      } else {
                        showToast(
                            message: value.message, typeCheck: value.isSuccess);
                        navigate(
                            context: context,
                            page: PinResetSuccessfullyAndFailsScreen());
                      }
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reset PIN Now",
                      style: Helper(context).textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.security,
                      color: white,
                    )
                  ],
                ),
              ),
            ),
            Row(
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
            ),
            SizedBox(height: 38)
          ],
        );
      }),
      body: GetBuilder<CardController>(builder: (cardController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 24),
                    child: SvgPicture.asset(
                      Assets.svgsLockInCirlce,
                    ),
                  ),
                  Text(
                    "Create New PIN",
                    style: Helper(context).textTheme.displayLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Card Reference ID: ",
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: purpleLight,
                                  ),
                        ),
                        TextSpan(
                          text: cardController.selectPrepaidCardModel?.cardRefId
                                  .toString() ??
                              "",
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Enter New 4-Digit PIN",
                    style: Helper(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16),
                  Pinput(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _pinController,
                    obscureText: true,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 64,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 64,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 64,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Confirm New PIN",
                    style: Helper(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16),
                  Pinput(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: _pinControllerConfirm,
                    obscureText: true,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 64,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 64,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 64,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value != _pinController.text) {
                        return "Pin do not match";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
