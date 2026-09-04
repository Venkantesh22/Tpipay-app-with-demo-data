class CheckCustomKyc {
  final String? status;
  final bool? success;
  final String? kycStatus;
  final bool? canWithdraw;
  final String? message;
  final Data? data;

  CheckCustomKyc({
    this.status,
    this.success,
    this.kycStatus,
    this.canWithdraw,
    this.message,
    this.data,
  });

  factory CheckCustomKyc.fromJson(Map<String, dynamic> json) => CheckCustomKyc(
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
  final String? mobileNumber;

  Data({
    this.mobileNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
      };
}
