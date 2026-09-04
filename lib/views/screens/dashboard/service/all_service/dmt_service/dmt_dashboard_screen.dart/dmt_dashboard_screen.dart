import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/dmt_dashboard_screen.dart/components/beneficiary_container.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/dmt_enter_amount/dmt_enter_amount_screen.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/dmt_service/dmt_mobile_no/dmt_mobile_no_enter_screen.dart';

class DmtDashboardScreen extends StatefulWidget {
  const DmtDashboardScreen({super.key});

  @override
  State<DmtDashboardScreen> createState() => _DmtDashboardScreenState();
}

class _DmtDashboardScreenState extends State<DmtDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: CustomButton(
                height: 48,
                onTap: () {
                  navigate(context: context, page: DMTMobileNoEnterScreen());
                },
                color: primaryColor,
                child: Text(
                  "+ Add Beneficiary",
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700, color: white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Select or Add the bank account to transfer now",
                overflow: TextOverflow.clip,
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: greyText,
                    ),
              ),
              SizedBox(height: 22),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        return navigate(
                            context: context, page: DmtEnterAmountScreen());
                      },
                      child: BeneficiaryContainer());
                },
                separatorBuilder: (_, __) => SizedBox(
                  height: 22,
                ),
                itemCount: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
