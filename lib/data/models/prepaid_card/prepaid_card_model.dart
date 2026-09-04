// class PrepaidCardModel {
//   final String? cardNumber;
//   final String? expiryDate;
//   final String? nameOnCard;
//   final String? cvv;
//   final String? lastFourDigit;
//   final int? cardRefId;
//   final bool? isVirtual;
//   final bool? isActive;
//   final String? productCategory;
//   final String? networkType;

//   PrepaidCardModel({
//     this.cardNumber,
//     this.expiryDate,
//     this.nameOnCard,
//     this.cvv,
//     this.lastFourDigit,
//     this.cardRefId,
//     this.isVirtual,
//     this.isActive,
//     this.productCategory,
//     this.networkType,
//   });

//   factory PrepaidCardModel.fromJson(Map<String, dynamic> json) =>
//       PrepaidCardModel(
//         cardNumber: cleanString(json["cardNumber"]),
//         expiryDate: formatExpiry(json["expiryDate"]),
//         nameOnCard: cleanString(json["nameOnCard"]),
//         cvv: json["cvv"],
//         lastFourDigit: cleanString(json["lastFourDigit"]),
//         cardRefId: json["cardRefId"],
//         isVirtual: json["isVirtual"],
//         // isActive: false,
//         isActive: json["isActive"],
//         productCategory: cleanString(json["productCategory"]),
//         networkType: cleanString(json["networkType"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "cardNumber": cardNumber,
//         "expiryDate": expiryDate,
//         "nameOnCard": nameOnCard,
//         "cvv": cvv,
//         "lastFourDigit": lastFourDigit,
//         "cardRefId": cardRefId,
//         "isVirtual": isVirtual,
//         "isActive": isActive,
//         "productCategory": productCategory,
//         "networkType": networkType,
//       };

//   PrepaidCardModel copyWith({
//     String? cardNumber,
//     String? expiryDate,
//     String? nameOnCard,
//     String? cvv,
//     String? lastFourDigit,
//     int? cardRefId,
//     bool? isVirtual,
//     bool? isActive,
//     String? productCategory,
//     String? networkType,
//   }) =>
//       PrepaidCardModel(
//         cardNumber: cardNumber ?? this.cardNumber,
//         expiryDate: expiryDate ?? this.expiryDate,
//         nameOnCard: nameOnCard ?? this.nameOnCard,
//         cvv: cvv ?? this.cvv,
//         lastFourDigit: lastFourDigit ?? this.lastFourDigit,
//         cardRefId: cardRefId ?? this.cardRefId,
//         isVirtual: isVirtual ?? this.isVirtual,
//         isActive: isActive ?? this.isActive,
//         productCategory: productCategory ?? this.productCategory,
//         networkType: networkType ?? this.networkType,
//       );

//   String get cardStates => isActive == true ? "Active" : "Deactivate";

//   String get formatCardNumber {
//     if (cardNumber == null || cardNumber!.isEmpty) return "N/A";
//     String formatted = "";
//     for (int i = 0; i < cardNumber!.length; i++) {
//       if (i != 0 && i % 4 == 0) {
//         formatted += "-";
//       }
//       formatted += cardNumber![i];
//     }
//     return formatted;
//   }

//   String get formatCardNumberLastFourDigit =>
//       "XXXX-XXXX-XXXX-${lastFourDigit ?? "N/A"}";
// }

// String? cleanString(dynamic value) {
//   if (value == null) return null;

//   String str = value.toString().trim();

//   // Remove leading & trailing quotes only
//   if (str.startsWith('"') && str.endsWith('"')) {
//     str = str.substring(1, str.length - 1);
//   }

//   return str;
// }

// String? formatExpiry(dynamic value) {
//   String? cleaned = cleanString(value);

//   if (cleaned == null || cleaned.length != 6) return cleaned;

//   String month = cleaned.substring(0, 2);
//   String year = cleaned.substring(2); // 4 digit year

//   return "$month/$year"; // 03/2031
// }

class PrepaidCardModel {
  final String? cardNumber;
  final String? expiryDate;
  final String? nameOnCard;
  final String? cvv;
  final String? lastFourDigit;
  final int? cardRefId;
  final bool? isVirtual;
  final bool? isActive;
  final String? productCategory;
  final String? networkType;

  PrepaidCardModel({
    this.cardNumber,
    this.expiryDate,
    this.nameOnCard,
    this.cvv,
    this.lastFourDigit,
    this.cardRefId,
    this.isVirtual,
    this.isActive,
    this.productCategory,
    this.networkType,
  });

  factory PrepaidCardModel.fromJson(Map<String, dynamic> json) =>
      PrepaidCardModel(
        cardNumber: cleanString(json["cardNumber"]),
        expiryDate: formatExpiry(json["expiryDate"]),
        nameOnCard: cleanString(json["nameOnCard"]),
        cvv: cleanString(json["cvv"]),
        lastFourDigit: cleanString(json["lastFourDigit"]),
        cardRefId: json["cardRefId"],
        isVirtual: json["isVirtual"],
        isActive: json["isActive"],
        productCategory: cleanString(json["productCategory"]),
        networkType: cleanString(json["networkType"]),
      );

  /// Local card data for UI/demo testing.
  /// Remove this factory when the API is ready.
  factory PrepaidCardModel.demo() {
    return PrepaidCardModel(
      cardNumber: "4567321987654321",
      expiryDate: "03/2031",
      nameOnCard: "VENKATESH RATHOD",
      cvv: "482",
      lastFourDigit: "4321",
      cardRefId: 8745321,
      isVirtual: true,
      isActive: true,
      productCategory: "GPR",
      networkType: "VISA",
    );
  }

  Map<String, dynamic> toJson() => {
        "cardNumber": cardNumber,
        "expiryDate": expiryDate,
        "nameOnCard": nameOnCard,
        "cvv": cvv,
        "lastFourDigit": lastFourDigit,
        "cardRefId": cardRefId,
        "isVirtual": isVirtual,
        "isActive": isActive,
        "productCategory": productCategory,
        "networkType": networkType,
      };

  PrepaidCardModel copyWith({
    String? cardNumber,
    String? expiryDate,
    String? nameOnCard,
    String? cvv,
    String? lastFourDigit,
    int? cardRefId,
    bool? isVirtual,
    bool? isActive,
    String? productCategory,
    String? networkType,
  }) =>
      PrepaidCardModel(
        cardNumber: cardNumber ?? this.cardNumber,
        expiryDate: expiryDate ?? this.expiryDate,
        nameOnCard: nameOnCard ?? this.nameOnCard,
        cvv: cvv ?? this.cvv,
        lastFourDigit: lastFourDigit ?? this.lastFourDigit,
        cardRefId: cardRefId ?? this.cardRefId,
        isVirtual: isVirtual ?? this.isVirtual,
        isActive: isActive ?? this.isActive,
        productCategory: productCategory ?? this.productCategory,
        networkType: networkType ?? this.networkType,
      );

  String get cardStates => isActive == true ? "Active" : "Deactivate";

  String get formatCardNumber {
    if (cardNumber == null || cardNumber!.isEmpty) return "N/A";

    String formatted = "";

    for (int i = 0; i < cardNumber!.length; i++) {
      if (i != 0 && i % 4 == 0) {
        formatted += "-";
      }

      formatted += cardNumber![i];
    }

    return formatted;
  }

  String get formatCardNumberLastFourDigit =>
      "XXXX-XXXX-XXXX-${lastFourDigit ?? "N/A"}";
}

String? cleanString(dynamic value) {
  if (value == null) return null;

  String str = value.toString().trim();

  if (str.startsWith('"') && str.endsWith('"')) {
    str = str.substring(1, str.length - 1);
  }

  return str;
}

String? formatExpiry(dynamic value) {
  String? cleaned = cleanString(value);

  if (cleaned == null || cleaned.length != 6) return cleaned;

  String month = cleaned.substring(0, 2);
  String year = cleaned.substring(2);

  return "$month/$year";
}
