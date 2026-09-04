import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';

class HomeScreenFun {
  // 🔴 NEW: The UI Refresher logic
  static void refreshAllTransactionAndGraph() {
    try {
      // Check if the ReportController is currently active in memory to prevent crashes
      if (Get.isRegistered<ReportController>()) {
        final reportContro = Get.find<ReportController>();
        final dateFormat = DateFormat('yyyy-MM-dd');

        // Ensure you have access to your dateFormat and getDateTime() here
        // If they are global, this will work perfectly.
        String todayDate = dateFormat.format(getDateTime());

        reportContro
            .fetchYesBankMerchantCollection(
          fromdate: todayDate,
          todate: todayDate,
        )
            .then((value) {
          if (value.isSuccess) {
            reportContro.convertTODataForGraph(
                reportContro.yesBankMerchantCollectionList);
          }
        });

        reportContro.fetchTransactionReport(
          fromdate: todayDate,
          todate: todayDate,
          isShowOnly10: true,
        );

        log("Dashboard UI refreshed successfully in the foreground.");
      } else {
        log("ReportController not registered yet. Skipping UI refresh.");
      }
    } catch (e) {
      log("Error refreshing dashboard data: $e");
    }
  }
}
