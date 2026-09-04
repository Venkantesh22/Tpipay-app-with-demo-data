// import 'dart:developer';

// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/date_formatters_and_converters.dart';

// class PrepaidCardMiniStatementModel {
//   final DateTime? txnDate;
//   final String? description;
//   final String? amount;

//   PrepaidCardMiniStatementModel({
//     this.txnDate,
//     this.description,
//     this.amount,
//   });

//   factory PrepaidCardMiniStatementModel.fromJson(Map<String, dynamic> json) =>
//       PrepaidCardMiniStatementModel(
//         txnDate: json["txn_date"] == null
//             ? null
//             : DateTime.parse(json["txn_date"]).toLocal(),
//         description: json["description"]?.toString() ?? "",
//         amount: json["amount"]?.toString() ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "txn_date":
//             "${txnDate!.year.toString().padLeft(4, '0')}-${txnDate!.month.toString().padLeft(2, '0')}-${txnDate!.day.toString().padLeft(2, '0')}",
//         "description": description,
//         "amount": amount,
//       };

//   String get formatDate =>
//       DateFormatters().dMonthYear.format(txnDate ?? getDateTime());

//   String get formatAmount {
//     // 1. Clean the string: remove commas and the '+' sign
//     // double.tryParse handles '-' fine, but fails on '+' and ','
//     final cleanAmount =
//         amount?.replaceAll(",", "").replaceAll("+", "").replaceAll("-", "") ??
//             "0.0";
//     log("check --1 cleanAmount == $cleanAmount");

//     // 2. Parse the cleaned string to a double
//     double value = double.tryParse(cleanAmount) ?? 0.0;

//     // 3. Use .abs() to ensure we get a positive number for formatting
//     double absoluteValue = value.abs();

//     // 4. Return formatted number via your PriceConverter
//     return PriceConverter.convertToNumberFormat(absoluteValue);
//   }

//   String get transactionType =>
//       amount?.contains("-") ?? false ? "Debit" : "Credit";

//   bool get isDebit => amount?.contains("-") ?? false;
// }

// List<PrepaidCardMiniStatementModel> prepaidCardMiniStatementModelListForModel =
//     [
//   PrepaidCardMiniStatementModel(
//       description: "ATM Withdrawal", amount: "-2000", txnDate: getDateTime()),
//   PrepaidCardMiniStatementModel(
//       description: "ATM Withdrawal1", amount: "+2000", txnDate: getDateTime()),
//   PrepaidCardMiniStatementModel(
//       description: "ATM Withdrawal1", amount: "+2000", txnDate: getDateTime()),
//   PrepaidCardMiniStatementModel(
//       description: "ATM Withdrawal1", amount: "-2000", txnDate: getDateTime()),
//   PrepaidCardMiniStatementModel(
//       description: "ATM Withdrawal1", amount: "+2000", txnDate: getDateTime()),
// ];


import 'dart:developer';

import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';

class PrepaidCardMiniStatementModel {
  final DateTime? txnDate;
  final String? description;
  final String? amount;

  PrepaidCardMiniStatementModel({
    this.txnDate,
    this.description,
    this.amount,
  });

  factory PrepaidCardMiniStatementModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      PrepaidCardMiniStatementModel(
        txnDate: json["txn_date"] == null
            ? null
            : DateTime.parse(json["txn_date"]).toLocal(),
        description: json["description"]?.toString() ?? "",
        amount: json["amount"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "txn_date": txnDate == null
            ? null
            : "${txnDate!.year.toString().padLeft(4, '0')}-"
                "${txnDate!.month.toString().padLeft(2, '0')}-"
                "${txnDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "amount": amount,
      };

  String get formatDate =>
      DateFormatters().dMonthYear.format(txnDate ?? getDateTime());

  String get formatAmount {
    final cleanAmount =
        amount?.replaceAll(",", "").replaceAll("+", "").replaceAll("-", "") ??
            "0.0";

    log("check --1 cleanAmount == $cleanAmount");

    double value = double.tryParse(cleanAmount) ?? 0.0;

    return PriceConverter.convertToNumberFormat(value.abs());
  }

  String get transactionType =>
      amount?.contains("-") ?? false ? "Debit" : "Credit";

  bool get isDebit => amount?.contains("-") ?? false;
}


// ============================================================
// DEMO MINI STATEMENTS
// ============================================================

List<PrepaidCardMiniStatementModel>
    prepaidCardMiniStatementModelListForModel = [
  PrepaidCardMiniStatementModel(
    description: "Swiggy",
    amount: "-450.00",
    txnDate: DateTime.now().subtract(
      const Duration(days: 1),
    ),
  ),
  PrepaidCardMiniStatementModel(
    description: "Card Recharge",
    amount: "+5000.00",
    txnDate: DateTime.now().subtract(
      const Duration(days: 2),
    ),
  ),
  PrepaidCardMiniStatementModel(
    description: "Amazon",
    amount: "-1299.00",
    txnDate: DateTime.now().subtract(
      const Duration(days: 3),
    ),
  ),
  PrepaidCardMiniStatementModel(
    description: "ATM Withdrawal",
    amount: "-2000.00",
    txnDate: DateTime.now().subtract(
      const Duration(days: 5),
    ),
  ),
  PrepaidCardMiniStatementModel(
    description: "Card Recharge",
    amount: "+10000.00",
    txnDate: DateTime.now().subtract(
      const Duration(days: 7),
    ),
  ),
  PrepaidCardMiniStatementModel(
    description: "Flipkart",
    amount: "-899.00",
    txnDate: DateTime.now().subtract(
      const Duration(days: 9),
    ),
  ),
];

