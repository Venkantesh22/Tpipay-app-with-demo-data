// class PrepaidDetailsModel {
//   final String? mobileNumber;
//   final int? statusId;
//   final String? cardRefId;
//   final String? apiToken;

//   PrepaidDetailsModel({
//      this.mobileNumber,
//      this.statusId,
//      this.cardRefId,
//      this.apiToken,
//   });

//   factory PrepaidDetailsModel.fromJson(Map<String, dynamic> json) {
//     return PrepaidDetailsModel(
//       // Use ?? to provide valid default types
//       mobileNumber: json["mobile_number"]?.toString() ?? "",
//       statusId: json["status_id"] is int ? json["status_id"] : 0, 
//       cardRefId: json["cardRefId"]?.toString() ?? "N/A",
//       apiToken: json["api_token"]?.toString() ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "mobile_number": mobileNumber,
//     "status_id": statusId,
//     "cardRefId": cardRefId,
//     "api_token": apiToken,
//   };
// }

class PrepaidDetailsModel {
  final String? mobileNumber;
  final int? statusId;
  final String? cardRefId;
  final String? apiToken;

  PrepaidDetailsModel({
    this.mobileNumber,
    this.statusId,
    this.cardRefId,
    this.apiToken,
  });

  factory PrepaidDetailsModel.fromJson(Map<String, dynamic> json) {
    return PrepaidDetailsModel(
      mobileNumber: json["mobile_number"]?.toString() ?? "",
      statusId: json["status_id"] is int ? json["status_id"] : 0,
      cardRefId: json["cardRefId"]?.toString() ?? "N/A",
      apiToken: json["api_token"]?.toString() ?? "",
    );
  }

  // ✅ Local demo data
  factory PrepaidDetailsModel.demo() {
    return PrepaidDetailsModel(
      mobileNumber: "9876543210",
      statusId: 1,
      cardRefId: "8745321",
      apiToken: "demo_api_token_8745321",
    );
  }

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
        "status_id": statusId,
        "cardRefId": cardRefId,
        "api_token": apiToken,
      };
}

