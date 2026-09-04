import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class BalanceWidget extends StatelessWidget {
  final BalanceWidgetModel balanceWidgetModel;
  const BalanceWidget({
    super.key,
    required this.balanceWidgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -1,
                color: black.withValues(alpha: 0.1)),
            BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
                color: black.withValues(alpha: 0.1)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: balanceWidgetModel.iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
            child: SvgPicture.asset(
              balanceWidgetModel.icon,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                  balanceWidgetModel.iconColor, BlendMode.srcIn),
            ),
          ),
          sizedBoxHeight(height: 16),
          Text(
            balanceWidgetModel.title,
            overflow: TextOverflow.clip,
            style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 12, fontWeight: FontWeight.w400, color: greyText2),
          ),
          sizedBoxHeight(height: 6),
          Text(
            balanceWidgetModel.amount,
            style: Helper(context).textTheme.titleSmall?.copyWith(
                fontSize: 20, fontWeight: FontWeight.w700, color: greyText2),
          ),
        ],
      ),
    );
  }
}

class BalanceWidgetModel {
  final String icon;
  final Color iconColor;
  final String title;
  final String amount;

  BalanceWidgetModel(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.amount});
}
