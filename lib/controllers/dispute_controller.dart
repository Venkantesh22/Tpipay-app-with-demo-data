import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/disputer_model/dispute_model.dart';
import 'package:lekra/data/models/disputer_model/dispute_reason_model.dart';
import 'package:lekra/data/models/pagination/pagination_state.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/dispute_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisputeController extends GetxController implements GetxService {
  final DisputeRepo disputeRepo;
  final SharedPreferences sharedPreferences;

  DisputeController({
    required this.disputeRepo,
    required this.sharedPreferences,
  });
  bool isLoading = false;

  List<DisputeReasonModel> disputeReasonList = [];
  Future<ResponseModel> fetchDisputeReason() async {
    log('----------- fetchDisputeReason Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
      };
      Response response =
          await disputeRepo.fetchDisputeReason(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        disputeReasonList = (response.body['reason'] as List)
            .map((product) => DisputeReasonModel.fromJson(product))
            .toList();

        responseModel = ResponseModel(true,
            response.body['message'] ?? "fetch fetchDisputeReason success");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Error while fetchDisputeReason");
      }
    } catch (e) {
      log('ERROR AT fetchDisputeReason(): $e');
      responseModel =
          ResponseModel(false, "Error while fetchDisputeReason user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String? selectedDisputeReason;
  DisputeReasonModel? selectDisputeReasonModel;

  TextEditingController disputeMessageController = TextEditingController();

  void setDisputeReasonModel(String? value) {
    if (value == null) return;

    selectedDisputeReason = value;
    selectDisputeReasonModel = disputeReasonList.firstWhere(
      (element) => element.reason == value,
      orElse: () => disputeReasonList.first,
    );
    log("select dispute : ${selectDisputeReasonModel?.reason} ${selectDisputeReasonModel?.reasonId}");
    update();
  }

  Future<ResponseModel> saveDispute({required int? reportId}) async {
    log('----------- saveDispute Called ----------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
        'report_id': reportId.toString(),
        'reason': selectDisputeReasonModel?.reasonId.toString(),
        'message': disputeMessageController.text.trim(),
      };

      Response response = await disputeRepo.saveDispute(data: FormData(data));

      if (response.statusCode == 200) {
        if (response.body['status'] == "success") {
          responseModel =
              ResponseModel(true, response.body['message'] ?? "Success");
        } else {
          String errorMessage = "Validation Error";
          if (response.body['errors'] is Map) {
            var errors = response.body['errors'] as Map;
            if (errors.isNotEmpty) {
              var firstKey = errors.keys.first;
              errorMessage = errors[firstKey][0].toString();
            }
          } else {
            errorMessage = response.body['message'] ?? "Unknown Error";
          }
          responseModel = ResponseModel(false, errorMessage);
        }
      } else {
        responseModel =
            ResponseModel(false, "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      log('ERROR AT saveDispute(): $e');
      responseModel = ResponseModel(false, "Error: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  final PaginationState<DisputeModel> disputeState =
      PaginationState<DisputeModel>();
  List<DisputeModel> get disputeList => disputeState.items;

  Future<ResponseModel> fetchSolverDisputePagination({
    bool loadMore = false,
    bool refresh = false,
    bool getFullData = false,
    bool isFetchSolverDisputeList = true,
  }) async {
    log('${isFetchSolverDisputeList ? "fetchSolverDisputePagination" : "fetchPendingDisputePagination"} called (   loadMore: $loadMore, refresh: $refresh, getFullData: $getFullData)');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");

    // If requesting full data we always start fresh from page 1
    if (getFullData) {
      disputeState.reset();
      disputeState.page = 1;
    } else if (refresh) {
      disputeState.reset();
      disputeState.page = 1;
    }

    if (getFullData) {
      // full fetch: fetch sequential pages from 1..lastPage (best-effort)
      disputeState.isInitialLoading = true;
      update();

      int page = 1;
      int lastPageFromApi = 1;
      bool encounteredError = false;

      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
      };
      try {
        while (true) {
          final Response response =
              await disputeRepo.fetchSolverDisputePagination(
                  data: FormData(data),
                  isFetchSolverDisputeList: isFetchSolverDisputeList);

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
              .map((e) => DisputeModel.fromJson(e as Map<String, dynamic>))
              .toList();

          // merge with dedupe
          for (final p in parsedData) {
            if (!disputeState.dedupeIds.contains(p.ticketId)) {
              disputeState.dedupeIds.add(p.ticketId);
              disputeState.items.add(p);
            }
          }

          log("Fetched page $page / $lastPage, items added: ${parsedData.length}");

          // finished all pages?
          if (currentPage >= lastPage) {
            disputeState.page = currentPage;
            disputeState.lastPage = lastPage;
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
        disputeState.isInitialLoading = false;
        disputeState.isMoreLoading = false;
        // rebuild any filtered view based on canonical list
        update();
      }

      return responseModel;
    }

    // ---------- previous single-page / loadMore flow ----------
    if (loadMore) {
      if (!disputeState.canLoadMore) {
        return ResponseModel(false, "No more pages");
      }
      disputeState.page += 1;
      disputeState.isMoreLoading = true;
    } else {
      disputeState.isInitialLoading = true;
      disputeState.page = 1;
    }
    update();

    try {
      Map<String, dynamic> data = {
        'api_token': sharedPreferences.getString(AppConstants.apiToken),
      };
      final Response response = await disputeRepo.fetchSolverDisputePagination(
          data: FormData(data),
          isFetchSolverDisputeList: isFetchSolverDisputeList);

      if (response.statusCode == 200) {
        final statusVal = response.body['status'];
        final success = (statusVal == true) ||
            (statusVal is String &&
                statusVal.toString().toLowerCase() == 'success');

        if (success) {
          final int currentPage = (response.body['page'] ??
              response.body['pageNumber'] ??
              disputeState.page) as int;
          final int lastPage = (response.body['pages'] ??
              response.body['last_page'] ??
              1) as int;

          final List reportsJson = (response.body['reports'] ?? []) as List;
          final parsedData = reportsJson
              .map((e) => DisputeModel.fromJson(e as Map<String, dynamic>))
              .toList();

          disputeState.lastPage = lastPage;
          disputeState.page = currentPage;

          if (loadMore) {
            for (final p in parsedData) {
              if (!disputeState.dedupeIds.contains(p.ticketId)) {
                disputeState.dedupeIds.add(p.ticketId);
                disputeState.items.add(p);
              }
            }
          } else {
            disputeState.items
              ..clear()
              ..addAll(parsedData);
            disputeState.dedupeIds.clear();
            disputeState.dedupeIds.addAll(parsedData.map((e) => e.ticketId));
          }

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
      if (loadMore && disputeState.page > 1) {
        disputeState.page -= 1; // rollback page on failure
      }
    } finally {
      disputeState.isInitialLoading = false;
      disputeState.isMoreLoading = false;
      update();
    }

    return responseModel;
  }

  DisputeModel? selectDisputeModel;

  void setSelectDisputeModel(DisputeModel? value) {
    selectDisputeModel = value;
    update();
  }
}
