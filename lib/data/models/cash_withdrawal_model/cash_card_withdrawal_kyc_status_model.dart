enum KycStatus {
  pending,
  verified,
  rejected,
}

class CardCashWithdrawalCustomKycStatusModel {
  final String? status;
  final bool? success;
  final String? kycStatus;
  final bool? canWithdraw;
  final String? message;
  final Data? data;

  CardCashWithdrawalCustomKycStatusModel({
    this.status,
    this.success,
    this.kycStatus,
    this.canWithdraw,
    this.message,
    this.data,
  });

  factory CardCashWithdrawalCustomKycStatusModel.fromJson(
          Map<String, dynamic> json) =>
      CardCashWithdrawalCustomKycStatusModel(
        status: json["status"],
        success: json["success"],
        kycStatus: json["kyc_status"],
        canWithdraw: json["can_withdraw"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "kyc_status": kycStatus,
        "can_withdraw": canWithdraw,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? fullName;
  final String? mobileNumber;
  final String? status;

  Data({
    this.id,
    this.fullName,
    this.mobileNumber,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fullName: json["full_name"],
        mobileNumber: json["mobile_number"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "mobile_number": mobileNumber,
        "status": status,
      };
}
