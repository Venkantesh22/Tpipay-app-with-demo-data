
class UpiModel {
    final int? orderId;
    final String? qrString;
    final String? amount;
    final String? payableAmount;

    UpiModel({
        this.orderId,
        this.qrString,
        this.amount,
        this.payableAmount,
    });

    factory UpiModel.fromJson(Map<String, dynamic> json) => UpiModel(
        orderId: json["order_id"],
        qrString: json["qr_string"],
        amount: json["amount"],
        payableAmount: json["payable_amount"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "qr_string": qrString,
        "amount": amount,
        "payable_amount": payableAmount,
    };
}
