import 'package:flutter/material.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';

import '../../services/theme.dart';

class TransactionModel {
  final int? id;
  final int? serviceId;
  final String? serviceName;
  final String? user;
  final String? providerIcon;
  final DateTime? createdAt;
  final String? provider;
  final String? number;
  final String? txnid;
  final String? openingBalance;
  final String? amount;
  final String? profit;
  final String? totalBalance;
  final TransactionStatus? status;

  TransactionModel({
    this.id,
    this.serviceId,
    this.serviceName,
    this.user,
    this.providerIcon,
    this.createdAt,
    this.provider,
    this.number,
    this.txnid,
    this.openingBalance,
    this.amount,
    this.profit,
    this.totalBalance,
    this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        user: json["user"],
        providerIcon: json["provider_icon"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        provider: json["provider"],
        number: json["number"],
        txnid: json["txnid"],
        openingBalance: json["opening_balance"],
        amount: json["amount"],
        profit: json["profit"],
        totalBalance: json["total_balance"],
        // Safely map status; if unknown, keep null
        status: statusValues.map[json["status"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "service_name": serviceName,
        "user": user,
        "provider_icon": providerIcon,
        "created_at": createdAt?.toIso8601String(),
        "provider": provider,
        "number": number,
        "txnid": txnid,
        "opening_balance": openingBalance,
        "amount": amount,
        "profit": profit,
        "total_balance": totalBalance,
        "status": status != null ? statusValues.reverse[status] : null,
      };

  String get amountFormat => PriceConverter.convertToNumberFormat(
      double.tryParse((amount ?? "0.0").replaceAll(',', '')) ?? 0.0);

  String get openingBalanceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse((openingBalance ?? "0.0").replaceAll(',', '')) ?? 0.0);

  String get totalBalanceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse((totalBalance ?? "0.0").replaceAll(',', '')) ?? 0.0);

  String get dateFormat =>
      DateFormatters().dateTime.format(createdAt ?? DateTime.now());

  String get isAddORMinus {
    switch (status) {
      case TransactionStatus.CREDIT:
        return "+ ";
      case TransactionStatus.FAILURE:
        return "";
      case TransactionStatus.SUCCESS:
        return "+";
      case TransactionStatus.PENDING:
        return "";
      default:
        return "";
    }
  }

  String? get showIcon {
    switch (status) {
      case TransactionStatus.CREDIT:
        return Assets.svgsArrowDown;
      case TransactionStatus.FAILURE:
        return Assets.svgsFailure;
      case TransactionStatus.SUCCESS:
        return Assets.svgsArrowDown;
      case TransactionStatus.PENDING:
        return Assets.svgsPending;
      default:
        return Assets.svgsLogOut;
    }
  }

  Color get amountStatusColor {
    switch (status) {
      case TransactionStatus.SUCCESS:
        return primaryColor;
      case TransactionStatus.PENDING:
        return yellow;
      case TransactionStatus.FAILURE:
        return red;
      case TransactionStatus.CREDIT:
        return primaryColor;
      default:
        return black;
    }
  }

  String get statusText {
    switch (status) {
      case TransactionStatus.SUCCESS:
        return "Success";
      case TransactionStatus.PENDING:
        return "Pending";
      case TransactionStatus.FAILURE:
        return "Failure";
      case TransactionStatus.CREDIT:
        return "Credit";
      default:
        return "";
    }
  }

  Color get statusColor {
    switch (status) {
      case TransactionStatus.SUCCESS:
        return primaryColor;
      case TransactionStatus.PENDING:
        return black;
      case TransactionStatus.FAILURE:
        return red;

      case TransactionStatus.CREDIT:
        return primaryColor;
      default:
        return primaryColor;
    }
  }

  bool get isYesBankTrans => provider == "Yes Bank Merchant Collection";
}

enum TransactionStatus {
  CREDIT,
  FAILURE,
  PENDING,
  SUCCESS,
  REFUNDED,
  REFUND_FAILURE
}

final statusValues = EnumValues({
  "Credit": TransactionStatus.CREDIT,
  "Failure": TransactionStatus.FAILURE,
  "Pending": TransactionStatus.PENDING,
  "Success": TransactionStatus.SUCCESS,
  "Refunded": TransactionStatus.REFUNDED,
  "Refund Failure": TransactionStatus.REFUND_FAILURE,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
