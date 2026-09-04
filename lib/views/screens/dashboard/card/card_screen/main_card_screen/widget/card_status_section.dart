import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardStatusSection extends StatelessWidget {
  const CardStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardController.selectPrepaidCardModel?.isActive ?? false
              ? primaryColorLight
              : whiteAntiFlash,
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.all(color: grey.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status",
                    style: Helper(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: purpleLight,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    cardController.selectPrepaidCardModel?.cardStates ?? "",
                    style: Helper(context).textTheme.displayLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              cardController.selectPrepaidCardModel?.isActive ??
                                      false
                                  ? primaryColor
                                  : purpleLight,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      cardController.selectPrepaidCardModel?.isActive ?? false
                          ? primaryColor
                          : Color(0xFF94A3B8),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: cardController.selectPrepaidCardModel?.isActive ??
                              false
                          ? primaryColor
                          : Color(0xFF94A3B8).withValues(alpha: 0.50),
                    )
                  ]),
            )
          ],
        ),
      );
    });
  }
}
