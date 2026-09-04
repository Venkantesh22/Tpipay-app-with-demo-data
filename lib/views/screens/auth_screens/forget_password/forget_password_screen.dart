// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/auth_screens/otp_verification_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final bool isEnterMobileNoForVerification;
  const ForgetPasswordScreen(
      {super.key, this.isEnterMobileNoForVerification = false});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().phoneNumberController.clear();
    });
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _generateOTPFun({required AuthController authController}) async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.getOTP().then((value) {
        if (value.isSuccess) {
          navigate(
              context: context,
              page: OTPVerification(
                  phone: authController.passwordController.text));
          showToast(message: value.message, typeCheck: value.isSuccess);
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Center(
          child: GetBuilder<AuthController>(builder: (authController) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 32,
                    child: SvgPicture.asset(
                      Assets.svgsCall,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.isEnterMobileNoForVerification
                        ? "Enter Mobile"
                        : "Forgot Password",
                    style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: secondaryColor,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Enter your phone number to receive a verification code",
                    overflow: TextOverflow.fade,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
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
                        AppTextFieldWithHeading(
                          heading: "Phone Number",
                          controller: authController.phoneNumberController,
                          hindText: "Enter your 10-digit phone number",
                          prefixText: "+91",
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              _generateOTPFun(authController: authController),
                          onChanged: (value) {
                            if (value.length == 10) {
                              _generateOTPFun(authController: authController);
                            }
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                        sizedBoxHeight(height: 42),
                        CustomButton(
                          isLoading: authController.isLoading,
                          height: 48,
                          onTap: () =>
                              _generateOTPFun(authController: authController),
                          child: Text(
                            "Generate OTP",
                            style: Helper(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomButton(
                    onTap: () {
                      navigate(context: context, page: const LoginScreen());
                    },
                    type: ButtonType.tertiary,
                    child: Text(
                      "Back to Login",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: primaryColor,
                          ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
