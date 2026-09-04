import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationForRTGS extends StatefulWidget {
  final String phone;
  final bool isForPrepaidCard;
  const OTPVerificationForRTGS({
    super.key,
    required this.phone,
    this.isForPrepaidCard = false,
  });

  @override
  State<OTPVerificationForRTGS> createState() => _OTPVerificationForRTGSState();
}

class _OTPVerificationForRTGSState extends State<OTPVerificationForRTGS> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                GetBuilder<AuthController>(builder: (authController) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                            spreadRadius: -1,
                            color: black.withValues(alpha: 0.1),
                          ),
                          BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            spreadRadius: -2,
                            color: black.withValues(alpha: 0.1),
                          )
                        ]),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: secondaryColor,
                          child: SvgPicture.asset(
                            Assets.svgsLock,
                            colorFilter:
                                const ColorFilter.mode(white, BlendMode.srcIn),
                          ),
                        ),
                        sizedBoxHeight(height: 16),
                        Text(
                          "Verify OTP",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Enter the 6-digit code sent to your number +91 ${widget.phone}",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                        ),
                        sizedBoxHeight(height: 33),
                        Row(
                          children: [
                            Text(
                              "Enter Verification Code",
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Pinput(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          controller: _pinController,
                          length: 6,
                          defaultPinTheme: PinTheme(
                            width: 45,
                            height: 55,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 45,
                            height: 55,
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
                            width: 45,
                            height: 55,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: CustomButton(
                            height: 50,
                            radius: 8,
                            color: _pinController.text.length == 6
                                ? primaryColor
                                : primaryColor.withValues(alpha: 0.5),
                            onTap: () {
                              log("opt ${_pinController.text}");
                              if (_pinController.text.isNotEmpty &&
                                  _pinController.text.length == 6) {
                                authController
                                    .verifyOTP(opt: _pinController.text.trim())
                                    .then(
                                  (value) {
                                    if (value.isSuccess) {
                                      navigate(
                                          context: context,
                                          page: const LoginScreen());
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    } else {
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    }
                                  },
                                );
                              }
                            },
                            child: Text(
                              "Verify OTP",
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: white),
                            ),
                          ),
                        ),
                        CustomButton(
                          type: ButtonType.tertiary,
                          onTap: () {
                            authController.getOTP().then((value) {
                              if (value.isSuccess) {
                                showToast(
                                    message: value.message,
                                    typeCheck: value.isSuccess);
                              } else {
                                showToast(
                                    message: value.message,
                                    typeCheck: value.isSuccess);
                              }
                            });
                          },
                          child: Text(
                            'Resend Code',
                            style: Helper(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: primaryColor),
                          ),
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: CustomButton(
                    type: ButtonType.tertiary,
                    onTap: () {
                      pop(context);
                    },
                    child: Text(
                      'Back to Phone Number',
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: primaryColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.5),
                      primaryColor.withValues(alpha: 0.2),
                      white.withValues(alpha: 0.01),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )),
          Positioned(
            top: 16,
            left: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                children: [
                  BackButton(color: Colors.black),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
