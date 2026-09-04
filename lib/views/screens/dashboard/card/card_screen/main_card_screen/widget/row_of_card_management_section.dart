import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_add_balance/card_add_balance_screen/card_add_balance_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_balance_inquiry/card_balance_inquiry_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_change_pin/card_change_pin_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/card_mini_statements_screen.dart';

class RowOFCardManagementSection extends StatelessWidget {
  const RowOFCardManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rowOfCardManagementModeList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final rowOfCardManagementModel = rowOfCardManagementModeList[index];

        return GetBuilder<CardController>(builder: (cardController) {
          return GestureDetector(
            onTap: () {
              if (cardController.isLoading) {
                return showToast(
                    message: "Loading..", toastType: ToastType.warning);
              }

              navigate(context: context, page: rowOfCardManagementModel.page);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: primaryColor,
                                ),
                                child: Icon(
                                  rowOfCardManagementModel.icon,
                                  color: white,
                                )),
                            
                            cardController.selectPrepaidCardModel?.isActive ==
                                    false
                                ? Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: greyDark.withValues(alpha: 0.60),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Text(
                          rowOfCardManagementModel.title,
                          style:
                              Helper(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: grey,
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class RowOfCardManagementModel {
  final IconData icon;
  final String title;
  final Widget page;

  RowOfCardManagementModel({
    required this.icon,
    required this.title,
    required this.page,
  });
}

List<RowOfCardManagementModel> rowOfCardManagementModeList = [
  RowOfCardManagementModel(
    icon: Icons.history_outlined,
    title: "Mini Statements",
    page: CardMimiStatementsScreen(),
  ),
  RowOfCardManagementModel(
    icon: Icons.security_rounded,
    title: "Change PIN",
    page: CardChangePinScreen(),
  ),
  RowOfCardManagementModel(
    icon: Icons.account_balance_outlined,
    title: "Balance Inquiry",
    page: CardBalanceInquiryScreen(),
  ),
  RowOfCardManagementModel(
    icon: Icons.add_card_outlined,
    title: "Add Balance",
    page: CardAddBalanceScreen(),
  ),
];
