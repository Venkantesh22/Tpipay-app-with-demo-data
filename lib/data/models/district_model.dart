class DistrictModel {
  final int? districtId;
  final String? districtName;

  DistrictModel({
    this.districtId,
    this.districtName,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        districtId: json["district_id"],
        districtName: json["district_name"],
      );

  Map<String, dynamic> toJson() => {
        "district_id": districtId,
        "district_name": districtName,
      };
}
