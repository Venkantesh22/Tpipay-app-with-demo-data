import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class DisputeRepo {
  final ApiClient apiClient;

  DisputeRepo({required this.apiClient});

  Future<Response> fetchDisputeReason({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postDisputeReason, "fetchDisputeReason", data);
  }

  Future<Response> saveDispute({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postSaveDispute, "saveDispute", data);
  }

  Future<Response> fetchSolverDisputePagination({
    required FormData data,
    required bool isFetchSolverDisputeList,
  }) async {
    return await apiClient.postData(
        isFetchSolverDisputeList
            ? AppConstants.postSolverDispute
            : AppConstants.postPendingDispute,
        isFetchSolverDisputeList
            ? "fetchSolverDisputePagination"
            : "fetchPendingDisputePagination",
        data);
  }
}
