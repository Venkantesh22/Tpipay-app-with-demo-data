import 'dart:developer';
import 'dart:math' show max;
import 'package:get/get.dart';
import 'package:lekra/data/models/pagination/pagination_state.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/data/repositories/report_repo.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/graph.dart';

class ReportController extends GetxController implements GetxService {
  final ReportRepo reportRepo;
  ReportController({required this.reportRepo});

  bool isLoading = false;

  List<TransactionModel> yesBankMerchantCollectionList = [];
  Future<ResponseModel> fetchYesBankMerchantCollection({
    required String fromdate,
    required String todate,
  }) async {
    log('----------- fetchYesBankMerchantCollection Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await reportRepo.fetchYesBankMerchantCollection(
          fromdate: fromdate, todate: todate);

      if (response.statusCode == 200 && response.body['status'] == "success") {
        yesBankMerchantCollectionList = (response.body['reports'] as List)
            .map((trans) => TransactionModel.fromJson(trans))
            .toList();
        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                "fetch fetchYesBankMerchantCollection success");
        log("yesBankMerchantCollectionList = ${yesBankMerchantCollectionList.length}");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Error while fetchYesBankMerchantCollection");
      }
    } catch (e) {
      log('ERROR AT fetchYesBankMerchantCollection(): $e');
      responseModel = ResponseModel(
          false, "Error while fetchYesBankMerchantCollection user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  bool isYesBankTransaction = false;
  void setIsYesBankTransaction(bool value) {
    isYesBankTransaction = value;
    log("isYesBankTransaction ==== $isYesBankTransaction");
    update();
  }

  List<TransactionModel> transactionReportList = [];

  Future<ResponseModel> fetchTransactionReport({
    required String fromdate,
    required String todate,
    bool isShowOnly10 = false,
  }) async {
    log('----------- fetchTransactionReport Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await reportRepo.fetchTransactionReport(
          fromdate: fromdate, todate: todate);

      if (response.statusCode == 200 &&
          response.body['status'] == "success" &&
          response.body['reports'] is List) {
        // Parse all items first
        final allReports = (response.body['reports'] as List)
            .map((trans) => TransactionModel.fromJson(trans))
            .toList();

        // Apply the isShowOnly10 filter if requested
        if (isShowOnly10 && allReports.length > 10) {
          transactionReportList = allReports.sublist(0, 10);
          log("isShowOnly10=true — showing first 10 of ${allReports.length}");
        } else {
          transactionReportList = allReports;
          log("showing all ${transactionReportList.length} reports");
        }

        responseModel = ResponseModel(true,
            response.body['message'] ?? "fetch fetchTransactionReport success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchTransactionReport");
      }
    } catch (e) {
      log('ERROR AT fetchTransactionReport(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchTransactionReport user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

// how many filtered items we attempt to prefetch for (tweak as needed)
  final int _filterPrefetchThreshold = 10;

// guard to avoid concurrent auto-load attempts
  bool _autoLoadingMoreForFilter = false;

  Future<void> _ensureFilteredResults() async {
    // only run for active (non-"All") status filters or when search is on
    final bool activeFilter =
        (selectedStatus != null && selectedStatus != 'All Status') ||
            searchQuery.isNotEmpty;
    if (!activeFilter) return;

    if (_autoLoadingMoreForFilter) return;
    _autoLoadingMoreForFilter = true;

    try {
      // loop until we have enough filtered items or no more pages
      while (filterTransactionList.length < _filterPrefetchThreshold &&
          transactionState.canLoadMore) {
        final previousTotal = transactionState.items.length;

        // request next page. Use controller's fromDate/todate fields already present in controller
        final res = await fetchTransactionReportPagination(
          fromdate: fromDate,
          todate: todate,
          loadMore: true,
        );

        // if fetch failed, stop trying
        if (!res.isSuccess) break;

        // if no new canonical items were added (defensive), stop to avoid infinite loop
        if (transactionState.items.length == previousTotal) break;

        // applyFilters() is already called inside fetchTransactionReportPagination after updating items,
        // but ensure filters are applied in case API shape differs
        applyFilters();
      }
    } finally {
      _autoLoadingMoreForFilter = false;
    }
  }

  final PaginationState<TransactionModel> transactionState =
      PaginationState<TransactionModel>();
  List<TransactionModel> get transactionList => transactionState.items;

  Future<ResponseModel> fetchTransactionReportPagination({
    required String fromdate,
    required String todate,
    bool loadMore = false,
    bool refresh = false,
    bool isYesBankCollect = false,
    bool getFullData = false, // NEW: fetch all pages (from page 1 .. lastPage)
  }) async {
    log('fetchTransactionReportPagination called (fromdate: $fromdate todate: $todate   loadMore: $loadMore, refresh: $refresh, getFullData: $getFullData)');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");

    // If requesting full data we always start fresh from page 1
    if (getFullData) {
      transactionState.reset();
      transactionState.page = 1;
    } else if (refresh) {
      transactionState.reset();
      transactionState.page = 1;
    }

    if (getFullData) {
      // full fetch: fetch sequential pages from 1..lastPage (best-effort)
      transactionState.isInitialLoading = true;
      update();

      int page = 1;
      int lastPageFromApi = 1;
      bool encounteredError = false;
      try {
        while (true) {
          final Response response = isYesBankCollect
              ? await reportRepo.fetchYesBankMerchantCollection(
                  fromdate: fromdate, todate: todate, page: page)
              : await reportRepo.fetchTransactionReport(
                  fromdate: fromdate, todate: todate, page: page);

          if (response.statusCode != 200) {
            encounteredError = true;
            responseModel =
                ResponseModel(false, "Status code: ${response.statusCode}");
            break;
          }

          final statusVal = response.body['status'];
          final success = (statusVal == true) ||
              (statusVal is String &&
                  statusVal.toString().toLowerCase() == 'success');

          if (!success) {
            encounteredError = true;
            responseModel =
                ResponseModel(false, response.body['message'] ?? "Failed");
            break;
          }

          // parse pagination info (robust to different field names)
          final int currentPage = (response.body['page'] ??
              response.body['pageNumber'] ??
              page) as int;
          final int lastPage = (response.body['pages'] ??
              response.body['last_page'] ??
              1) as int;
          lastPageFromApi = lastPage;

          final List reportsJson = (response.body['reports'] ?? []) as List;
          final parsedData = reportsJson
              .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList();

          // merge with dedupe
          for (final p in parsedData) {
            if (!transactionState.dedupeIds.contains(p.id)) {
              transactionState.dedupeIds.add(p.id);
              transactionState.items.add(p);
            }
          }

          log("Fetched page $page / $lastPage, items added: ${parsedData.length}");

          // finished all pages?
          if (currentPage >= lastPage) {
            transactionState.page = currentPage;
            transactionState.lastPage = lastPage;
            break;
          }

          // otherwise continue to next page
          page += 1;
        }

        // set success if we didn't encounter error
        if (!encounteredError) {
          responseModel =
              ResponseModel(true, "Fetched all pages up to $lastPageFromApi");
        }
      } catch (e) {
        log("****** Error ****** $e",
            name: "fetchTransactionReportPagination(getFullData)");
        responseModel = ResponseModel(false, "Error: $e");
      } finally {
        transactionState.isInitialLoading = false;
        transactionState.isMoreLoading = false;
        // rebuild any filtered view based on canonical list
        applyFilters();
        update();
      }

      return responseModel;
    }

    // ---------- previous single-page / loadMore flow ----------
    if (loadMore) {
      if (!transactionState.canLoadMore) {
        return ResponseModel(false, "No more pages");
      }
      transactionState.page += 1;
      transactionState.isMoreLoading = true;
    } else {
      transactionState.isInitialLoading = true;
      transactionState.page = 1;
    }
    update();

    try {
      final Response response = isYesBankCollect
          ? await reportRepo.fetchYesBankMerchantCollection(
              fromdate: fromdate, todate: todate, page: transactionState.page)
          : await reportRepo.fetchTransactionReport(
              fromdate: fromdate, todate: todate, page: transactionState.page);

      if (response.statusCode == 200) {
        final statusVal = response.body['status'];
        final success = (statusVal == true) ||
            (statusVal is String &&
                statusVal.toString().toLowerCase() == 'success');

        if (success) {
          final int currentPage = (response.body['page'] ??
              response.body['pageNumber'] ??
              transactionState.page) as int;
          final int lastPage = (response.body['pages'] ??
              response.body['last_page'] ??
              1) as int;

          final List reportsJson = (response.body['reports'] ?? []) as List;
          final parsedData = reportsJson
              .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList();

          transactionState.lastPage = lastPage;
          transactionState.page = currentPage;

          if (loadMore) {
            for (final p in parsedData) {
              if (!transactionState.dedupeIds.contains(p.id)) {
                transactionState.dedupeIds.add(p.id);
                transactionState.items.add(p);
              }
            }
          } else {
            transactionState.items
              ..clear()
              ..addAll(parsedData);
            transactionState.dedupeIds.clear();
            transactionState.dedupeIds.addAll(parsedData.map((e) => e.id));
          }

          // rebuild filtered view after updating canonical list
          applyFilters();

          responseModel = ResponseModel(true, "Fetched transactions");
        } else {
          responseModel =
              ResponseModel(false, response.body['message'] ?? "Failed");
        }
      } else {
        responseModel =
            ResponseModel(false, "Status code: ${response.statusCode}");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error: $e");
      log("****** Error ****** $e", name: "fetchTransactionReportPagination");
      if (loadMore && transactionState.page > 1) {
        transactionState.page -= 1; // rollback page on failure
      }
    } finally {
      transactionState.isInitialLoading = false;
      transactionState.isMoreLoading = false;
      update();
    }

    return responseModel;
  }

  TransactionModel? selectTransactionModel;

  void setTransactionModel(TransactionModel value) {
    selectTransactionModel = value;
    log("selectTransactionModel == ${selectTransactionModel?.id}");
    update();
  }

  final List<TransactionModel> itemsToShow = [];
  void setItemToShow(List<TransactionModel> value) {
    itemsToShow.clear();
    itemsToShow.addAll(value);
  }

  List<HourlyPoint> graphDataList = [];
  double totalRawAmount = 0.0;

  void convertTODataForGraph(
    List<TransactionModel> list, {
    bool aggregateHourly = true,
    bool reverseResult = false,
    DateTime? baseDate,
  }) {
    isLoading = true;
    update();
    graphDataList.clear();

    if (list.isEmpty) {
      isLoading = false;
      update();
      return;
    }

    /// ✅ Filter only "Success" status
    final filteredList =
        list.where((t) => t.status == TransactionStatus.SUCCESS).toList();

    if (filteredList.isEmpty) {
      isLoading = false;
      update();
      return;
    }

    final now = DateTime.now();
    final anchor = baseDate ?? DateTime(now.year, now.month, now.day);

    double parseAmount(String? s) {
      if (s == null) return 0.0;
      final cleaned = s.replaceAll(RegExp(r'[^\d\.\-]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    totalRawAmount = filteredList.fold(
      0.0,
      (sum, t) => sum + parseAmount(t.amount),
    );

    if (aggregateHourly) {
      final totals = List<double>.filled(24, 0.0);

      for (final t in filteredList) {
        final dt = t.createdAt ?? now;
        final hour = dt.hour.clamp(0, 23);
        final amount = parseAmount(t.amount);

        // 🔥 FIX: take peak (max), not total sum
        totals[hour] = max(totals[hour], amount);
      }

      for (int h = 0; h < 24; h++) {
        final time = anchor.add(Duration(hours: h));
        final value = double.parse(totals[h].toStringAsFixed(2));
        graphDataList.add(HourlyPoint(time, value));
      }
    } else {
      /// Raw graph points (one per transaction)
      for (final t in filteredList) {
        final dt = t.createdAt ?? now;
        final value = double.parse(parseAmount(t.amount).toStringAsFixed(2));
        graphDataList.add(HourlyPoint(dt, value));
      }

      graphDataList.sort((a, b) => a.time.compareTo(b.time));
    }

    if (reverseResult) {
      graphDataList = graphDataList.reversed.toList();
    }
    isLoading = false;
    update();
  }

  final List<String>? statusOptionsList = [
    "All Status",
    "Success",
    "Failure",
    "Pending",
    "Credited",
  ];

  String? selectedStatus = "All Status";
  bool statusSelected = false;

  // ---------------- Filtering/Search ----------------
  List<TransactionModel> filterTransactionList = [];

  final Map<String, TransactionStatus> _displayToEnum = {
    'Success': TransactionStatus.SUCCESS,
    'Failure': TransactionStatus.FAILURE,
    'Pending': TransactionStatus.PENDING,
    'Credited': TransactionStatus.CREDIT,
    'Credit': TransactionStatus.CREDIT,
  };

  String searchQuery = '';

  void applyFilters() {
    // start from canonical list (all loaded transactions)
    final List<TransactionModel> base =
        List<TransactionModel>.from(transactionList);

    List<TransactionModel> list = base;

    // 1) status filter
    if (selectedStatus != null &&
        selectedStatus != 'All Status' &&
        selectedStatus!.isNotEmpty) {
      final label = selectedStatus!;
      final mapped = _displayToEnum[label];
      if (mapped != null) {
        list = list.where((t) => t.status == mapped).toList();
      } else {
        final lower = label.toLowerCase();
        list = list.where((t) => t.statusText.toLowerCase() == lower).toList();
      }
    }

    // 2) search filter — EXACT NUMERIC MATCH ONLY
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.trim();

      // convert search to number
      final double? qNum =
          double.tryParse(q.replaceAll(',', '').replaceAll(' ', ''));

      // If search input is not a valid number → return empty result (or keep list unchanged)
      if (qNum == null) {
        list = [];
      } else {
        const eps = 0.0001; // tiny tolerance for floating point
        list = list.where((t) {
          final amtString = (t.amount ?? "0").replaceAll(',', '').trim();
          final double? amtNum = double.tryParse(amtString);
          if (amtNum == null) return false;

          return (amtNum - qNum).abs() < eps; // exact match only
        }).toList();
      }
    }

    filterTransactionList
      ..clear()
      ..addAll(list);

    update();
    _ensureFilteredResults();
  }

  /// Call from UI when search text changes
  void setSearchQuery(String q) {
    searchQuery = q.trim();
    applyFilters();
  }

  void setSelectOption(String? value) {
    selectedStatus = value;
    setStatusSelected(value != null && value != 'All Status');
    applyFilters();
  }

  void setStatusSelected(bool value) {
    statusSelected = value;
    update();
  }

  String fromDate = DateFormatters().yMD.format(DateTime(2024, 1, 1));
  String todate = DateFormatters().yMD.format(DateTime.now());

  void setDate({required String fromDateValue, required String todateValue}) {
    log("fromDateValue : $fromDateValue, todateValue : $todateValue");
    fromDate = fromDateValue;
    todate = todateValue;
  }

  void setAllTransactionToYesBankTransaction(List<TransactionModel> valueList) {
    transactionList.cast();
    transactionList.addAll(valueList);
    update();
  }
}
