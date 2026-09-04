import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class BusinessForm extends StatefulWidget {
  final bool isComplete;

  final ValueChanged<bool> onCompleteChanged;

  const BusinessForm({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<BusinessForm> createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<FormController>(builder: (formController) {
        formController.businessMCCController.text = "5621";
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ENTER YOUR BUSINESS DETAILS",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
              sizedBoxHeight(height: 24),
              AppTextFieldWithHeading(
                controller: formController.sellerIdentifierController,
                hindText: "Enter Seller Identifier",
                heading: "Seller Identifier",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Seller Identifier';
                  }
                  return null;
                },
              ),
              sizedBoxHeight(height: 24),
              AppTextFieldWithHeading(
                controller: formController.businessNameController,
                hindText: "Enter Business Name",
                heading: "Business Name",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter business Name';
                  }
                  return null;
                },
              ),
              sizedBoxHeight(height: 24),
              AppTextFieldWithHeading(
                controller: formController.businessNumberController,
                hindText: "Enter Mobile Number",
                heading: "Mobile Number",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                prefixText: "+91",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile Number';
                  }
                  if (value.length != 10) {
                    return 'Please enter valid mobile Number';
                  }
                  return null;
                },
              ),
              sizedBoxHeight(height: 24),
              AppTextFieldWithHeading(
                controller: formController.businessEmailController,
                hindText: "Enter Email",
                heading: "Email",
                isRequired: true,
                keyboardType: TextInputType.emailAddress,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  }
                  if (!value.isEmail) {
                    return 'Please valid email';
                  }
                  return null;
                },
              ),
              sizedBoxHeight(height: 24),
              AppTextFieldWithHeading(
                controller: formController.businessMCCController,
                hindText: "Enter Merchant Category Code(MCC)",
                heading: "Merchant Category Code(MCC)",
                isRequired: true,
                readOnly: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Merchant Category Code(MCC)';
                  }

                  return null;
                },
              ),
              sizedBoxHeight(height: 24),
              CustomDropDownList<String>(
                value: formController.turnoverType,
                items: formController.turnoverTypeList,
                heading: "Turnover Type",
                hintText: " Select Turnover Type",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Turnover Type';
                  }
                  return null;
                },
                onChanged: (v) => formController.setTurnoverType(v),
              ),
              sizedBoxHeight(height: 24),
              CustomDropDownList<String>(
                value: formController.acceptanceType,
                items: formController.acceptanceTypeList,
                heading: "Acceptance Type",
                hintText: " Select Acceptance Type",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Acceptance Type';
                  }
                  return null;
                },
                onChanged: (v) => formController.setAcceptanceType(v),
              ),
              sizedBoxHeight(height: 24),
              CustomDropDownList<String>(
                value: formController.ownershipType,
                items: formController.ownershipTypeList,
                heading: "Ownership Type",
                hintText: " Select Ownership Type",
                isRequired: true,
                borderColor: primaryColor,
                bgColor: primaryColorLight,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Ownership Type';
                  }
                  return null;
                },
                onChanged: (v) => formController.setOwnershipType(v),
              ),
              sizedBoxHeight(height: 24),
              AppTextFieldWithHeading(
                controller: formController.dateOfIncorporationController,
                hindText: "Select Date of Incorporation (YYYY-MM-DD)",
                heading: "Date of Incorporation",
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
                  FocusScope.of(context).unfocus();

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

                    formController.dateOfIncorporationController.text =
                        formatted;
                    formController.update();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date of incorporation';
                  }
                  return null;
                },
              ),
              sizedBoxHeight(height: 24),
              CustomButton(
                title: "Next",
                textStyle: Helper(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: white),
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
      }),
    );
  }
}
