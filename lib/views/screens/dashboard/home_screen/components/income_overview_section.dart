import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/transcation_history/transaction_history_screen.dart';
import 'package:lekra/views/screens/widget/button/custom_button_with_icon.dart';

class IncomeOverviewSection extends StatelessWidget {
  const IncomeOverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Income Overview",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Card(
              color: primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  "Day",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12, fontWeight: FontWeight.w400, color: white),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        GetBuilder<ReportController>(builder: (reportController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButtonWithIcon(
                onTap: () async {
                  navigate(
                      context: context,
                      page: TransactionHistoryScreen(
                        // isYesBankTransaction: true,
                        fromDateValue: DateTime(
                            getDateTime().year, getDateTime().month, 1),
                        todateValue: getDateTime(),
                      ));
                },
                title: "Download Monthly Report",
                icon: Assets.svgsDownload,
                bgColor: primaryColor.withValues(alpha: 0.10),
                titleColor: primaryColor,
                iconColor:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn)),
          );
        }),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
