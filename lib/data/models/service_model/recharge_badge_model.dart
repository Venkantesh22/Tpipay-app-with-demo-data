class RechargeBadgeModel {
  final int? id;
  final String? title;
  final List<ServiceModel>? data;

  RechargeBadgeModel({
    this.id,
    this.title,
    this.data,
  });

  factory RechargeBadgeModel.fromJson(Map<String, dynamic> json) =>
      RechargeBadgeModel(
        id: json["id"],
        title: json["title"],
        data: json["data"] == null
            ? []
            : List<ServiceModel>.from(
                json["data"]!.map((x) => ServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
  bool get isRecharges => title == "Recharges";
  bool get isCollectPayment => title == "Collect Payment";
}

class ServiceModel {
  final int? serviceId;
  final String? serviceName;
  final String? serviceImage;
  final int? bbps;
  final String? reportTitle;
  final String? reportUrl;
  final int? reportIsStatic;

  ServiceModel({
    this.serviceId,
    this.serviceName,
    this.serviceImage,
    this.bbps,
    this.reportTitle,
    this.reportUrl,
    this.reportIsStatic,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        serviceImage: json["service_image"],
        bbps: json["bbps"],
        reportTitle: json["report_title"],
        reportUrl: json["report_url"],
        reportIsStatic: json["report_is_static"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_name": serviceName,
        "service_image": serviceImage,
        "bbps": bbps,
        "report_title": reportTitle,
        "report_url": reportUrl,
        "report_is_static": reportIsStatic,
      };
  bool get isMobile => serviceName == "Mobile";
  bool get isDTH => serviceName == "DTH";
  bool get isYesBankMerchantCollection =>
      serviceName == "Yes Bank Merchant Collection";
}
