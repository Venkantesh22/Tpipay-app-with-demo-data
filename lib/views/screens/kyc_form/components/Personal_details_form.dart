import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/form_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/wallet_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class PersonalDetailsForm extends StatefulWidget {
  final bool isComplete;
  final ValueChanged<bool> onCompleteChanged;
  const PersonalDetailsForm({
    super.key,
    required this.isComplete,
    required this.onCompleteChanged,
  });

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final formKey = GlobalKey<FormState>();

  List<String> uniqueNames(List<String> items) {
    final seen = <String>{};
    final out = <String>[];
    for (final s in items) {
      if (s.isEmpty) continue;
      if (!seen.contains(s)) {
        seen.add(s);
        out.add(s);
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormController>(
      builder: (formController) {
        return GetBuilder<BasicController>(
          builder: (basicController) {
            final districtNames = uniqueNames(
              basicController.districtList
                  .map((d) => d.districtName ?? '')
                  .toList(),
            );
            final safeDistrictValue = districtNames
                    .contains(formController.selectDistrict?.districtName ?? '')
                ? formController.selectDistrict?.districtName
                : null;
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ENTER YOUR PERSONAL DETAILS",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                  sizedBoxHeight(height: 24),
                  CustomDropDownList<String>(
                    value: formController.selectState?.stateName,
                    items: basicController.statusList
                        .map((s) => s.stateName ?? "")
                        .toList(),
                    heading: "State",
                    hintText: " Select State",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select State';
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      basicController.setSelectStateModel(stateName: v);
                      formController.selectState =
                          basicController.selectStateModel;
                      formController.update();
                      await basicController.fetchDistrictByState();
                    },
                  ),
                  sizedBoxHeight(height: 24),
                  CustomDropDownList<String>(
                    value: safeDistrictValue,
                    items: districtNames,
                    heading: "District",
                    hintText: " Select District",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select District';
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      basicController.setDistrictModel(districtName: v);
                      formController.selectDistrict =
                          basicController.selectDistrictModel;
                      formController.update();
                    },
                  ),
                  sizedBoxHeight(height: 24),
                  AppTextFieldWithHeading(
                    controller: formController.cityController,
                    hindText: "Enter City",
                    heading: "City",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter City';
                      }
                      return null;
                    },
                  ),
                  sizedBoxHeight(height: 24),
                  AppTextFieldWithHeading(
                    controller: formController.pincodeController,
                    hindText: "Enter Pincode",
                    heading: "Pincode",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Pincode';
                      }
                      if (value.length != 6) {
                        return 'Please enter valid Pincode';
                      }
                      return null;
                    },
                  ),
                  sizedBoxHeight(height: 24),
                  AppTextFieldWithHeading(
                    controller: formController.addressLine1Controller,
                    hindText: "Enter Address Line 1",
                    heading: "Address Line 1",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address Line 1';
                      }
                      return null;
                    },
                  ),
                  sizedBoxHeight(height: 24),
                  AppTextFieldWithHeading(
                    controller: formController.addressLine2Controller,
                    hindText: "Enter Address Line 2",
                    heading: "Address Line 2",
                    isRequired: true,
                    borderColor: primaryColor,
                    bgColor: primaryColorLight,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address Line 1';
                      }
                      return null;
                    },
                  ),
                  sizedBoxHeight(height: 24),
                  CustomButton(
                    title: "Submit",
                    textStyle: Helper(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: white),
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        widget.onCompleteChanged(!widget.isComplete);
                        await formController
                            .postUploadKYC(context)
                            .then((value) {
                          if (value.isSuccess) {
                            navigate(context: context, page: WalletScreen());
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          } else {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          }
                        });
                      }
                    },
                    color: primaryColor,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
