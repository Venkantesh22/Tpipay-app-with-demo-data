class MerchantCollectionModel {
  final String? todayCollection;
  final String? totalCollection;

  MerchantCollectionModel({
    this.todayCollection,
    this.totalCollection,
  });

  factory MerchantCollectionModel.fromJson(Map<String, dynamic> json) =>
      MerchantCollectionModel(
        todayCollection: json["todayCollection"],
        totalCollection: json["totalCollection"],
      );

  Map<String, dynamic> toJson() => {
        "todayCollection": todayCollection,
        "totalCollection": totalCollection,
      };
}
