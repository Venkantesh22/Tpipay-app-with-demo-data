import 'package:lekra/services/constants.dart';

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

  String get todayCollectionFormate => PriceConverter.convertToNumberFormat(
      double.parse((todayCollection ?? "0.0").replaceAll(',', '')));

  String get totalCollectionFormate => PriceConverter.convertToNumberFormat(
      double.parse((totalCollection ?? "0.0").replaceAll(',', '')));
}
