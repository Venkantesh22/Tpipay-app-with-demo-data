import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class BankDetailsForm extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;
  const BankDetailsForm({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<BankDetailsForm> createState() => _BankDetailsFormState();
}

class _BankDetailsFormState extends State<BankDetailsForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(builder: (formController) {
      return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" ENTER YOUR BANK DETAILS",
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
            sizedBoxHeight(height: 24),
            AppTextFieldWithHeading(
                controller: formController.panNumberController,
                hindText: "Enter PAN Number",
                heading: "PAN Number",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter PAN Number";
                  }

                  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
                  if (!panRegex.hasMatch(value.toUpperCase())) {
                    return "Invalid PAN format (e.g., ABCDE1234F)";
                  }

                  return null;
                }),
            sizedBoxHeight(height: 24),
            AppTextFieldWithHeading(
              controller: formController.gstNumberController,
              hindText: "Enter GST Number",
              heading: "GST Number",
              isRequired: true,
              borderColor: primaryColor,
              bgColor: primaryColorLight,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter GST Number';
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24),
            AppTextFieldWithHeading(
              controller: formController.settlementAccountNameController,
              hindText: "Enter Settlement Account Name",
              heading: "Settlement Account Name",
              isRequired: true,
              borderColor: primaryColor,
              bgColor: primaryColorLight,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Settlement Account Name';
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24),
            AppTextFieldWithHeading(
                controller: formController.settlementAccountNumberController,
                hindText: "Enter Settlement Account Number",
                heading: "Settlement Account Number",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(18),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Account Number";
                  }

                  if (value.length < 9 || value.length > 18) {
                    return "Account number must be 9-18 digits";
                  }

                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Account number must contain digits only";
                  }

                  return null;
                }),
            sizedBoxHeight(height: 24),
            AppTextFieldWithHeading(
                controller: formController.settlementAccountIFSCController,
                hindText: "Enter Settlement Account IFSC",
                heading: "Settlement Account IFSC",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter IFSC code";
                  }

                  final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                  if (!ifscRegex.hasMatch(value.toUpperCase())) {
                    return "Invalid IFSC format (e.g., SBIN0001234)";
                  }

                  return null;
                }),
            sizedBoxHeight(height: 24),
            AppTextFieldWithHeading(
              controller: formController.dateOfBirthController,
              hindText: "Select Date of Birth (YYYY-MM-DD)",
              heading: "Date of Birth",
              isRequired: true,
              keyboardType: TextInputType.datetime,
              borderColor: primaryColor,
              bgColor: primaryColorLight,
              readOnly: true,
              suffix: const Icon(
                Icons.calendar_month_outlined,
                color: primaryColor,
              ),
              onTap: () async {
                FocusScope.of(context).unfocus(); // Close keyboard

                final DateTime? picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                          onSurface: black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  final formatted =
                      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

                  formController.dateOfBirthController.text = formatted;
                  formController.update();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select Date of Birth';
                }
                return null;
              },
            ),
            sizedBoxHeight(height: 24),
            CustomButton(
              title: "Next",
              textStyle:
                  Helper(context).textTheme.titleSmall?.copyWith(color: white),
              onTap: () {
                if (formKey.currentState?.validate() ?? false) {
                  widget.onCompleteChanged(!widget.isComplete);
                }
              },
              color: secondaryColor,
            ),
            const SizedBox(width: 12),
          ],
        ),
      );
    });
  }
}
