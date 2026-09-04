class CompanyModel {
  final String? companyName;
  final String? companyEmail;
  final String? companyAddress;
  final String? companyAddressTwo;
  final String? supportNumber;
  final String? whatsappNumber;
  final String? companyLogo;
  final String? companyWebsite;
  final String? news;
  final String? senderId;
  final int? viewPlan;
  final String? colorStart;
  final String? colorEnd;
  final int? transactionPin;

  CompanyModel({
    this.companyName,
    this.companyEmail,
    this.companyAddress,
    this.companyAddressTwo,
    this.supportNumber,
    this.whatsappNumber,
    this.companyLogo,
    this.companyWebsite,
    this.news,
    this.senderId,
    this.viewPlan,
    this.colorStart,
    this.colorEnd,
    this.transactionPin,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        companyName: json["company_name"],
        companyEmail: json["company_email"],
        companyAddress: json["company_address"],
        companyAddressTwo: json["company_address_two"],
        supportNumber: json["support_number"],
        whatsappNumber: json["whatsapp_number"],
        companyLogo: json["company_logo"],
        companyWebsite: json["company_website"],
        news: json["news"],
        senderId: json["sender_id"],
        viewPlan: json["view_plan"],
        colorStart: json["color_start"],
        colorEnd: json["color_end"],
        transactionPin: json["transaction_pin"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "company_email": companyEmail,
        "company_address": companyAddress,
        "company_address_two": companyAddressTwo,
        "support_number": supportNumber,
        "whatsapp_number": whatsappNumber,
        "company_logo": companyLogo,
        "company_website": companyWebsite,
        "news": news,
        "sender_id": senderId,
        "view_plan": viewPlan,
        "color_start": colorStart,
        "color_end": colorEnd,
        "transaction_pin": transactionPin,
      };
}
