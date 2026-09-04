// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/forget_password_screen.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:pinput/pinput.dart';

import '../../../services/constants.dart';
import '../../../services/theme.dart';
import '../../base/common_button.dart';
import '../../base/custom_image.dart';

class OTPVerification extends StatefulWidget {
  final String phone;
  final bool isForPrepaidCardApplyForm;
  const OTPVerification({
    super.key,
    required this.phone,
    this.isForPrepaidCardApplyForm = false,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    super.initState();
  }

  Future<void> _verifyOTP({required AuthController authController}) async {
    log("opt ${_pinController.text}");
    if (_pinController.text.isNotEmpty && _pinController.text.length == 6) {
      if (widget.isForPrepaidCardApplyForm) {
        await Get.find<CardController>()
            .verificationOTPForPrepaidCard(
          otp: _pinController.text.trim(),
          context: context,
          mobileNumber: widget.phone,
        )
            .then(
          (value) {
            if (value.isSuccess) {
              Get.find<DashBoardController>().dashPage = 0;
              navigate(context: context, page: const DashboardScreen());
              showToast(message: value.message, typeCheck: value.isSuccess);
            } else {
              showToast(message: value.message, typeCheck: value.isSuccess);
            }
          },
        );
      } else {
        await authController.verifyOTP(opt: _pinController.text.trim()).then(
          (value) {
            if (value.isSuccess) {
              navigate(context: context, page: const LoginScreen());
              showToast(message: value.message, typeCheck: value.isSuccess);
            } else {
              showToast(message: value.message, typeCheck: value.isSuccess);
            }
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: secondaryColor,
              child: SvgPicture.asset(
                Assets.svgsLock,
                colorFilter: const ColorFilter.mode(white, BlendMode.srcIn),
              ),
            ),
            sizedBoxHeight(height: 16),
            Text(
              "Verify OTP",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Enter the 6-digit code sent to your number \n+91 ${widget.phone}",
              textAlign: TextAlign.center,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            ),
            sizedBoxHeight(height: 33),
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
                    Row(
                      children: [
                        Text(
                          "Enter Verification Code",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
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
                      onChanged: (value) {
                        setState(() {});
                        if (value.length == 6) {
                          _verifyOTP(authController: authController);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child:
                          GetBuilder<CardController>(builder: (cardController) {
                        return CustomButton(
                          isLoading: widget.isForPrepaidCardApplyForm
                              ? cardController.isLoading
                              : authController.isLoading,
                          height: 50,
                          radius: 8,
                          color: _pinController.text.length == 6
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.5),
                          onTap: () =>
                              _verifyOTP(authController: authController),
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
                        );
                      }),
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
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
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
            !widget.isForPrepaidCardApplyForm
                ? Center(
                    child: CustomButton(
                      type: ButtonType.tertiary,
                      onTap: () {
                        navigate(
                            context: context,
                            page: const ForgetPasswordScreen());
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
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
