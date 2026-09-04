import 'package:lekra/services/constants.dart';

class UserModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final int? roleId;
  final int? schemeId;
  final DateTime? joiningDate;
  final String? address;
  final String? city;
  final int? stateId;
  final int? districtId;
  final int? pinCode;
  final String? shopName;
  final String? officeAddress;
  final dynamic callBackUrl;
  final String? profilePhoto;
  final String? shopPhoto;
  final String? gstRegisrationPhoto;
  final String? pancardPhoto;
  final String? cancelCheque;
  final String? addressProof;
  final int? kycStatus;
  final String? kycRemark;
  final int? mobileVerified;
  final int? lockAmount;
  final String? sessionId;
  final int? active;
  final dynamic reason;
  final String? userBalance;
  final String? payinBalance;
  final String? aepsBalance;
  final String? lienAmount;
  final String? accountNumber;
  final String? ifscCode;
  final dynamic panUsername;
  final dynamic ekyc;
  final String? panNumber;
  final int? agentonboarding;
  final String? apiToken;
  final String? referralCode;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.roleId,
    this.schemeId,
    this.joiningDate,
    this.address,
    this.city,
    this.stateId,
    this.districtId,
    this.pinCode,
    this.shopName,
    this.officeAddress,
    this.callBackUrl,
    this.profilePhoto,
    this.shopPhoto,
    this.gstRegisrationPhoto,
    this.pancardPhoto,
    this.cancelCheque,
    this.addressProof,
    this.kycStatus,
    this.kycRemark,
    this.mobileVerified,
    this.lockAmount,
    this.sessionId,
    this.active,
    this.reason,
    this.userBalance,
    this.payinBalance,
    this.aepsBalance,
    this.lienAmount,
    this.accountNumber,
    this.ifscCode,
    this.panUsername,
    this.ekyc,
    this.panNumber,
    this.agentonboarding,
    this.apiToken,
    this.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        mobile: json["mobile"],
        roleId: json["role_id"],
        schemeId: json["scheme_id"],
        joiningDate: json["joining_date"] == null
            ? null
            : DateTime.parse(json["joining_date"]),
        address: json["address"],
        city: json["city"],
        stateId: json["state_id"],
        districtId: json["district_id"],
        pinCode: json["pin_code"],
        shopName: json["shop_name"],
        officeAddress: json["office_address"],
        callBackUrl: json["call_back_url"],
        profilePhoto: json["profile_photo"],
        shopPhoto: json["shop_photo"],
        gstRegisrationPhoto: json["gst_regisration_photo"],
        pancardPhoto: json["pancard_photo"],
        cancelCheque: json["cancel_cheque"],
        addressProof: json["address_proof"],
        kycStatus: json["kyc_status"],
        kycRemark: json["kyc_remark"],
        mobileVerified: json["mobile_verified"],
        lockAmount: json["lock_amount"],
        sessionId: json["session_id"],
        active: json["active"],
        reason: json["reason"],
        userBalance: json["user_balance"],
        payinBalance: json["payin_balance"],
        aepsBalance: json["aeps_balance"],
        lienAmount: json["lien_amount"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        panUsername: json["pan_username"],
        ekyc: json["ekyc"],
        panNumber: json["pan_number"],
        agentonboarding: json["agentonboarding"],
        apiToken: json["api_token"],
        referralCode: json["referral_code"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "role_id": roleId,
        "scheme_id": schemeId,
        "joining_date": joiningDate?.toIso8601String(),
        "address": address,
        "city": city,
        "state_id": stateId,
        "district_id": districtId,
        "pin_code": pinCode,
        "shop_name": shopName,
        "office_address": officeAddress,
        "call_back_url": callBackUrl,
        "profile_photo": profilePhoto,
        "shop_photo": shopPhoto,
        "gst_regisration_photo": gstRegisrationPhoto,
        "pancard_photo": pancardPhoto,
        "cancel_cheque": cancelCheque,
        "address_proof": addressProof,
        "kyc_status": kycStatus,
        "kyc_remark": kycRemark,
        "mobile_verified": mobileVerified,
        "lock_amount": lockAmount,
        "session_id": sessionId,
        "active": active,
        "reason": reason,
        "user_balance": userBalance,
        "payin_balance": payinBalance,
        "aeps_balance": aepsBalance,
        "lien_amount": lienAmount,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "pan_username": panUsername,
        "ekyc": ekyc,
        "pan_number": panNumber,
        "agentonboarding": agentonboarding,
        "api_token": apiToken,
        "referral_code": referralCode,
      };

  String get userBalanceFormat {
    String cleanedBalance = (userBalance ?? "0").replaceAll(',', '');

    double balance = double.tryParse(cleanedBalance) ?? 0.0;

    return PriceConverter.convertToNumberFormat(balance);
  }

  String get payinBalanceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse((payinBalance ?? "0").replaceAll(',', '')) ?? 0.0);

  String get aepsBalanceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse((aepsBalance ?? "0").replaceAll(',', '')) ?? 0.0);

  String get lienAmountFormat => PriceConverter.convertToNumberFormat(
      double.tryParse((lienAmount ?? "0").replaceAll(',', '')) ?? 0.0);

  String get fullName => "${firstName ?? ""}" + "${lastName ?? ""}";
  
  bool get isKYCDone => kycStatus == 1 ? true : false;
}
