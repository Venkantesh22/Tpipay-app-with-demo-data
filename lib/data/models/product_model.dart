import 'package:lekra/services/constants.dart';

class ProductModel {
  final int? productId;
  final String? pageTitle;
  final String? productImage;
  final String? productName;
  final String? description;
  final int? productPrice;

  ProductModel({
    this.productId,
    this.pageTitle,
    this.productImage,
    this.productName,
    this.description,
    this.productPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["product_id"],
        pageTitle: json["page_title"],
        productImage: json["product_image"],
        productName: json["product_name"],
        description: json["description"],
        productPrice: json["product_price"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "page_title": pageTitle,
        "product_image": productImage,
        "product_name": productName,
        "description": description,
        "product_price": productPrice,
      };

  String get productPriceFormat =>
      PriceConverter.convertToNumberFormat(productPrice ?? 0.0).replaceAll(',', '');
}
