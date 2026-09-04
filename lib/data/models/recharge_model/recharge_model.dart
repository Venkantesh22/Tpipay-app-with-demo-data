import 'package:lekra/services/constants.dart';

class RechargeModel {
  final String? rechargeTitle;
  final List<RechargePackageDataModel>? rechargePackageDataModelList;
  

  RechargeModel({
    this.rechargeTitle,
    this.rechargePackageDataModelList,
  });

  factory RechargeModel.fromJson(Map<String, dynamic> json) {
    final list = <RechargePackageDataModel>[];
    final rawList = json['rechargePackageDataModelList'];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          list.add(RechargePackageDataModel.fromJson(item));
        } else if (item is Map) {
          list.add(RechargePackageDataModel.fromJson(
              Map<String, dynamic>.from(item)));
        }
      }
    }
    return RechargeModel(
      rechargeTitle: json['rechargeTitle'] as String? ?? '',
      rechargePackageDataModelList: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'rechargeTitle': rechargeTitle,
        'rechargePackageDataModelList':
            rechargePackageDataModelList?.map((e) => e.toJson()).toList(),
      };

  /// Helper to convert API `data` map (categoryName -> list of plans)
  /// into List<RechargeModel>
  static List<RechargeModel> listFromApiMap(Map<String, dynamic>? apiData) {
    if (apiData == null) return <RechargeModel>[];
    final out = <RechargeModel>[];
    apiData.forEach((categoryName, rawList) {
      final packages = <RechargePackageDataModel>[];
      if (rawList is List) {
        for (final item in rawList) {
          if (item is Map<String, dynamic>) {
            packages.add(RechargePackageDataModel.fromJson(item));
          } else if (item is Map) {
            packages.add(RechargePackageDataModel.fromJson(
                Map<String, dynamic>.from(item)));
          }
        }
      }
      out.add(RechargeModel(
          rechargeTitle: categoryName, rechargePackageDataModelList: packages));
    });
    return out;
  }
}

class RechargePackageDataModel {
  final int? rs;
  final String? validity;
  final String? desc;

  RechargePackageDataModel({
    this.rs,
    this.validity,
    this.desc,
  });

  /// Defensive parser for `rs`
  static int? _parseRs(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9\-]'), '');
      if (cleaned.isEmpty) return null;
      return int.tryParse(cleaned);
    }
    return null;
  }

  factory RechargePackageDataModel.fromJson(Map<String, dynamic> json) {
    return RechargePackageDataModel(
      rs: _parseRs(json['rs']),
      validity: json['validity'] as String?,
      desc: json['desc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (rs != null) map['rs'] = rs;
    if (validity != null) map['validity'] = validity;
    if (desc != null) map['desc'] = desc;
    return map;
  }

  String get rsFormat => PriceConverter.convertToNumberFormat(rs ?? 0.0);
}
