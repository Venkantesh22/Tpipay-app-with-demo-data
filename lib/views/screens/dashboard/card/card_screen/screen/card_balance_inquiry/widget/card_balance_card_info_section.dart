import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardBalanceInquCardInfoSection extends StatelessWidget {
  const CardBalanceInquCardInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      final list = topUpSuccessModelList(cardController);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Card Details",
            style: Helper(context).textTheme.displayLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: blueDark,
                ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                  color: black.withValues(alpha: 0.05),
                )
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final balanceInfoModel = list[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.start,
                          balanceInfoModel.title,
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: purpleLight,
                                  ),
                        ),
                      ),
                      Row(
                        children: [
                          balanceInfoModel.status == true
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SvgPicture.asset(
                                      Assets.svgsCheckMarkInCrossCirlce2),
                                )
                              : SizedBox(),
                          Text(
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.end,
                            balanceInfoModel.info,
                            style: Helper(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: balanceInfoModel.status == true
                                      ? primaryColor
                                      : blueDark,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 16),
              itemCount: list.length,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: primaryColor.withValues(
                  alpha: 0.20,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: primaryColor,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.clip,
                    "This balance is updated in real-time. If you notice any discrepancies, please contact support immediately or lock your card via settings.",
                    style: Helper(context).textTheme.displayLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: greyText6,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}

class BalanceInfoModel {
  final String title;
  final String info;

  final bool? status;

  BalanceInfoModel({
    required this.title,
    required this.info,
    this.status,
  });
}


List<BalanceInfoModel> topUpSuccessModelList(CardController cardController) {
  return [
    BalanceInfoModel(
      title: "Card Reference",
      info:
          "XXXX-XXXX-${cardController.selectPrepaidCardModel?.lastFourDigit?.toString()}",
    ),
    BalanceInfoModel(
      title: "Status",
      info: cardController.selectPrepaidCardModel?.isActive == true
          ? "Active"
          : "Inactive",
      status: cardController.selectPrepaidCardModel?.isActive == true,
    ),
  ];
}
