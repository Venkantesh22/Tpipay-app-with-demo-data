import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/main_card_screen.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/when_user_otp_pending/when_user_otp_pending_screen.dart';
import 'package:lekra/views/screens/dashboard/card/form_for_apply_card/form_for_apply_card_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/home_screen.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/service_screen.dart';
import 'package:lekra/views/screens/dashboard/shop/shop_screen/shop_screen.dart';
import 'package:lekra/views/screens/transcation_history/transaction_history_screen.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DashBoardController>(
        builder: (DashBoardController controller) {
          return [
            const HomeScreen(
              isReload: true,
            ),
            ShopScreen(),
            ServiceScreen(),
            // FormForApplyCardScreen(),
            MainCardScreen(),
            // WhenUserOtpPendingScreen(),
            TransactionHistoryScreen(
              fromDateValue: DateTime(2024, 1, 1),
              todateValue: getDateTime(),
            )
          ][controller.dashPage];
        },
      ),
      bottomNavigationBar: GetBuilder<DashBoardController>(
        builder: (DashBoardController controller) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: backgroundLight,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNavigationItemWidget(
                    onTap: () {
                      controller.dashPage = 0;
                    },
                    title: 'Home',
                    icon: Assets.svgsHome,
                    isActive: controller.dashPage == 0 ? true : false,
                  ),
                  BottomNavigationItemWidget(
                    onTap: () {
                      controller.dashPage = 1;
                    },
                    title: 'shop',
                    icon: Assets.svgsShop,
                    isActive: controller.dashPage == 1 ? true : false,
                  ),
                  BottomNavigationItemWidget(
                    onTap: () {
                      controller.dashPage = 2;
                    },
                    title: 'Services',
                    icon: Assets.svgsService,
                    isActive: controller.dashPage == 2 ? true : false,
                  ),
                  BottomNavigationItemWidget(
                    onTap: () {
                      controller.dashPage = 3;
                    },
                    title: 'Card',
                    icon: Assets.svgsCard,
                    isActive: controller.dashPage == 3 ? true : false,
                  ),
                  BottomNavigationItemWidget(
                    onTap: () {
                      controller.dashPage = 4;
                    },
                    title: 'Report',
                    icon: Assets.svgsReport,
                    isActive: controller.dashPage == 4 ? true : false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

///
class BottomNavigationItemWidget extends StatelessWidget {
  const BottomNavigationItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  final String title;
  final String icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 4,
            ),
            SvgPicture.asset(
              icon,
              width: icon.contains('logout') ? 20 : 24,
              height: icon.contains('logout') ? 20 : 24,
              colorFilter: ColorFilter.mode(
                  isActive ? primaryColor : Colors.black87, BlendMode.srcIn),
            ),
            sizedBoxHeight(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isActive ? primaryColor : const Color(0xFF393648),
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            isActive
                ? const CircleAvatar(
                    radius: 4,
                    backgroundColor: primaryColor,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
