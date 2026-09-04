import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';

class CardMiniStatementsFilterSection extends StatelessWidget {
  const CardMiniStatementsFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      final _cardTransFilterList =
          cardTransFilterList(cardController: cardController);
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 33),
        child: SizedBox(
          height: 32,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CustomButton(
                    height: 32,
                    borderColor:  secondaryColor  ,
                    color: secondaryColor,
                    radius: 99,
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgsFilter3,
                          height: 10.5,
                          width: 10.5,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Filters",
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: white,
                              ),
                        ),
                      ],
                    ),
                  );
                }
                final _cardTransFilterModel = _cardTransFilterList[index - 1];

                return CustomButton(
                  onTap: _cardTransFilterModel.onTap,
                  color: primaryColor.withValues(alpha: 0.10),
                  borderColor: primaryColor.withValues(alpha: 0.30),
                  radius: 999,
                  child: Text(
                    _cardTransFilterModel.title,
                    style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryColor),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(width: 15.5),
              itemCount: _cardTransFilterList.length + 1),
        ),
      );
    });
  }
}

class CardTransFilterModel {
  final int id;
  final String title;
  final bool isSelect;
  final Function()? onTap;

  CardTransFilterModel({
    required this.title,
    required this.isSelect,
    required this.onTap, required this.id,
  });
}

List<CardTransFilterModel> cardTransFilterList(
        {required CardController cardController}) =>
    [
      CardTransFilterModel(
        id: 1,
          title: "Debit/Credit",
          isSelect:  false,
          onTap: () {}),
      CardTransFilterModel(
        id: 2,
          title: "Amount",
          isSelect:  false,
          onTap: () {}),
      CardTransFilterModel(
        id: 3,
          title: "Date",
          isSelect:  false,
          onTap: () {}),
    ];
