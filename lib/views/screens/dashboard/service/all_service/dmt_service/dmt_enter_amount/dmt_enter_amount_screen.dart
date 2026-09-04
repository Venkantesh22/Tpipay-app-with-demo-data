import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/mobile_service_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/dmt_dashboard_screen.dart/components/beneficiary_container.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/transaction_pin/transaction_pin_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class DmtEnterAmountScreen extends StatefulWidget {
  const DmtEnterAmountScreen({super.key});

  @override
  State<DmtEnterAmountScreen> createState() => _DmtEnterAmountScreenState();
}

class _DmtEnterAmountScreenState extends State<DmtEnterAmountScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<MobileServiceController>(
            builder: (mobileServiceController) {
          return Column(
            children: [
              SizedBox(height: 30),
              BeneficiaryContainer(
                isPayScreen: true,
              ),
              SizedBox(height: 32),
              Form(
                key: _formKey,
                child: AppTextFieldWithHeading(
                  controller: mobileServiceController.amountController,
                  hindText: "0",
                  borderColor: greyText,
                  prefixText: "₹",
                  prefixStyle: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  headingWidget: Text(
                    "Enter Amount",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a amount";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 32),
              CustomButton(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    navigate(
                        context: context,
                        page: TransactionPinScreen(
                          isEnterPin: true,
                        ));
                  }
                },
                child: Text(
                  "PAY NOW",
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: white,
                      ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
