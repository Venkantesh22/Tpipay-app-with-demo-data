class WithdrawalModel {
  final String? transactionId;
  final String? amount;
  final String? processingFee;
  final String? gst;
  final String? totalCardDebit;
  final String? netAmount;
  final String? cardMasked;
  final String? cardNetwork;
  final String? cardHolderName;
  final String? cardBankName;
  final String? customerMobile;
  final bool? otpSent;

  WithdrawalModel({
    this.transactionId,
    this.amount,
    this.processingFee,
    this.gst,
    this.totalCardDebit,
    this.netAmount,
    this.cardMasked,
    this.cardNetwork,
    this.cardHolderName,
    this.cardBankName,
    this.customerMobile,
    this.otpSent,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) =>
      WithdrawalModel(
        transactionId: json["transaction_id"],
        amount: json["amount"],
        processingFee: json["processing_fee"],
        gst: json["gst"],
        totalCardDebit: json["total_card_debit"],
        netAmount: json["net_amount"],
        cardMasked: json["card_masked"],
        cardNetwork: json["card_network"],
        cardHolderName: json["card_holder_name"],
        cardBankName: json["card_bank_name"],
        customerMobile: json["customer_mobile"],
        otpSent: json["otp_sent"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "amount": amount,
        "processing_fee": processingFee,
        "gst": gst,
        "total_card_debit": totalCardDebit,
        "net_amount": netAmount,
        "card_masked": cardMasked,
        "card_network": cardNetwork,
        "card_holder_name": cardHolderName,
        "card_bank_name": cardBankName,
        "customer_mobile": customerMobile,
        "otp_sent": otpSent,
      };
}
