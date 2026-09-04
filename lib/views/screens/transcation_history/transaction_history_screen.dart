import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/transcation_history/component/filter_by_calender.dart';
import 'package:lekra/views/screens/transcation_history/component/transaction_list_section.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final DateTime fromDateValue;
  final DateTime todateValue;

  const TransactionHistoryScreen({
    super.key,
    required this.fromDateValue,
    required this.todateValue,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingData();
    });
    _scrollController.addListener(_onScroll);

    searchController.addListener(() {
      _onSearchChanged(searchController.text);
    });
  }

  Future<void> loadingData() async {
    final reportController = Get.find<ReportController>();
    reportController.setSelectOption("All Status");
    reportController.setStatusSelected(false);
    reportController.searchQuery = "";

    reportController.setDate(
      fromDateValue: DateFormatters().yMD.format(widget.fromDateValue),
      todateValue: DateFormatters().yMD.format(widget.todateValue),
    );
    log("  reportController.isYesBankTransaction ${reportController.isYesBankTransaction}");

    await reportController
        .fetchTransactionReportPagination(
            fromdate: reportController.fromDate,
            todate: reportController.todate,
            isYesBankCollect: reportController.isYesBankTransaction)
        .then((value) {
      if (value.isSuccess) {
      } else {
        showToast(message: value.message, typeCheck: value.isSuccess);
      }
    });
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final rc = Get.find<ReportController>();
      rc.setSearchQuery(text);
      rc.setStatusSelected(
          rc.selectedStatus != null && rc.selectedStatus != 'All Status');
    });
  }

  void _onScroll() {
    final c = _scrollController;
    if (!c.hasClients) return;

    final reportController = Get.find<ReportController>();
    final st = reportController.transactionState;

    if (st.isMoreLoading || st.isInitialLoading) return; // already busy
    if (!st.canLoadMore) return;

    if (c.position.extentAfter < 400) {
      reportController.fetchTransactionReportPagination(
          fromdate: reportController.fromDate,
          todate: reportController.todate,
          loadMore: true,
          isYesBankCollect: reportController.isYesBankTransaction);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final res =
            await Get.find<ReportController>().fetchTransactionReportPagination(
          fromdate: Get.find<ReportController>().fromDate,
          todate: Get.find<ReportController>().todate,
          refresh: true,
        );
        if (!res.isSuccess) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(res.message)));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerScreen(),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(Icons.menu, color: white),
          ),
          title: Text(
            "Tpipay Merchant",
            style: Helper(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600, fontSize: 18, color: white),
          ),
        ),
        body: Padding(
          padding: AppConstants.screenPadding,
          child: GetBuilder<ReportController>(builder: (reportController) {
            // read values once per build
            final isInitialLoading =
                reportController.transactionState.isInitialLoading;
            final isMoreLoading =
                reportController.transactionState.isMoreLoading;
            final bool hasActiveFilter =
                (reportController.selectedStatus != null &&
                        reportController.selectedStatus != 'All Status') ||
                    (reportController.searchQuery.isNotEmpty);

            reportController.setItemToShow(hasActiveFilter
                ? reportController.filterTransactionList
                : reportController.transactionList);

            return Column(
              children: [
                FilterByCalender(searchController: searchController),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reportController.isYesBankTransaction
                            ? "Yes bank merchant Transaction History"
                            : "All Transaction History",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(width: 8),
                    CustomButton(
                      onTap: () async {
                        reportController.setIsYesBankTransaction(
                            !reportController.isYesBankTransaction);
                        await loadingData();
                      },
                      height: 30,
                      color: reportController.isYesBankTransaction
                          ? primaryColor
                          : white,
                      radius: 20,
                      child: Text(
                        reportController.isYesBankTransaction
                            ? "All Transaction"
                            : "Yes Bank History",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: reportController.isYesBankTransaction
                                ? white
                                : greyText3),
                      ),
                    )
                  ],
                ),
                sizedBoxHeight(height: 18),
                // If no data and not loading show empty message
                if (reportController.itemsToShow.isEmpty && !isInitialLoading)
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 48.0),
                        child: Text("No transaction available"),
                      ),
                    ),
                  )
                else ...[
                  TransactionListSection(
                      scrollController: _scrollController,
                      isInitialLoading: isInitialLoading,
                      isMoreLoading: isMoreLoading),
                ],
              ],
            );
          }),
        ),
      ),
    );
  }
}
