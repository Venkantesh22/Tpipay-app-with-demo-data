import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/component/balance_wiget.dart';

class BalanceOverviewSection extends StatelessWidget {
  const BalanceOverviewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      List<BalanceWidgetModel> balanceWidgetList = [
        BalanceWidgetModel(
            icon: Assets.svgsCard,
            iconColor: purple,
            title: "AEPS Balance",
            amount: authController.userModel?.aepsBalanceFormat ?? ""),
        BalanceWidgetModel(
            icon: Assets.svgsUpperCrossArrow,
            iconColor: blue,
            title: "PayIn Balance",
            amount: authController.userModel?.payinBalanceFormat ?? ""),
        BalanceWidgetModel(
            icon: Assets.svgsLock,
            iconColor: origin,
            title: "Lien Balance",
            amount: authController.userModel?.lienAmountFormat ?? ""),
      ];
      List<BalanceWidgetModel> merchantCollectionModelList = [
        BalanceWidgetModel(
            icon: Assets.svgsCalender,
            iconColor: primaryColor,
            title: "Today Collection",
            amount: authController
                    .merchantCollectionModel?.todayCollectionFormate ??
                ""),
        BalanceWidgetModel(
            icon: Assets.svgsGraph,
            iconColor: cyanDark,
            title: "Total Collection",
            amount: authController
                    .merchantCollectionModel?.totalCollectionFormate ??
                ""),
      ];

      return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Balance Overview",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w700, color: greyText3),
            ),
            sizedBoxHeight(height: 16),
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: balanceWidgetList
                  .map((m) => BalanceWidget(balanceWidgetModel: m))
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Collections",
                style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: greyText3),
              ),
            ),
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: merchantCollectionModelList
                  .map((m) => BalanceWidget(balanceWidgetModel: m))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}
