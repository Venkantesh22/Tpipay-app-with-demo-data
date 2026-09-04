import 'package:lekra/services/constants.dart';

class QrModel {
  final String? vpa;
  final String? qrString;
  final String? qrCodeUrl;
  final int? orderId;
  final String? amount;

  QrModel({
    this.vpa,
    this.qrString,
    this.qrCodeUrl,
    this.orderId,
    this.amount,
  });

  factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
        vpa: json["vpa"],
        qrString: json["qrString"],
        qrCodeUrl: json["qrCodeUrl"],
        orderId: json["order_id"],
        amount: json["amount"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "vpa": vpa,
        "qrString": qrString,
        "qrCodeUrl": qrCodeUrl,
        "order_id": orderId,
        "amount": amount,
      };

  String get amountFormat {
    final amountValue = double.tryParse(
      amount?.toString().replaceAll(',', '') ?? '0.0',
    );
    return PriceConverter.convert(amountValue ?? 0.0);
  }
}
