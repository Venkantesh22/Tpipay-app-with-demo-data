import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class CardRepo {
  final ApiClient apiClient;
  final ApiClient prepaidClient; // 👈 new

  CardRepo({
    required this.apiClient,
    required this.prepaidClient,
  });

  Future<Response> generateOTPForPrepaidCard({required FormData data}) async {
    return await prepaidClient.postData(
        AppConstants.postPrepaidGenerateOTP, "generateOTPForPaid", data);
  }

  Future<Response> verificationOTPForPrepaidCard(
      {required FormData data}) async {
    return await prepaidClient.postData(AppConstants.postPrepaidVerifyOTP,
        "verificationOTPForPrepaidCard", data);
  }

  Future<Response> cardCustomOnBoarding({required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postCardCustomOnBoarding,
      "cardCustomOnBoarding",
      data,
    );
  }

  Future<Response> fetchCardDetailsByCardReference(
      {required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postViewCardDetailsByCardReference,
      "CardDetailsByCardReference",
      data,
    );
  }

  Future<Response> prepaidCardAddBalance({required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postAddBalance,
      "prepaidCardAddBalance",
      data,
    );
  }

  Future<Response> fetchPrepaidCardBalanceInquiry(
      {required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postBalanceInquiry,
      "fetchPrepaidCardBalanceInquiry",
      data,
    );
  }

  Future<Response> prepaidCardResetPIN({required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postResetPIN,
      "prepaidCardResetPIN",
      data,
    );
  }

  Future<Response> prepaidCheckUserStatus({required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postUserStatusCheck,
      "prepaidCheckUserStatus",
      data,
    );
  }

  Future<Response> fetchPrepaidCardMiniStatement(
      {required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postPrepaidCardMiniStatement,
      "prepaidCardMiniStatement",
      data,
    );
  }

  Future<Response> fetchPrepaidCardDetails({required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postPpcardDetails,
      "fetchPrepaidCardDetails",
      data,
    );
  }

  Future<Response> fetchPrepaidCardCVVNo({required FormData data}) async {
    return await prepaidClient.postData(
      AppConstants.postPrepaidCardCVVNo,
      "fetchPrepaidCardCVVNo",
      data,
    );
  }
}
