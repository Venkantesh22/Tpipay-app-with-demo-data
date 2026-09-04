class PrepaidCardUserStatusModel {
  final CardDetails? cardDetails;
  final UserDetails? userDetails;

  PrepaidCardUserStatusModel({
    this.cardDetails,
    this.userDetails,
  });

  factory PrepaidCardUserStatusModel.fromJson(Map<String, dynamic> json) =>
      PrepaidCardUserStatusModel(
        cardDetails: json["cardDetails"] == null
            ? null
            : CardDetails.fromJson(json["cardDetails"]),
        userDetails: json["userDetails"] == null
            ? null
            : UserDetails.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "cardDetails": cardDetails?.toJson(),
        "userDetails": userDetails?.toJson(),
      };
}

class CardDetails {
  final List<int>? kycStatus;
  final List<int>? accessStatus;
  final List<Cards>? card;

  CardDetails({
    this.kycStatus,
    this.accessStatus,
    this.card,
  });

  factory CardDetails.fromJson(Map<String, dynamic> json) => CardDetails(
        kycStatus: json["kycStatus"] == null
            ? []
            : List<int>.from(json["kycStatus"].map((x) => x)),
        accessStatus: json["accessStatus"] == null
            ? []
            : List<int>.from(json["accessStatus"].map((x) => x)),
        card: json["card"] == null
            ? []
            : List<Cards>.from(json["card"].map((x) => Cards.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kycStatus": kycStatus ?? [],
        "accessStatus": accessStatus ?? [],
        "card": card?.map((x) => x.toJson()).toList() ?? [],
      };

  /// ✅ Helper getters (VERY IMPORTANT)

  int get kycStatusValue =>
      (kycStatus != null && kycStatus!.isNotEmpty) ? kycStatus!.first : 0;

  int get accessStatusValue =>
      (accessStatus != null && accessStatus!.isNotEmpty)
          ? accessStatus!.first
          : 0;

  /// ✅ Ready-to-use flags

  bool get isKycCompleted => kycStatusValue == 2;

  bool get hasFullAccess => accessStatusValue == 2;
}

class Cards {
  final int? cardStatusCode;
  final String? cardRefNo;
  final String? cardType;
  final String? cardStatus;

  Cards({
    this.cardStatusCode,
    this.cardRefNo,
    this.cardType,
    this.cardStatus,
  });

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
        cardStatusCode: json["cardStatusCode"],
        cardRefNo: json["cardRefNo"],
        cardType: json["cardType"],
        cardStatus: json["cardStatus"],
      );

  Map<String, dynamic> toJson() => {
        "cardStatusCode": cardStatusCode,
        "cardRefNo": cardRefNo,
        "cardType": cardType,
        "cardStatus": cardStatus,
      };
  bool get isCardStatusSuccess => cardStatus == "SUCCESS";
}

class UserDetails {
  final String? statusDesc;
  final String? status;
  final int? statusCode;

  UserDetails({
    this.statusDesc,
    this.status,
    this.statusCode,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        statusDesc: json["statusDesc"],
        status: json["status"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "statusDesc": statusDesc,
        "status": status,
        "statusCode": statusCode,
      };
}
