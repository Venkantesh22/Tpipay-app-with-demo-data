import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controlller.dart';
import 'package:lekra/controllers/report_contoller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/card_widget.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/graph.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/income_overview_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/recharge_and_pay_section.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/transaction_history_section.dart';
import 'package:lekra/views/screens/drawer_screen/drawer_screen.dart';
import 'package:lekra/views/screens/wallet/wallet_screen/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isReload;
  const HomeScreen({super.key, this.isReload = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("initState tap");

      final auth = Get.find<AuthController>();
//  final sharedPreferences =        SharedPreferences.getInstance();
      final reportContro = Get.find<ReportController>();

      if (widget.isReload) {
        auth.checkBalance().then((value) {
          if (value.isSuccess) {
            if (auth.userModel?.isKYCDone ?? false) {
              Get.find<BasicController>().postGenerateQR();
            }

            final dateFormat = DateFormat('yyyy-MM-dd');

            Get.find<ReportController>()
                .fetchYesBankMerchantCollection(
              fromdate: dateFormat.format(getDateTime()),
              todate: dateFormat.format(getDateTime()),
            )
                .then((value) {
              if (value.isSuccess) {
                reportContro.convertTODataForGraph(
                    reportContro.yesBankMerchantCollectionList);
              }
            });

            reportContro.fetchTransactionReport(
                fromdate: dateFormat.format(getDateTime()),
                todate: dateFormat.format(getDateTime()),
                isShowOnly10: true);
          } else {
            auth.logout(context);
            navigate(context: context, page: LoginScreen());
          }
        });
      }
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const SafeArea(
        child: DrawerScreen(),
      ),
      appBar: AppBar(
        backgroundColor: white,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: secondaryColor,
            )),
        title: CustomText(
          "Tpipay Merchant",
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: secondaryColor,
              ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              navigate(context: context, page: const WalletScreen());
            },
            child: SvgPicture.asset(
              Assets.svgsWallet,
              height: 24.h,
              width: 24.w,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(
            width: 28,
          )
        ],
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        if (authController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // CardWidget(),
              // SizedBox(
              //   height: 21,
              // ),
              RechargeAndPaySection(),
              SizedBox(
                height: 20,
              ),
              IncomeOverviewSection(),
              TodayHourlyGraph(),
              SizedBox(
                height: 31,
              ),
              TransactionHistoryWidget()
            ],
          ),
        );
      }),
    );
  }
}
