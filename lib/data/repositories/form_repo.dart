import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class FormRepo {
  final ApiClient apiClient;
  FormRepo({required this.apiClient});

  Future<Response> postUploadKYC({required FormData data}) async {
    return await apiClient.postData(
        AppConstants.postCreateVPA, "postUploadKYC", data);
  }
}
