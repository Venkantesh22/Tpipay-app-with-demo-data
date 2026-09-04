import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/mobile_service_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class CreateBeneficiaryAccountScreen extends StatefulWidget {
  const CreateBeneficiaryAccountScreen({super.key});

  @override
  State<CreateBeneficiaryAccountScreen> createState() =>
      _CreateBeneficiaryAccountScreenState();
}

class _CreateBeneficiaryAccountScreenState
    extends State<CreateBeneficiaryAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: GetBuilder<MobileServiceController>(
              builder: (mobileServiceController) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter The Beneficiary Account Details",
                    overflow: TextOverflow.clip,
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: greyText3,
                        ),
                  ),
                  SizedBox(height: 20),
                  AppTextFieldWithHeading(
                    headingWidget: Text(
                      "BANK NAME",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                    controller: mobileServiceController.bankNameController,
                    borderColor: grey.withValues(alpha: 0.57),
                    hindText: "Enter Your Bank Name",
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter bank name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppTextFieldWithHeading(
                    headingWidget: Text(
                      "ACCOUNT NUMBER",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                    suffix: SizedBox(),
                    controller: mobileServiceController.accountNoController,
                    borderColor: grey.withValues(alpha: 0.57),
                    hindText: "Enter Your Account Number",
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter account number";
                      } else if (value.length < 9 || value.length > 18) {
                        return "Account number must be between 9 and 18 digits";
                      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return "Account number must contain only digits";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppTextFieldWithHeading(
                    headingWidget: Text(
                      "CONFIRM ACCOUNT NUMBER",
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                    keyboardType: TextInputType.number,
                    controller:
                        mobileServiceController.confirmAccountNoController,
                    borderColor: grey.withValues(alpha: 0.57),
                    hindText: "Re-enter Your Account Number",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter account number";
                      } else if (value.length < 9 || value.length > 18) {
                        return "Account number must be between 9 and 18 digits";
                      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return "Account number must contain only digits";
                      } else if (value !=
                          mobileServiceController
                              .confirmAccountNoController.text) {
                        return "Account number do not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppTextFieldWithHeading(
                    headingWidget: Text(
                      "IFSC CODE",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                    controller: mobileServiceController.ifscCodeController,
                    borderColor: grey.withValues(alpha: 0.57),
                    hindText: "Enter Your IFSC Code",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter IFSC code";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppTextFieldWithHeading(
                    headingWidget: Text(
                      "ACCOUNT HOLDER NAME",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      _verifyAccountFun();
                    },
                    controller:
                        mobileServiceController.accountHolderNameCodeController,
                    borderColor: grey.withValues(alpha: 0.57),
                    hindText: "Enter Your Account Holder Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter account holder name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CustomButton(
                      height: 48,
                      onTap: _verifyAccountFun,
                      title: "Verify Account",
                      textStyle: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: white,
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

  void _verifyAccountFun() {
    if (_formKey.currentState?.validate() ?? false) {}
  }
}
