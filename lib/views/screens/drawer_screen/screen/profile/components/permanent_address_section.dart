import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class PermanentAddressSection extends StatefulWidget {
  const PermanentAddressSection({
    super.key,
  });

  @override
  State<PermanentAddressSection> createState() =>
      _PermanentAddressSectionState();
}

class _PermanentAddressSectionState extends State<PermanentAddressSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      return GetBuilder<AuthController>(builder: (authController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Permanent Address",
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: primaryColor),
                ),
              ),
              AppTextFieldWithHeading(
                bgColor: white,
                controller: authController.addressController,
                hindText: "23 Abc Street",
                heading: "Address",
                borderRadius: 8,
                borderColor: greyLight,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Address ';
                  }
                  return null;
                },
              ),
               sizedBoxHeight(height: 20,
              ),
              CustomShimmer(
                isLoading: basicController.isLoading,
                child: CustomDropDownList<String>(
                  value: basicController.selectStateModel?.stateName,
                  items: basicController.statusList
                      .map((s) => s.stateName ?? "")
                      .toList(),
                  heading: "State",
                  hintText: " Select State",
                  bgColor: white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select State';
                    }
                    return null;
                  },
                  onChanged: (v) async {
                    basicController.setSelectStateModel(stateName: v);

                    await basicController.fetchDistrictByState();
                  },
                ),
              ),
              sizedBoxHeight(height: 24),
              CustomShimmer(
                isLoading: basicController.isLoading,
                child: CustomDropDownList<String>(
                  value: basicController.selectDistrictModel?.districtName,
                  items: basicController.districtList
                      .map((d) => d.districtName ?? "")
                      .toList(),
                  heading: "District",
                  hintText: " Select District",
                  bgColor: white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select District';
                    }
                    return null;
                  },
                  onChanged: (v) async {
                    basicController.setDistrictModel(districtName: v);
                    authController.update();
                  },
                ),
              ),
              sizedBoxHeight(height: 20),
              AppTextFieldWithHeading(
                bgColor: white,
                controller: authController.cityController,
                hindText: "Pune",
                heading: "City",
                borderRadius: 8,
                borderColor: greyLight,
              ),
              sizedBoxHeight(height: 20),
              AppTextFieldWithHeading(
                bgColor: white,
                controller: authController.pincodeController,
                hindText: "123456",
                heading: "Pincode",
                borderRadius: 8,
                borderColor: greyLight,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pincode';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      });
    });
  }
}
