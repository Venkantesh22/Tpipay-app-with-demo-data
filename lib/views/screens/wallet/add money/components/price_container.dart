import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class PriceContainer extends StatelessWidget {
  final String price;
  final bool isSelect;

  const PriceContainer({
    super.key,
    required this.price,
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 17),
      decoration: BoxDecoration(
        color: isSelect ? primaryColor : Color(0xFFE2FEE9),
        border: Border.all(color: primaryColor),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 8),
              spreadRadius: 0,
              blurRadius: 10,
              color: black.withValues(alpha: 0.1))
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "₹ $price",
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isSelect ? white : black,
              ),
        ),
      ),
    );
  }
}

class PriceContainerModel {
  final String price;
  final bool isSelect;

  PriceContainerModel({required this.price, required this.isSelect});
}

List<PriceContainerModel> priceContainerModelList = [
  PriceContainerModel(price: "500", isSelect: false),
  PriceContainerModel(price: "1000", isSelect: false),
  PriceContainerModel(price: "2000", isSelect: false),
  PriceContainerModel(price: "5000", isSelect: false),
];
