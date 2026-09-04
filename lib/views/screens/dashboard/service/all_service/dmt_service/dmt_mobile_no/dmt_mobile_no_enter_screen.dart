import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/dmt_mobile_no/otp_verify_dmt_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class DMTMobileNoEnterScreen extends StatefulWidget {
  const DMTMobileNoEnterScreen({super.key});

  @override
  State<DMTMobileNoEnterScreen> createState() => _DMTMobileNoEnterScreenState();
}

class _DMTMobileNoEnterScreenState extends State<DMTMobileNoEnterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().phoneNumberController.clear();
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<AuthController>(builder: (authController) {
              return CustomButton(
                onTap: () => _sendOtpFun(authController: authController),
                child: Text(
                  "Send a OTP",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w700, color: white),
                ),
              );
            }),
          ],
        ),
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 140,
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF39A452),
                      Color(0xFF94D1A3),
                      Color(0xFFF0FFF4),
                      white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: AppTextFieldWithHeading(
                    headingWidget: Text(
                      "Enter Beneficiary Mobile Number ",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: greyText3),
                    ),
                    controller: authController.phoneNumberController,
                    hindText: "9119 9119 91",
                    prefixText: "+91",
                    borderColor: greyText3,
                    bgColor: white,
                    borderWidth: 2,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) =>
                        _sendOtpFun(authController: authController),
                    onChanged: (value) {
                      if (value.length == 10) {
                        _sendOtpFun(authController: authController);
                      }
                    },
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter mobile number";
                      } else if (value.length != 10) {
                        return 'Please enter 10 digit phone number';
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void _sendOtpFun({required AuthController authController}) {
    if (_formKey.currentState?.validate() ?? false) {
      navigate(
          context: context,
          page: OTPVerificationForRTGS(
              phone: authController.phoneNumberController.text));
    }
  }
}
