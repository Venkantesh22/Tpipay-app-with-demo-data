import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/view_widget.dart';
import 'package:lekra/views/screens/transcation_history/transaction_history_screen.dart';
import 'package:lekra/views/screens/widget/transaction_row.dart';

class TransactionHistoryWidget extends StatelessWidget {
  const TransactionHistoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Transaction History",
                  style: Helper(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              reportController.transactionReportList.isNotEmpty
                  ? ViewAllWidget(onPressed: () {
                      Get.find<ReportController>()
                          .setIsYesBankTransaction(true);
                      navigate(
                          context: context,
                          page: TransactionHistoryScreen(
                            fromDateValue: DateTime(2024, 1, 1),
                            todateValue: getDateTime(),
                          ));
                    })
                  : const SizedBox()
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final transactionModel = reportController.isLoading
                    ? TransactionModel()
                    : reportController.transactionReportList[index];
                return CustomShimmer(
                    isLoading: reportController.isLoading,
                    child: TransactionRow(transactionModel: transactionModel));
              },
              separatorBuilder: (_, __) {
                return const SizedBox(
                  height: 12,
                );
              },
              itemCount: reportController.isLoading
                  ? 4
                  : reportController.transactionReportList.length)
        ],
      );
    });
  }
}
