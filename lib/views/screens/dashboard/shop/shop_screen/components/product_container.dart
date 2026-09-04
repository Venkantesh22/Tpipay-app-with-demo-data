import 'package:flutter/material.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class ProductContainer extends StatelessWidget {
  final ProductModel? productModel;
  const ProductContainer({
    super.key,
    this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.1),
            )
          ]),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            decoration: BoxDecoration(
                color: white2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                      blurRadius: 7,
                      color: black.withValues(alpha: 0.25))
                ]),
            child: CustomImage(
              path: productModel?.productImage ?? "",
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              radius: 8,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productModel?.productName ?? "",
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // productModel?.productPriceFormat ?? "",
                productModel?.productName == "Sound box"
                    ? "₹ 1,299.00"
                    : productModel?.productName == "Standee"
                        ? "₹ 599"
                        : productModel?.productPriceFormat ?? "",
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
