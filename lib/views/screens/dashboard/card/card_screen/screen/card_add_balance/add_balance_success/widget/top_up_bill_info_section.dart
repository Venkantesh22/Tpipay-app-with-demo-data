import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/copy_text.dart';
import 'package:lekra/services/theme.dart';

class TopUpSuccessBillInfoSection extends StatelessWidget {
  const TopUpSuccessBillInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      final _topUpSuccessModelList =
          topUpSuccessModelList(cardController: cardController);

      return Column(
        children: [
          SizedBox(height: 40),
          Row(
            children: [
              SvgPicture.asset(
                Assets.svgsBill2,
              ),
              SizedBox(width: 14),
              Text(
                overflow: TextOverflow.clip,
                "Transaction Details",
                style: Helper(context).textTheme.displayLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: blueDark,
                    ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final topUpSuccessModel = _topUpSuccessModelList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.start,
                        topUpSuccessModel.title,
                        style: Helper(context).textTheme.displayLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: purpleLight,
                            ),
                      ),
                    ),
                    topUpSuccessModel.status == true
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: primaryColor.withValues(alpha: 0.10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: primaryColor,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Success",
                                  style: Helper(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                )
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.end,
                                "${topUpSuccessModel.isMobile == true ? "+91" : ""}  ${topUpSuccessModel.info}",
                                style: Helper(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: blueDark,
                                    ),
                              ),
                              topUpSuccessModel.orderIdOtCopy == true
                                  ? IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        copyText(text: topUpSuccessModel.info);
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        color: grey,
                                        size: 16,
                                      ))
                                  : SizedBox(),
                            ],
                          ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 16),
            itemCount: _topUpSuccessModelList.length,
          )
        ],
      );
    });
  }
}

class TopUpSuccessModel {
  final String title;
  final String info;
  final bool? orderIdOtCopy;
  final bool? status;
  final bool? isMobile;

  TopUpSuccessModel({
    required this.title,
    required this.info,
    this.orderIdOtCopy,
    this.status,
    this.isMobile,
  });
}

List<TopUpSuccessModel> topUpSuccessModelList(
        {required CardController cardController}) =>
    [
      TopUpSuccessModel(
          title: "Name",
          info: cardController.selectPrepaidCardModel?.nameOnCard ?? ""),
      TopUpSuccessModel(
        title: "Order ID",
        info: "OR9886740997i7",
        orderIdOtCopy: true,
      ),
      TopUpSuccessModel(
        title: "Card Ref No",
        info: cardController.selectPrepaidCardModel?.cardRefId.toString() ?? "",
      ),
      TopUpSuccessModel(
        title: "Mobile Number",
        info:
            "+91 ${cardController.prepaidDetailsModel?.mobileNumber.toString() ?? ""}",
        isMobile: true,
      ),
      TopUpSuccessModel(
        title: "Status",
        info: "Success",
        status: true,
      ),
    ];
