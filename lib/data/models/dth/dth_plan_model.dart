class DhtPlanModel {
  final List<Combo>? combo;

  DhtPlanModel({
    this.combo,
  });

  factory DhtPlanModel.fromJson(Map<String, dynamic> json) => DhtPlanModel(
        combo: json["Combo"] == null
            ? []
            : List<Combo>.from(json["Combo"]!.map((x) => Combo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Combo": combo == null
            ? []
            : List<dynamic>.from(combo!.map((x) => x.toJson())),
      };
}

class Combo {
  final String? language;
  final String? packCount;
  final List<Detail>? details;

  Combo({
    this.language,
    this.packCount,
    this.details,
  });

  factory Combo.fromJson(Map<String, dynamic> json) => Combo(
        language: json["Language"],
        packCount: json["PackCount"],
        details: json["Details"] == null
            ? []
            : List<Detail>.from(
                json["Details"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Language": language,
        "PackCount": packCount,
        "Details": details == null
            ? []
            : List<dynamic>.from(details!.map((x) => x.toJson())),
      };
}

class Detail {
  final String? planName;
  final String? channels;
  final String? paidChannels;
  final String? hdChannels;
  final String? lastUpdate;
  final List<PricingList>? pricingList;

  Detail({
    this.planName,
    this.channels,
    this.paidChannels,
    this.hdChannels,
    this.lastUpdate,
    this.pricingList,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        planName: json["PlanName"],
        channels: json["Channels"],
        paidChannels: json["PaidChannels"],
        hdChannels: json["HdChannels"],
        lastUpdate: json["last_update"],
        pricingList: json["PricingList"] == null
            ? []
            : List<PricingList>.from(
                json["PricingList"]!.map((x) => PricingList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PlanName": planName,
        "Channels": channels,
        "PaidChannels": paidChannels,
        "HdChannels": hdChannels,
        "last_update": lastUpdate,
        "PricingList": pricingList == null
            ? []
            : List<dynamic>.from(pricingList!.map((x) => x.toJson())),
      };
}

class PricingList {
  final String? amount;
  final String? month;

  PricingList({
    this.amount,
    this.month,
  });

  factory PricingList.fromJson(Map<String, dynamic> json) => PricingList(
        amount: json["Amount"],
        month: json["Month"],
      );

  Map<String, dynamic> toJson() => {
        "Amount": amount,
        "Month": month,
      };
}
