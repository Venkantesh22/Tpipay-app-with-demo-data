class DhtCustomerInfoModel {
  final String? vc;
  final String? name;
  final String? rmn;
  final String? balance;
  final String? monthly;
  final DateTime? nextRechargeDate;
  final String? plan;
  final String? address;
  final String? city;
  final String? district;
  final String? state;
  final String? pinCode;

  DhtCustomerInfoModel({
    this.vc,
    this.name,
    this.rmn,
    this.balance,
    this.monthly,
    this.nextRechargeDate,
    this.plan,
    this.address,
    this.city,
    this.district,
    this.state,
    this.pinCode,
  });

  factory DhtCustomerInfoModel.fromJson(Map<String, dynamic> json) =>
      DhtCustomerInfoModel(
        vc: json["VC"],
        name: json["Name"],
        rmn: json["Rmn"],
        balance: json["Balance"],
        monthly: json["Monthly"],
        nextRechargeDate: json["Next Recharge Date"] == null
            ? null
            : DateTime.parse(json["Next Recharge Date"]),
        plan: json["Plan"],
        address: json["Address"],
        city: json["City"],
        district: json["District"],
        state: json["State"],
        pinCode: json["PIN Code"],
      );

  Map<String, dynamic> toJson() => {
        "VC": vc,
        "Name": name,
        "Rmn": rmn,
        "Balance": balance,
        "Monthly": monthly,
        "Next Recharge Date":
            "${nextRechargeDate!.year.toString().padLeft(4, '0')}-${nextRechargeDate!.month.toString().padLeft(2, '0')}-${nextRechargeDate!.day.toString().padLeft(2, '0')}",
        "Plan": plan,
        "Address": address,
        "City": city,
        "District": district,
        "State": state,
        "PIN Code": pinCode,
      };
}
